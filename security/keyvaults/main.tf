terraform {
  required_version = ">= 1.5.6" # Upgraded to the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0" # Upgraded to the latest stable AzureRM provider version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group for the Key Vault
resource "azurerm_resource_group" "rg" {
  name     = "rg-keyvault-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.environment}-${var.location}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  # soft_delete_enabled is always enabled by default and no longer configurable
  purge_protection_enabled    = true
  public_network_access_enabled = false
  network_acls {
    default_action = "Deny" # Deny by default for enhanced security
    bypass         = "AzureServices"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]

  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# Data source for tenant ID
data "azurerm_client_config" "current" {}
