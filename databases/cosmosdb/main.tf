terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0" # Updated to the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-cosmosdb-${var.environment}"
  location = var.location
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                               = "cosmosdb-${var.environment}"
  location                           = azurerm_resource_group.rg.location
  resource_group_name                = azurerm_resource_group.rg.name
  offer_type                         = "Standard"
  kind                               = "GlobalDocumentDB"
  # enable_automatic_failover is not supported in this resource
  # enable_multiple_write_locations is not supported in this resource
  # enable_public_network is not supported in this resource
  is_virtual_network_filter_enabled  = true  # Enable VNET filtering for security

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
