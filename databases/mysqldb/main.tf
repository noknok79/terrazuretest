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
  features {}
  skip_provider_registration = true
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

# Subnet for MySQL Server
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-mysqldb"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "mysql_delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Subnet for Private Endpoint
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "private-endpoint-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Network Security Group for the Subnet
resource "azurerm_network_security_group" "private_endpoint_nsg" {
  name                = "nsg-private-endpoint-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowMySQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Subnet to NSG Association
resource "azurerm_subnet_network_security_group_association" "private_endpoint_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.private_endpoint_subnet.id
  network_security_group_id = azurerm_network_security_group.private_endpoint_nsg.id

  depends_on = [
    azurerm_subnet.private_endpoint_subnet,
    azurerm_network_security_group.private_endpoint_nsg
  ]
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                   = "mysql-${var.project_name}-${var.environment}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  sku_name               = var.sku_name
  version                = "8.0.21"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  backup_retention_days  = 7
  geo_redundant_backup_enabled = true

  high_availability {
    mode = "SameZone"
  }
  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }
  storage {
    iops    = 360
    size_gb = 20
  }

  delegated_subnet_id = azurerm_subnet.subnet.id

  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }

  depends_on = [
    azurerm_subnet.subnet
  ]
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "mysql_db" {
  name                = "db-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_general_ci"

  depends_on = [
    azurerm_mysql_flexible_server.mysql_server
  ]
}
