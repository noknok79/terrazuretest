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
resource "azurerm_resource_group" "rg_servicebus" {
  name     = "rg-servicebus-${var.environment}"
  location = var.location
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = "sb-namespace-${var.environment}"
  location            = azurerm_resource_group.rg_servicebus.location
  resource_group_name = azurerm_resource_group.rg_servicebus.name
  sku                 = "Standard"

  depends_on = [azurerm_resource_group.rg_servicebus]
}

# Service Bus Queue
resource "azurerm_servicebus_queue" "sb_queue" {
  name                = "sb-queue-${var.environment}"
  namespace_id        = azurerm_servicebus_namespace.sb_namespace.id

  depends_on = [azurerm_servicebus_namespace.sb_namespace]
}
