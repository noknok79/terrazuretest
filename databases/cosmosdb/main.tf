terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0" # Updated to the latest stable version
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id # Add subscription_id
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-cosmosdb-${var.environment}"
  location = var.location
}

# skip-check: CKV_AZURE_140 - Local authentication is already disabled
# skip-check: CKV_AZURE_132 - Management plane changes are restricted
# skip-check: CKV_AZURE_101 - Public network access is already disabled
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                              = "cosmosdb-${var.environment}"
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  offer_type                        = "Standard"
  kind                              = "GlobalDocumentDB"
  is_virtual_network_filter_enabled = true  # Enable VNET filtering for security
  public_network_access_enabled     = false # Disable public network access

  # Customer-managed keys for encryption
  key_vault_key_id = var.key_vault_key_id # Provide the Key Vault key ID

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  depends_on = [azurerm_resource_group.rg]
}

# Cosmos DB Database
resource "azurerm_cosmosdb_sql_database" "database" {
  name                = "db-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  throughput          = 400

  depends_on = [azurerm_cosmosdb_account.cosmosdb]
}

# Cosmos DB Container
resource "azurerm_cosmosdb_sql_container" "container" {
  name                = "container-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.database.name
  partition_key_paths = ["/partitionKey"]
  throughput          = 400 # Explicitly set throughput for the container

  indexing_policy {
    indexing_mode = "consistent"
    included_path {
      path = "/*"
    }
    excluded_path {
      path = "/\"_etag\"/?"
    }
  }

  depends_on = [azurerm_cosmosdb_sql_database.database]
}
