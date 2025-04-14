# Terraform Block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use the latest stable version
    }
  }

  required_version = ">= 1.3.0" # Ensure compatibility with the latest Terraform features
}

# Provider Configuration
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Virtual Network Peering from East US to Central US
resource "azurerm_virtual_network_peering" "eastus_to_centralus" {
  name                      = "eastus-to-centralus"
  resource_group_name       = data.azurerm_resource_group.vnet_eastus.name
  virtual_network_name      = data.azurerm_virtual_network.vnet_eastus.name
  remote_virtual_network_id = data.azurerm_virtual_network.vnet_centralus.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Virtual Network Peering from Central US to East US
resource "azurerm_virtual_network_peering" "centralus_to_eastus" {
  name                      = "centralus-to-eastus"
  resource_group_name       = data.azurerm_resource_group.vnet_centralus.name
  virtual_network_name      = data.azurerm_virtual_network.vnet_centralus.name
  remote_virtual_network_id = data.azurerm_virtual_network.vnet_eastus.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Data Block for East US Virtual Network
data "azurerm_virtual_network" "vnet_eastus" {
  name                = var.eastus_vnet_name
  resource_group_name = var.eastus_resource_group_name
}

# Data Block for Central US Virtual Network
data "azurerm_virtual_network" "vnet_centralus" {
  name                = var.centralus_vnet_name
  resource_group_name = var.centralus_resource_group_name
}

# Data Block for East US Resource Group
data "azurerm_resource_group" "vnet_eastus" {
  name = var.eastus_resource_group_name
}

# Data Block for Central US Resource Group
data "azurerm_resource_group" "vnet_centralus" {
  name = var.centralus_resource_group_name
}

# Variables
variable "subscription_id" {
  description = "The Azure subscription ID to use for the provider."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID to use for the provider."
  type        = string
}

variable "eastus_vnet_name" {
  description = "The name of the East US Virtual Network."
  type        = string
}

variable "eastus_resource_group_name" {
  description = "The name of the East US Resource Group."
  type        = string
}

variable "centralus_vnet_name" {
  description = "The name of the Central US Virtual Network."
  type        = string
}

variable "centralus_resource_group_name" {
  description = "The name of the Central US Resource Group."
  type        = string
}
