terraform {
  required_version = ">= 1.5.6" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0" # Use the latest stable AzureRM provider version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group for Policies and Initiatives
resource "azurerm_resource_group" "rg" {
  name     = "rg-policies-${var.environment}-${var.location}"
  location = var.location
}

# Azure Policy Definition
resource "azurerm_policy_definition" "policy" {
  name         = "policy-${var.environment}-${var.location}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Custom Policy for ${var.environment}"
  description  = "This policy ensures compliance with organizational standards."
  metadata = jsonencode({
    category = "Security"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      field = "type"
      equals = "Microsoft.Network/virtualNetworks"
    }
    then = {
      effect = "audit"
    }
  })

}

# Azure Policy Initiative (Definition Group)
resource "azurerm_policy_set_definition" "initiative" {
  name         = "initiative-${var.environment}-${var.location}"
  display_name = "Custom Initiative for ${var.environment}"
  description  = "This initiative groups multiple policies for ${var.environment}."
  policy_type  = "Custom"
  metadata = jsonencode({
    category = "Security"
    version  = "1.0.0"
  })

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.policy.id
  }
}

# Azure Policy Assignment
resource "azurerm_policy_assignment" "assignment" {
  name                 = "assignment-${var.environment}-${var.location}"
  display_name         = "Policy Assignment for ${var.environment}"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_set_definition.initiative.id
  description          = "Assigning the initiative to the resource group."

  depends_on = [
    azurerm_policy_set_definition.initiative,
    azurerm_policy_definition.policy
  ]

  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}
