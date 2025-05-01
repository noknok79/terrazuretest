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
  subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  skip_provider_registration = true
}

resource "azurerm_network_security_group" "nsg_standard" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_source # Restrict SSH access
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  #skip-check: Ensure resource group creation is independent of other resources
  depends_on = [] # No dependencies explicitly defined
}

