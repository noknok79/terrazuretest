terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
}

provider "azurerm" {
  #alias = "pslqldb"
  features {}
  subscription_id           = var.subscription_id
  tenant_id                 = var.tenant_id
  skip_provider_registration = true
}

resource "random_string" "unique_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Subnet for PostgreSQL Server
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-psqldb"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "postgresql_delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_resource_group.rg
  ]
}

# Subnet for Private Endpoint
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "private-endpoint-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_resource_group.rg
  ]
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "psql_private_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
    depends_on = [
    azurerm_resource_group.rg
  ]
}

# Private DNS Zone Association
resource "azurerm_private_dns_zone_virtual_network_link" "psql_dns_zone_vnet_link" {
  name                  = "psql-dns-zone-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.psql_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  depends_on = [
    azurerm_private_dns_zone.psql_private_dns_zone,
    azurerm_virtual_network.vnet,
    azurerm_resource_group.rg
  ]
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                   = "${var.psql_server_name}${random_string.unique_suffix.result}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  sku_name               = var.sku_name
  version                = "14"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  backup_retention_days  = 7
  geo_redundant_backup_enabled = true
  #delegated_subnet_id    = var.subnet_id
  delegated_subnet_id    = azurerm_subnet.subnet.id # Reference the newly created subnet


  high_availability {
    mode = "ZoneRedundant"
  }

  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }

  storage_mb = 32768 # 32 GB in megabytes

  #delegated_subnet_id = azurerm_subnet.subnet.id
  private_dns_zone_id = azurerm_private_dns_zone.psql_private_dns_zone.id

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_subnet.subnet,
    azurerm_private_dns_zone_virtual_network_link.psql_dns_zone_vnet_link
  ]
}

# Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account_name}${random_string.unique_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Storage Container
resource "azurerm_storage_container" "psql_va_container" {
  name                  = "${var.storage_container_name}${random_string.unique_suffix.result}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"

   depends_on = [
    azurerm_storage_account.storage_account
  ]
}