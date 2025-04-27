# Terraform Block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0" # Use the latest stable version
    }
  }

  required_version = ">= 1.3.0" # Ensure compatibility with the latest Terraform features
}

provider "azurerm" {
  features {} # Ensure this block is present
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
}

provider "azurerm" {
  alias = "euscuspeering"
  features {} # Ensure this block is present
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
}



# Virtual Network Peering from East US to Central US
resource "azurerm_virtual_network_peering" "eastus_to_centralus" {
  name                      = "eastus-to-centralus"
  resource_group_name       = var.eastus_resource_group_name
  virtual_network_name      = var.eastus_vnet_name
  remote_virtual_network_id = var.vnet_centralus_vnetid

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Virtual Network Peering from Central US to East US
resource "azurerm_virtual_network_peering" "centralus_to_eastus" {
  name                      = "centralus-to-eastus"
  resource_group_name       = var.centralus_resource_group_name
  virtual_network_name      = var.centralus_vnet_name
  remote_virtual_network_id = var.vnet_eastus_vnetid

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# # Data Block for East US Virtual Network
# data "azurerm_virtual_network" "vnet_eastus" {
#   name                = var.eastus_vnet_name
#   resource_group_name = var.eastus_resource_group_name
# }

# # Data Block for Central US Virtual Network
# data "azurerm_virtual_network" "vnet_centralus" {
#   name                = var.centralus_vnet_name
#   resource_group_name = var.centralus_resource_group_name
# }

# # Data Block for East US Resource Group
# data "azurerm_resource_group" "vnet_eastus" {
#   name = var.eastus_resource_group_name
# }

# # Data Block for Central US Resource Group
# data "azurerm_resource_group" "vnet_centralus" {
#   name = var.centralus_resource_group_name
# }

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

variable "vnet_eastus_vnetid" {
  description = "The ID of the East US Virtual Network."
  type        = string

}

variable "vnet_centralus_vnetid" {
  description = "The ID of the Central US Virtual Network."
  type        = string


}