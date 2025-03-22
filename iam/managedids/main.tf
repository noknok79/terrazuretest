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

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-managed-identity"
  location = "East US"

  #skip-check: Ensure resource group is created before other resources
}

# Managed Identity
resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "uai-example"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  depends_on = [azurerm_resource_group.rg] #skip-check: Depends on resource group creation
}

# Example Role Assignment for Managed Identity
resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id

  depends_on = [azurerm_user_assigned_identity.managed_identity] #skip-check: Depends on managed identity creation
}
