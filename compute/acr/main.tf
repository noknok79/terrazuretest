# Specify the required Terraform version
terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

# Define the provider
provider "azurerm" {
  features {}
  subscription_id            = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id                  = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  skip_provider_registration = true
}

resource "random_string" "unique_suffix" {
  length  = 10
  upper   = false
  special = false
}

# Resource group for the ACR
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}${random_string.unique_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false # Disable admin user for better security

  tags = var.tags

  dynamic "georeplications" {
    for_each = var.geo_replication_locations
    content {
      location = georeplications.value
    }
  }

  depends_on = [
    azurerm_resource_group.acr_rg
  ]
}


# Virtual Network for Private Endpoint
resource "azurerm_virtual_network" "acr_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = merge(var.tags, { Purpose = "ACRPrivateEndpoint" })

  depends_on = [
    azurerm_resource_group.acr_rg
  ]
}

# Subnet for Private Endpoint
resource "azurerm_subnet" "acr_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefixes

  depends_on = [
    azurerm_virtual_network.acr_vnet
  ]
}

resource "azurerm_container_registry_agent_pool" "acr_agent_pool" {
  name                    = "acragentpool"
  resource_group_name     = var.resource_group_name
  location                = var.location
  container_registry_name = azurerm_container_registry.acr.name
}
