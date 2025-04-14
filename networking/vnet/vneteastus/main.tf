# Subscription ID
provider "azurerm" {
  features        {}
  #alias           = "vnet"
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
  description = <<EOT
A map of subnets to create within the virtual network. Each subnet should have the following structure:
{
  name           = "subnet-name"
  address_prefix = "subnet-address-prefix"
}
EOT
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