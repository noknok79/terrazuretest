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

# Resource: Resource Group
resource "azurerm_resource_group" "iam_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Resource: Role Assignment
resource "azurerm_role_assignment" "iam_role_assignment" {
  name               = var.role_assignment_name
  principal_id       = var.principal_id
  role_definition_name = var.role_definition_name
  scope              = var.scope

  # Ensure dependencies are explicitly defined
  depends_on = [
    azurerm_resource_group.iam_rg # Ensure the resource group is created first
  ]
}

# Example: Add additional IAM-related resources as needed
# For example, Azure AD Groups, Users, or Service Principals can be added here.