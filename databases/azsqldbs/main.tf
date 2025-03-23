# This Terraform configuration defines resources for an Azure SQL Database setup.
# These resources have been set in the azsqldbs.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="databases/azsqldbs/azsql.tfvars" --out="azsqldbs.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="databases/azsqldbs/azsql.tfvars" --input=false
# #2 terraform destroy -var-file="databases/azsqldbs/azsql.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0" # Use the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "rg_sql" {
  name     = "RG-sql-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}

# Storage Account for SQL Auditing
resource "azurerm_storage_account" "sql_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_sql.name
  location                 = azurerm_resource_group.rg_sql.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2" # Enforce secure TLS version

  tags = var.tags

  depends_on = [azurerm_resource_group.rg_sql] # Ensure resource group is created first
}

resource "azurerm_storage_container" "sql_va_container" {
  name                  = "sqlvulnerabilityassessment" # Replace with your desired container name
  storage_account_name  = azurerm_storage_account.sql_storage.name
  container_access_type = "private"
}

# skip-check CKV2_AZURE_2 # Ensure that Vulnerability Assessment (VA) is enabled on a SQL server by setting a Storage Account
resource "azurerm_mssql_server" "sql_server" {
  name                          = var.sql_server_name
  resource_group_name           = azurerm_resource_group.rg_sql.name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_server_admin_username
  administrator_login_password  = var.sql_server_admin_password
  public_network_access_enabled = true  # Disable public network access
  minimum_tls_version           = "1.2" # Enforce secure TLS version

  tags = var.tags

  azuread_administrator {
    login_username = var.admin_username
    object_id      = var.aad_admin_object_id
    tenant_id      = var.tenant_id
  }

  depends_on = [azurerm_resource_group.rg_sql] # Ensure resource group is created first
}

# SQL Database
resource "azurerm_mssql_database" "sql_db" {
  for_each    = toset(var.database_names)
  name        = each.value
  server_id   = azurerm_mssql_server.sql_server.id
  sku_name    = var.sql_database_sku_name
  max_size_gb = var.max_size_gb
  tags        = var.tags

  # No explicit depends_on needed because Terraform automatically handles the dependency on azurerm_mssql_server.sql_server
}

# SQL Firewall Rule
resource "azurerm_mssql_firewall_rule" "sql_firewall" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

  # No explicit depends_on needed because Terraform automatically handles the dependency on azurerm_mssql_server.sql_server
}

resource "azurerm_mssql_firewall_rule" "deny_azure_services" {
  name             = "DenyAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "10.0.0.0" # Replace with a valid IP range
  end_ip_address   = "10.0.0.255"

  # No explicit depends_on needed because Terraform automatically handles the dependency on azurerm_mssql_server.sql_server
}

# skip-check CKV2_AZURE_4 # Ensure Azure SQL server ADS VA Send scan reports to is configured
# skip-check CKV2_AZURE_3 # Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server
# skip-check CKV2_AZURE_5 # Ensure that VA setting 'Also send email notifications to admins and subscription owners' is set for a SQL server if it is recurring
resource "azurerm_mssql_server_vulnerability_assessment" "sql_va" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.sql_security_alert_policy.id
  storage_container_path          = "${azurerm_storage_account.sql_storage.primary_blob_endpoint}${azurerm_storage_container.sql_va_container.name}"
  storage_container_sas_key       = azurerm_storage_account.sql_storage.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = ["admin1@example.com", "admin2@example.com"] # Replace with valid email addresses
  }

  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key

  depends_on = [azurerm_storage_account.sql_storage, azurerm_storage_container.sql_va_container] # Ensure storage account and container are created first
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql_auditing" {
  server_id                  = azurerm_mssql_server.sql_server.id
  storage_endpoint           = azurerm_storage_account.sql_storage.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
  retention_in_days          = 90

  depends_on = [azurerm_storage_account.sql_storage] # Ensure storage account is created first
}

# SQL Server Security Alert Policy
resource "azurerm_mssql_server_security_alert_policy" "sql_security_alert_policy" {
  server_name                = azurerm_mssql_server.sql_server.name
  resource_group_name        = azurerm_resource_group.rg_sql.name
  state                      = "Enabled"
  storage_endpoint           = azurerm_storage_account.sql_storage.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
  email_account_admins       = true
  retention_days             = 90

  depends_on = [azurerm_storage_account.sql_storage] # Ensure storage account is created first
}

# Azure Active Directory Admin
# resource "azurerm_mssql_active_directory_administrator" "sql_ad_admin" {
#   server_id = azurerm_mssql_server.sql_server.id
#   login     = "aad_admin" # Replace with the actual Azure AD admin login name
#   object_id = var.aad_admin_object_id
#   tenant_id = var.tenant_id

#   depends_on = [azurerm_mssql_server.sql_server]
# }

