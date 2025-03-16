terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "stroge-rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_storage_account" "main-storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.stroge-rg.name
  location                 = azurerm_resource_group.stroge-rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version          = "TLS1_2"

  # Enable soft-delete for blobs
  blob_properties {
    delete_retention_policy {
      days = 7 # Retain deleted blobs for 7 days
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

resource "azurerm_storage_container" "script-container" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.main-storage.id
  container_access_type = var.container_access_type

  metadata = var.tags
}

output "storage_account_primary_endpoint" {
  value = azurerm_storage_account.main-storage.primary_blob_endpoint
}

output "storage_container_url" {
  value = "${azurerm_storage_account.main-storage.primary_blob_endpoint}${azurerm_storage_container.script-container.name}"
}
