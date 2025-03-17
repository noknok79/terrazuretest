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

# skip-check: CKV_AZURE_94 # "Ensure that My SQL server enables geo-redundant backups"
resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                = "mysql-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "Standard_D2ds_v4" # Updated SKU to support geo-redundant backups
  storage_mb          = 51200
  version             = "8.0"
  administrator_login = var.admin_username
  administrator_password = var.admin_password

  backup {
    retention_days              = 7 # Prisma Cloud recommends enabling backups with a minimum retention period
    geo_redundant_backup_enabled = true # Ensures geo-redundant backups
  }

  high_availability {
    mode = "ZoneRedundant" # Ensures high availability
  }

  network {
    delegated_subnet_id = azurerm_subnet.private_endpoint_subnet.id
    private_dns_zone_id = azurerm_private_dns_zone.mysql_private_dns.id
  }

  depends_on = [azurerm_resource_group.rg, azurerm_private_endpoint.mysql_private_endpoint]

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

# Private DNS Zone for MySQL
resource "azurerm_private_dns_zone" "mysql_private_dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Network Security Group for the Subnet
resource "azurerm_network_security_group" "private_endpoint_nsg" {
  name                = "nsg-private-endpoint-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowMySQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.0.0/16" # Restrict to the VNet CIDR range
    destination_address_prefix = "*"
  }
}

# Subnet for Private Endpoint
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "private-endpoint-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  enforce_private_link_endpoint_network_policies = true
  network_security_group_id = azurerm_network_security_group.private_endpoint_nsg.id
}

# Private Endpoint for MySQL
resource "azurerm_private_endpoint" "mysql_private_endpoint" {
  name                = "mysql-private-endpoint-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint_subnet.id

  private_service_connection {
    name                           = "mysql-private-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql_server.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }

  depends_on = [
    azurerm_mysql_flexible_server.mysql_server,
    azurerm_subnet.private_endpoint_subnet
  ]
}

# Private DNS Zone Association
resource "azurerm_private_dns_zone_virtual_network_link" "mysql_dns_vnet_link" {
  name                  = "mysql-dns-vnet-link-${var.project_name}-${var.environment}"
  private_dns_zone_name = azurerm_private_dns_zone.mysql_private_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  depends_on = [
    azurerm_private_dns_zone.mysql_private_dns,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_private_dns_a_record" "mysql_private_dns_record" {
  name                = azurerm_mysql_flexible_server.mysql_server.name
  zone_name           = azurerm_private_dns_zone.mysql_private_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_mysql_flexible_server.mysql_server.fqdn]

  depends_on = [
    azurerm_mysql_flexible_server.mysql_server,
    azurerm_private_dns_zone.mysql_private_dns
  ]
}
