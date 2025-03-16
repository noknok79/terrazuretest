terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0" # Upgraded to the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "eventhubs_rg" {
  name     = "rg-eventhubs-${var.environment}"
  location = var.location
  tags     = merge(
    var.tags,
    {
      "Environment" = var.environment,
      "Owner"       = var.owner
    }
  )
}

# Event Hubs Namespace
resource "azurerm_eventhub_namespace" "eventhubs_ns" {
  name                = "eh-namespace-${var.environment}"
  location            = azurerm_resource_group.eventhubs_rg.location
  resource_group_name = azurerm_resource_group.eventhubs_rg.name
  sku                 = "Standard"
  capacity            = 1
  tags                = azurerm_resource_group.eventhubs_rg.tags
}

# Event Hub
resource "azurerm_eventhub" "eventhub" {
  name                = "eh-${var.environment}"
  namespace_id        = azurerm_eventhub_namespace.eventhubs_ns.id # Updated to use namespace_id
  resource_group_name = azurerm_resource_group.eventhubs_rg.name
  partition_count     = 2
  message_retention   = 1
  depends_on          = [azurerm_eventhub_namespace.eventhubs_ns]
  tags                = azurerm_resource_group.eventhubs_rg.tags
}

# Event Hub Authorization Rule
resource "azurerm_eventhub_authorization_rule" "eventhub_auth_rule" {
  name                = "eh-auth-rule-${var.environment}"
  eventhub_name       = azurerm_eventhub.eventhub.name
  namespace_name      = azurerm_eventhub_namespace.eventhubs_ns.name
  resource_group_name = azurerm_resource_group.eventhubs_rg.name
  listen              = true
  send                = true
  manage              = false
  depends_on          = [azurerm_eventhub.eventhub]
  tags                = azurerm_resource_group.eventhubs_rg.tags
}

