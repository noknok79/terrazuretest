terraform {
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0" # Ensure consistent version
    }
  }
}

provider "azurerm" {
  features {}
  alias           = "vnet"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags

  depends_on = [
    azurerm_resource_group.example # Ensure the resource group exists before creating the virtual network
  ]
}

resource "azurerm_subnet" "example" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [each.value.address_prefix]

  depends_on = [
    azurerm_virtual_network.example, # Ensure the virtual network exists before creating the subnets
    azurerm_resource_group.example   # Ensure the resource group exists before creating the subnets
  ]
}

resource "azurerm_subnet" "subnet_vm" {
  count                = length(var.subnet_configs)
  name                 = var.subnet_configs[count.index].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnet_configs[count.index].address_prefix]
}

resource "azurerm_resource_group" "example" {
  name     = "RG-vnet-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}
