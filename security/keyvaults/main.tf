# Provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "keyvault_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }
}

# Add a random string resource for uniqueness
resource "random_string" "keyvault_suffix" {
  length  = 6
  upper   = false
  special = false
}

# Virtual Network
resource "azurerm_virtual_network" "keyvault_vnet" {
  name                = "keyvault-vnet"
  location            = azurerm_resource_group.keyvault_rg.location
  resource_group_name = azurerm_resource_group.keyvault_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }
}

# Subnet
resource "azurerm_subnet" "keyvault_subnet" {
  name                 = "keyvault-subnet"
  resource_group_name  = azurerm_resource_group.keyvault_rg.name
  virtual_network_name = azurerm_virtual_network.keyvault_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.KeyVault"]
}

# Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-${var.project}-${var.environment}-${random_string.keyvault_suffix.result}"
  location                    = azurerm_resource_group.keyvault_rg.location
  resource_group_name         = azurerm_resource_group.keyvault_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  public_network_access_enabled = false

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.keyvault_subnet.id]
  }
}

# Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "keyvault_policy" {
  for_each = var.access_policies

  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  secret_permissions = each.value.secret_permissions
  key_permissions    = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
}

# Data Source for Tenant ID and Subscription ID
data "azurerm_client_config" "current" {}