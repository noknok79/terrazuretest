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
}

resource "azurerm_public_ip" "example" {
  name                = "pip-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"   # Best practice for predictable IPs
  sku                 = "Standard" # Recommended for production workloads
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.example #skip-check: Ensure resource group is created first
  ]
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  # No additional depends_on needed here as it's a base resource
}
