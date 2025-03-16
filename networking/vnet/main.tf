terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use a stable version (update as needed)
    }
  }

  required_version = ">= 1.3.0" # Ensure compatibility with Terraform CLI
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "network_rg" {
  name     = "terraform-network-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "main-vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Define a Network Security Group for the springboot-subnet
resource "azurerm_network_security_group" "springboot_nsg" {
  name                = "springboot-nsg"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "springboot-subnet" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = [each.value.address_prefix]

  # Associate the subnet with the NSG
  network_security_group_id = azurerm_network_security_group.springboot_nsg.id
}

# Associate the NSG with the springboot-subnet
resource "azurerm_subnet_network_security_group_association" "springboot_nsg_association" {
  for_each            = var.subnets
  subnet_id           = azurerm_subnet.springboot-subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.springboot_nsg.id
}

# Additional subnet for Docker
resource "azurerm_subnet" "docker-subnet" {
  name                 = "docker-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.3.0/24"] # Example address prefix

  # Associate the subnet with the NSG
  network_security_group_id = azurerm_network_security_group.main-nsg.id
}

# Additional subnet for eShop
resource "azurerm_subnet" "eshop-subnet" {
  name                 = "eshop-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.4.0/24"] # Example address prefix

  # Associate the subnet with the NSG
  network_security_group_id = azurerm_network_security_group.springboot_nsg.id
}

# Additional subnet for PartsWeb
resource "azurerm_subnet" "partsweb-subnet" {
  name                 = "partsweb-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.5.0/24"] # Example address prefix

  # Associate the subnet with the NSG
  network_security_group_id = azurerm_network_security_group.springboot_nsg.id
}

# Additional subnet for SmartHotel
resource "azurerm_subnet" "smarthotel-subnet" {
  name                 = "smarthotel-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.6.0/24"] # Example address prefix

  # Associate the subnet with the NSG
  network_security_group_id = azurerm_network_security_group.springboot_nsg.id
}
