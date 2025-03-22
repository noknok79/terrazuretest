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

# Resource: Role Assignment
resource "azurerm_role_assignment" "role_assignment" {
  name                 = var.role_assignment_name
  principal_id         = var.principal_id
  role_definition_name = var.role_definition_name
  scope                = var.scope

  # Ensure dependencies are explicitly defined
  depends_on = [
    azurerm_resource_group.example, #skip-check: Depends on resource group creation
    azurerm_subscription.example    #skip-check: Depends on subscription configuration
  ]
}

# Example resource group (replace with actual resources as needed)
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"

  #skip-check: Resource group creation
}

# Example subscription (replace with actual resources as needed)
resource "azurerm_subscription" "example" {
  subscription_id = "00000000-0000-0000-0000-000000000000" # Replace with actual subscription ID

  #skip-check: Subscription configuration
}
