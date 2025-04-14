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
  #alias           = "vnet_centralus"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group for Central US VNet
resource "azurerm_resource_group" "vnet_rg_centralus" {
  name     = var.resource_group_name_centralus
  location = "centralus"
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Virtual Network for Central US
resource "azurerm_virtual_network" "vnet_centralus" {
  name                = var.vnet_name_centralus
  resource_group_name = azurerm_resource_group.vnet_rg_centralus.name
  location            = "centralus"
  address_space       = var.address_space_centralus
  tags                = var.tags

  depends_on = [azurerm_resource_group.vnet_rg_centralus]
}

# Subnets for Central US VNet
resource "azurerm_subnet" "vnet_subnets_centralus" {
  for_each             = var.subnets_centralus
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.vnet_rg_centralus.name
  virtual_network_name = azurerm_virtual_network.vnet_centralus.name
  address_prefixes     = [each.value.address_prefix]
}

# Key Vault Subnet for Central US
resource "azurerm_subnet" "subnet_keyvault_centralus" {
  name                 = "subnet-keyvault-centralus"
  resource_group_name  = azurerm_resource_group.vnet_rg_centralus.name
  virtual_network_name = azurerm_virtual_network.vnet_centralus.name
  address_prefixes     = ["10.1.6.0/24"]

  service_endpoints = ["Microsoft.KeyVault"]

  delegation {
    name = "sql-delegation"
    service_delegation {
      name = "Microsoft.Sql/managedInstances"
    }
  }

  depends_on = [azurerm_virtual_network.vnet_centralus]
}

# Resource Group Name
variable "resource_group_name_centralus" {
  description = "Name of the resource group for the Central US VNet"
  type        = string
}



# Subnets for the Virtual Network
variable "subnets_centralus" {
  description = "Subnets for the Central US Virtual Network"
  type = map(object({
    name           = string
    address_prefix = string
  }))
}

# Virtual Network Name
variable "vnet_name_centralus" {
  description = "Name of the Central US Virtual Network"
  type        = string
}

# Address Space for the Virtual Network
variable "address_space_centralus" {
  description = "Address space for the Central US Virtual Network"
  type        = list(string)
}

# Key Vault Subnet Address Prefix
variable "keyvault_subnet_address_prefix" {
  description = "Address prefix for the Key Vault subnet in Central US"
  type        = string
}






# Subscription ID
variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

# Tenant ID
variable "tenant_id" {
  description = "The tenant ID for the Azure account"
  type        = string
}

# Environment Tag
variable "environment" {
  description = "The environment tag for the resources (e.g., dev, prod)"
  type        = string
}

# Project Tag
variable "project" {
  description = "The project tag for the resources"
  type        = string
}

# Tags for Resources
variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
}