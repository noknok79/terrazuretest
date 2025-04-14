terraform {
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.64.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  #skip_provider_registration = true
}




# Subscription ID
variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

# Tenant ID
variable "tenant_id" {
  description = "The tenant ID for the Azure account"
  type        = string
}

# Environment Tag
variable "environment" {
  description = "The environment tag for the resources (e.g., dev, prod)"
  type        = string
}

# Project Tag
variable "project" {
  description = "The project tag for the resources"
  type        = string
}

# Tags for Resources
variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
}