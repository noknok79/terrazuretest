terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  alias           = "vneteastus"
  features        {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "vnet_rg" {
  name     = var.resource_group_name
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
  name                 = "subnet-keyvault"
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

# Resource Group Name
variable "resource_group_name" {
  description = "The name of the resource group where the virtual network will be created."
  type        = string
}

# Location
variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}

# Virtual Network Name
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

# Address Space
variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

# Subnets
variable "subnets" {
  description = "A map of subnets with their names and address prefixes"
  type = map(object({
    name           = string
    address_prefix = string
  }))
}

# Environment
variable "environment" {
  description = "The environment tag for the resources (e.g., dev, prod)."
  type        = string
}

# Project
variable "project" {
  description = "The project tag for the resources."
  type        = string
}

# Tags
variable "tags" {
  description = "A map of tags to apply to the resources."
  type        = map(string)
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for the provider."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID to use for the provider."
  type        = string
}


# filepath: /mnt/c/markacnwsl/terrazuretest/networking/vnet/vneteastus/main.tf

output "address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnets" {
  value = { for subnet in azurerm_subnet.vnet_subnets : subnet.name => {
    id = subnet.id
  } }
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "vnet_name" {
  value = var.vnet_name
}

// filepath: ./networking/vnet/vneteastus/outputs.tf
output "vnet_subnets" {
  value = [
    for subnet in azurerm_subnet.vnet_subnets : {
      name           = subnet.name
      id             = subnet.id
      address_prefix = join(", ", subnet.address_prefixes) # Combine address prefixes into a single string
    }
  ]
}