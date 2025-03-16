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

# SQL Server
resource "azurerm_sql_server" "sql_server" {
  name                         = "sqlserver-${var.environment}-${var.location}"
  location                     = azurerm_resource_group.rg_sql.location
  resource_group_name          = azurerm_resource_group.rg_sql.name
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "12.0" # Default version for Azure SQL

  tags = var.tags
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
  start_ip_address    = var.start_ip_address
  end_ip_address      = var.end_ip_address

  depends_on = [azurerm_sql_server.sql_server]
}
