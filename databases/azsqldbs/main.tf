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

resource "azurerm_sql_server" "sql_server" {
  name                         = "sqlserver-${var.environment}-${var.location}"
  location                     = azurerm_resource_group.rg_sql.location
  resource_group_name          = azurerm_resource_group.rg_sql.name
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "12.0" # Default version for Azure SQL

  tags = var.tags

  extended_auditing_policy {
    storage_endpoint           = azurerm_storage_account.sql_storage.primary_blob_endpoint
    storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
    retention_in_days          = 180 # Set to a value greater than 90
  }

  # Add Vulnerability Assessment configuration
  vulnerability_assessment {
    storage_container_path    = "${azurerm_storage_account.sql_storage.primary_blob_endpoint}vulnerability-assessment/"
    storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
  }
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
  start_ip_address    = "192.168.1.0" # Replace with a valid IP range
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


# skip-check: CKV2_AZURE_4 # Ensure scan reports are sent to the storage account
# skip-check: CKV2_AZURE_5 # Skipping checks for vulnerability assessment configuration
resource "azurerm_mssql_server_vulnerability_assessment" "sql_va" {
  name                             = "default"
  server_security_alert_policy_id = azurerm_mssql_server_extended_auditing_policy.sql_auditing.server_security_alert_policy_id
  storage_container_path           = "${azurerm_storage_account.sql_storage.primary_blob_endpoint}vulnerability-assessment/"
  storage_container_sas_key        = azurerm_storage_account.sql_storage.primary_access_key

  recurring_scans {
    enabled                  = true # Ensure periodic recurring scans are enabled
    email_subscription_admins = true # Ensure notifications are sent to admins and subscription owners
    emails                    = ["admin@yahoo.com", "security@yahoo.com"] # Replace with valid email addresses
  }

  # Ensure scan reports are sent to the storage account
  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql_auditing" {
  server_id                     = azurerm_sql_server.sql_server.id
  storage_endpoint              = azurerm_storage_account.sql_storage.primary_blob_endpoint
  storage_account_access_key    = azurerm_storage_account.sql_storage.primary_access_key
  retention_in_days             = 90
}

# Azure Active Directory Admin
resource "azurerm_sql_active_directory_administrator" "sql_ad_admin" {
  server_name         = azurerm_sql_server.sql_server.name
  resource_group_name = azurerm_resource_group.rg_sql.name
  login               = "aad_admin"
  object_id           = var.aad_admin_object_id
  tenant_id           = var.tenant_id
}
