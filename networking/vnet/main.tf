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
  alias = "vnet"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "vnet_rg" {
  name = var.resource_group_name
  #name     = "rg-vnet-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags

  depends_on = [azurerm_resource_group.vnet_rg] # Ensure the resource group is created first
}

# Subnets
resource "azurerm_subnet" "vnet_subnets" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-keyvault-${var.environment}"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.6.0/24"]

  # Ensure the service endpoint for Microsoft.KeyVault is configured
  service_endpoints = ["Microsoft.KeyVault"]

  delegation {
    name = "sql-delegation"
    service_delegation {
      name = "Microsoft.Sql/managedInstances"
    }
  }

  depends_on = [azurerm_virtual_network.vnet]
}

