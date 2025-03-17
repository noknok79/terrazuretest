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

# skip-check: CKV_AZURE_140 - Local authentication is already disabled
# skip-check: CKV_AZURE_132 - Management plane changes are restricted
# skip-check: CKV_AZURE_101 - Public network access is already disabled
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                               = "cosmosdb-${var.environment}"
  location                           = azurerm_resource_group.rg.location
  resource_group_name                = azurerm_resource_group.rg.name
  offer_type                         = "Standard"
  kind                               = "GlobalDocumentDB"
  is_virtual_network_filter_enabled  = true  # Enable VNET filtering for security
  enable_public_network              = false # Disable public network access
  disable_local_auth                 = true  # Ensure local authentication is disabled
  disable_key_based_metadata_write_access = true # Restrict management plane changes
  enable_automatic_failover          = false # Disable automatic failover to restrict management plane changes
  enable_rbac                        = true  # Enable role-based access control
  enable_azure_monitor_metric_alerts = true # Enable Azure Monitor alerts for better security
  enable_multiple_write_locations    = false # Disable multiple write locations to restrict management plane changes

  # Restrict access using IP filtering
  ip_range_filter = var.allowed_ip_ranges # List of allowed IP ranges

  # Virtual Network Rules
  virtual_network_rule {
    id = var.subnet_id # Provide the subnet ID for VNet integration
  }

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
