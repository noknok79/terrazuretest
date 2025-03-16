terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.40.0" # Use the latest stable version of the AzureAD provider
    }
  }
}

provider "azuread" {
  # Authentication configuration (use environment variables or managed identity for best practices)
}

# Define a resource group for AAD roles
resource "azuread_group" "aad_role_group" {
  display_name     = "AAD-Role-Group-Example"
  security_enabled = true
  mail_enabled     = false
  description      = "Group for managing Azure Active Directory roles"

  # Use depends_on to ensure dependencies are created first
  depends_on = []
}

# Assign a role to the group
resource "azuread_directory_role_assignment" "aad_role_assignment" {
  principal_object_id = azuread_group.aad_role_group.object_id
  role_id             = data.azuread_directory_role.aad_role_template.id

  # Use depends_on to ensure dependencies are created first
  depends_on = [azuread_group.aad_role_group]
}

# Data source for the AAD role template
data "azuread_directory_role" "aad_role_template" {
  display_name = "Global Reader" # Replace with the desired role name
}
