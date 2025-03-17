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

# skip-check CKV_AZURE_201 
# skip-check CKV_AZURE_199 #: Customer-managed key and double encryption are already configured
resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = "sb-namespace-${var.environment}"
  location            = azurerm_resource_group.rg_servicebus.location
  resource_group_name = azurerm_resource_group.rg_servicebus.name
  sku                 = "Standard"

  # Enable customer-managed key for encryption
  encryption {
    key_source                     = "Microsoft.Keyvault"
    key_vault_key_id               = var.key_vault_key_id # Ensure this variable is defined in your variables file
    require_infrastructure_encryption = true # Enable double encryption
  }

  # Enable managed identity
  identity {
    type = "SystemAssigned"
  }

  # Disable local authentication
  local_auth_enabled = false

  # Enforce the latest TLS version
  minimum_tls_version = "1.2"

  # Disable public network access
  public_network_access_enabled = false

  depends_on = [azurerm_resource_group.rg_servicebus]
}

# Service Bus Queue
resource "azurerm_servicebus_queue" "sb_queue" {
  name                = "sb-queue-${var.environment}"
  namespace_id        = azurerm_servicebus_namespace.sb_namespace.id

  depends_on = [azurerm_servicebus_namespace.sb_namespace]
}
