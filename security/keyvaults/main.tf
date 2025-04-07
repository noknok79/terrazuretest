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
}

provider "azurerm" {
  alias           = "keyvault"
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
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
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.keyvault_rg.name
  address_space       = var.virtual_network_address_space

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }

  depends_on = [azurerm_resource_group.keyvault_rg]
}

# Subnet
resource "azurerm_subnet" "keyvault_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.keyvault_rg.name # Ensure this matches the Key Vault's resource group
  virtual_network_name = azurerm_virtual_network.keyvault_vnet.name
  address_prefixes     = var.subnet_address_prefixes

  service_endpoints = var.subnet_service_endpoints

  depends_on = [azurerm_virtual_network.keyvault_vnet]
}

# Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-${var.project}-${var.environment}-${random_string.keyvault_suffix.result}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.keyvault_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.key_vault_sku_name
  purge_protection_enabled    = var.key_vault_purge_protection_enabled
  public_network_access_enabled = var.key_vault_public_network_access_enabled

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }

  network_acls {
    default_action             = var.key_vault_default_action
    bypass                     = var.key_vault_bypass
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.keyvault_subnet.id] # Reference the correct subnet ID
  }

  depends_on = [azurerm_virtual_network.keyvault_vnet, azurerm_subnet.keyvault_subnet]
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

  depends_on = [azurerm_key_vault.keyvault]
}

# Data Source for Tenant ID and Subscription ID
data "azurerm_client_config" "current" {}