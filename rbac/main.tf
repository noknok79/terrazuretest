# Terraform block with the most stable version
terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0" # Use the latest stable version of the Azure provider
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg_rbac" {
  name     = "rg-rbac-example"
  location = "East US"
}

# Role Assignment
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.rg_rbac.id
  role_definition_name = "Contributor"    # Replace with the desired role
  principal_id         = var.principal_id # Pass the principal ID as a variable

  #skip-check: Ensure the resource group is created before assigning roles
  depends_on = [
    azurerm_resource_group.rg_rbac
  ]
}

