terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_firewall" "azfw" {
  name                = "azfw-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard" # Use "Premium" if advanced features are required
  zones               = var.zones

  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.azfw_pip.id
  }

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_subnet.firewall_subnet,
    azurerm_public_ip.azfw_pip
  ]

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-${var.location}"
  location = var.location

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_public_ip" "azfw_pip" {
  name                = "pip-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}
