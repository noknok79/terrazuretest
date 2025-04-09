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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "azurerm" {
  alias           = "cosmosdb"
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "keyvault_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Add a random string resource for uniqueness
resource "random_string" "unique_suffix" {
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

  depends_on = [azurerm_resource_group.keyvault_rg] # Ensure the resource group is created first
}

# Subnet
resource "azurerm_subnet" "keyvault_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.keyvault_rg.name
  virtual_network_name = azurerm_virtual_network.keyvault_vnet.name
  address_prefixes     = var.subnet_address_prefixes

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.AzureCosmosDB" # Add Cosmos DB service endpoint
  ]

  depends_on = [azurerm_virtual_network.keyvault_vnet] # Ensure the virtual network is created first
}



# Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-${var.project}-${var.environment}-${random_string.unique_suffix.result}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.keyvault_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.key_vault_sku_name
  purge_protection_enabled    = var.key_vault_purge_protection_enabled
  public_network_access_enabled = var.key_vault_public_network_access_enabled


  network_acls {
    default_action             = var.key_vault_default_action
    bypass                     = var.key_vault_bypass
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.keyvault_subnet.id]
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

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "cosmosdb-${var.project}-${var.environment}-${random_string.unique_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.keyvault_rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = var.cosmosdb_consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  is_virtual_network_filter_enabled = var.cosmosdb_is_virtual_network_filter_enabled

  dynamic "virtual_network_rule" {
    for_each = [azurerm_subnet.keyvault_subnet.id]
    content {
      id = virtual_network_rule.value
    }
  }

  depends_on = [
    azurerm_key_vault.keyvault 
  ]
}

# Cosmos DB SQL Database
resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_db" {
  name                = var.cosmosdb_sql_database_name
  resource_group_name = azurerm_resource_group.keyvault_rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
}

# Cosmos DB SQL Container
resource "azurerm_cosmosdb_sql_container" "cosmosdb_sql_container" {
  name                = var.cosmosdb_sql_container_name
  resource_group_name = azurerm_resource_group.keyvault_rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.cosmosdb_sql_db.name
  partition_key_paths = [var.cosmosdb_partition_key_path]

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
}

# Data source to retrieve Cosmos DB account keys
data "azurerm_cosmosdb_account" "cosmosdb" {
  name                = azurerm_cosmosdb_account.cosmosdb.name
  resource_group_name = azurerm_resource_group.keyvault_rg.name
}

# Data Source for Tenant ID and Subscription ID
data "azurerm_client_config" "current" {}



# Output for Subnet ID
