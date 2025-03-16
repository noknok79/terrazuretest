terraform {
  required_version = ">= 1.5.6" # Upgraded to the latest stable version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0" # Upgraded to the latest stable AzureRM provider version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }
}

# MySQL Server
resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                = "mysql-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "Standard_B1ms"
  storage_mb          = 51200
  version             = "8.0"
  administrator_login = var.admin_username
  administrator_password = var.admin_password

  backup {
    retention_days = 7 # Prisma Cloud recommends enabling backups with a minimum retention period
  }

  high_availability {
    mode = "ZoneRedundant" # Ensures high availability
  }

  depends_on = [azurerm_resource_group.rg]

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "mysql_db" {
  name                = "db-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_general_ci"

  depends_on = [azurerm_mysql_flexible_server.mysql_server]

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }
}
