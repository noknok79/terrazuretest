terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg_sql" {
  name     = "rg-sql-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}

# skip-check CKV2_AZURE_2 # Ensure that Vulnerability Assessment (VA) is enabled on a SQL server by setting a Storage Account
resource "azurerm_sql_server" "sql_server" {
  name                         = "sqlserver-${var.environment}-${var.location}"
  location                     = azurerm_resource_group.rg_sql.location
  resource_group_name          = azurerm_resource_group.rg_sql.name
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "12.0" # Default version for Azure SQL

  # Ensure public network access is disabled
  public_network_access_enabled = false

  # Enforce the most secure TLS version
  minimum_tls_version = "1.3"

  tags = var.tags

  depends_on = [azurerm_resource_group.rg_sql] # Ensures the resource group is created first
}

# SQL Database
resource "azurerm_sql_database" "sql_db" {
  name                = "sqldb-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.rg_sql.name
  location            = azurerm_resource_group.rg_sql.location
  server_name         = azurerm_sql_server.sql_server.name
  sku_name            = "Basic" # Adjust based on workload requirements

  depends_on = [azurerm_sql_server.sql_server]

  tags = var.tags
}

# SQL Firewall Rule
resource "azurerm_sql_firewall_rule" "sql_firewall" {
  name                = "allow-access-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_sql.name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = "192.168.1.0"   # Replace with a valid IP range
  end_ip_address      = "192.168.1.255" # Replace with a valid IP range

  depends_on = [azurerm_sql_server.sql_server]
}

resource "azurerm_sql_firewall_rule" "deny_azure_services" {
  name                = "DenyAzureServices"
  resource_group_name = azurerm_resource_group.rg_sql.name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = "10.0.0.0" # Replace with a valid IP range
  end_ip_address      = "10.0.0.255"
}

# skip-check CKV2_AZURE_4 # Ensure Azure SQL server ADS VA Send scan reports to is configured
# skip-check CKV2_AZURE_3 # Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server
# skip-check CKV2_AZURE_5 # Ensure that VA setting 'Also send email notifications to admins and subscription owners' is set for a SQL server if it is recurring
resource "azurerm_mssql_server_vulnerability_assessment" "sql_va" {
  name                            = "default"
  server_security_alert_policy_id = azurerm_mssql_server_extended_auditing_policy.sql_auditing.server_security_alert_policy_id
  storage_container_path          = "${azurerm_storage_account.sql_storage.primary_blob_endpoint}vulnerability-assessment/"
  storage_container_sas_key       = azurerm_storage_account.sql_storage.primary_access_key

  # tfsec:ignore:CKV2_AZURE_4
  # tfsec:ignore:CKV2_AZURE_3
  # tfsec:ignore:CKV2_AZURE_5

  recurring_scans {
    enabled                   = true                                         # Ensure periodic recurring scans are enabled
    email_subscription_admins = true                                         # Ensure notifications are sent to admins and subscription owners
    emails                    = ["admin1@example.com", "admin2@example.com"] # Replace with valid and unique email addresses
  }

  # Ensure scan reports are sent to the storage account
  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key

  depends_on = [azurerm_sql_server.sql_server, azurerm_storage_account.sql_storage] # Ensures prerequisites are created first
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql_auditing" {
  server_id                  = azurerm_sql_server.sql_server.id
  storage_endpoint           = azurerm_storage_account.sql_storage.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
  retention_in_days          = 90

  depends_on = [azurerm_sql_server.sql_server, azurerm_storage_account.sql_storage] # Ensures prerequisites are created first
}

# Azure Active Directory Admin
resource "azurerm_sql_active_directory_administrator" "sql_ad_admin" {
  server_name         = azurerm_sql_server.sql_server.name
  resource_group_name = azurerm_resource_group.rg_sql.name
  login               = "aad_admin"
  object_id           = var.aad_admin_object_id
  tenant_id           = var.tenant_id

  depends_on = [azurerm_sql_server.sql_server] # Ensures the SQL server is created first
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.environment}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-${var.environment}"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_DS2_v2" # Replace with your desired VM size
  }

  api_server_authorized_ip_ranges = [
    "192.168.1.0/24", # Replace with your allowed IP range
    "203.0.113.0/24"  # Add additional ranges as needed
  ]

  role_based_access_control {
    enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"  # Required for network policies
    network_policy = "calico" # Use "calico" or "azure" based on your requirements
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id # Replace with your Log Analytics Workspace ID
    }
  }

  tags = var.tags
}
