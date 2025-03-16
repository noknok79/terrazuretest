terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0" # Upgraded to the latest stable version
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
}

# PostgreSQL server
resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                = "psql-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "Standard_B1ms"
  storage_mb          = 32768
  version             = "14" # Use the latest stable PostgreSQL version
  administrator_login = var.admin_username
  administrator_password = var.admin_password

  depends_on = [azurerm_resource_group.rg]

  lifecycle {
    prevent_destroy = true # Prevent accidental deletion
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# PostgreSQL database
resource "azurerm_postgresql_flexible_database" "psql_db" {
  name                = "db-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  server_id           = azurerm_postgresql_flexible_server.psql_server.id
  charset             = "UTF8"
  collation           = "en_US.UTF8"

  depends_on = [azurerm_postgresql_flexible_server.psql_server]

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# PostgreSQL firewall rule
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_access" {
  name                = "fw-allow-all-${var.project_name}-${var.environment}"
  server_id           = azurerm_postgresql_flexible_server.psql_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"

  depends_on = [azurerm_postgresql_flexible_server.psql_server]
}
