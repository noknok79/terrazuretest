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
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.64.0" # Upgrade to the latest compatible version
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
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Random String for Unique Suffix
resource "random_string" "random_suffix" {
  length  = 10
  upper   = false
  special = false
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_sql.name
  address_space       = var.vnet_address_space

  tags = var.tags

  depends_on = [
    azurerm_resource_group.rg_sql
  ] # Ensure the resource group is created first
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg_sql.name # Use the resource group created by Terraform
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix

  depends_on = [azurerm_resource_group.rg_sql,
    azurerm_virtual_network.vnet] # Ensure the virtual network and resource group are created first
}

# Storage Account for SQL Auditing
resource "azurerm_storage_account" "sql_storage" {
  name                     = "sqlstoragetest${random_string.random_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_sql.name
  location                 = azurerm_resource_group.rg_sql.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2" # Enforce secure TLS version

  tags = var.tags

  depends_on = [azurerm_resource_group.rg_sql] # Ensure resource group is created first
}

# Updated Storage Container for SQL Vulnerability Assessment
resource "azurerm_storage_container" "sql_va_container" {
  name                  = "sql${random_string.random_suffix.result}vulnerability"
  #storage_account_id    = azurerm_storage_account.sql_storage.id # Updated to use storage_account_id
  storage_account_name  = var.storage_account_name

  container_access_type = "private"

  depends_on = [azurerm_storage_account.sql_storage] # Ensure storage account is created first
}

# SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                          = var.sql_server_name
  resource_group_name           = azurerm_resource_group.rg_sql.name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_server_admin_username
  administrator_login_password  = var.sql_server_admin_password
  public_network_access_enabled = true
  minimum_tls_version           = "1.2"

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

  depends_on = [azurerm_mssql_server.sql_server] # Ensure SQL Server is created first
}

# SQL Firewall Rule - AllowAllWindowsAzureIps
resource "azurerm_mssql_firewall_rule" "sql_firewall" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

  depends_on = [azurerm_mssql_server.sql_server] # Ensure SQL Server is created first
}

# SQL Firewall Rule - DenyAzureServices
resource "azurerm_mssql_firewall_rule" "deny_azure_services" {
  name             = "DenyAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "10.0.0.0"
  end_ip_address   = "10.0.0.255"

  depends_on = [azurerm_mssql_server.sql_server] # Ensure SQL Server is created first
}

# SQL Firewall Rule - AllowAllAzureIPs
resource "azurerm_mssql_firewall_rule" "sql_firewall_rule" {
  name             = "AllowAllAzureIPs"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

  depends_on = [azurerm_mssql_server.sql_server] # Ensure SQL Server is created first
}

# SQL Server Vulnerability Assessment
resource "azurerm_mssql_server_vulnerability_assessment" "sql_va" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.sql_security_alert_policy.id
  storage_container_path          = "${azurerm_storage_account.sql_storage.primary_blob_endpoint}${azurerm_storage_container.sql_va_container.name}"
  storage_container_sas_key       = azurerm_storage_account.sql_storage.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = ["admin1@example.com", "admin2@example.com"]
  }

  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key

  depends_on = [
    azurerm_storage_account.sql_storage,
    azurerm_storage_container.sql_va_container,
    azurerm_mssql_server.sql_server
  ] # Ensure dependencies are created first
}

# SQL Server Extended Auditing Policy
resource "azurerm_mssql_server_extended_auditing_policy" "sql_auditing" {
  server_id                  = azurerm_mssql_server.sql_server.id
  storage_endpoint           = azurerm_storage_account.sql_storage.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.sql_storage.primary_access_key
  retention_in_days          = 90

  depends_on = [azurerm_storage_account.sql_storage, azurerm_mssql_server.sql_server] # Ensure dependencies are created first
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

  depends_on = [
    azurerm_storage_account.sql_storage,
    azurerm_mssql_server.sql_server,
    azurerm_resource_group.rg_sql
  ] # Ensure dependencies are created first
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "sql-private-endpoint"
  resource_group_name = azurerm_resource_group.rg_sql.name
  location            = var.location
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "sql-connection"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"] # Correct way to specify the subresource
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_subnet.subnet,
    azurerm_virtual_network.vnet,
    azurerm_mssql_server.sql_server
  ] # Ensure dependencies are created first
}

