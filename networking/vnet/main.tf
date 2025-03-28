terraform {
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.64.0"
    }
  }
}

provider "azurerm" {
  features        {}
  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags

  # Ensure the virtual network depends on the resource group
  depends_on = [azurerm_resource_group.vnet]
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each            = var.subnets
  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes    = [each.value.address_prefix]

  # Ensure subnets depend on the virtual network
  depends_on = [azurerm_virtual_network.vnet]
}
