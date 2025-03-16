terraform {
  required_version = ">= 1.5.0" # Use the latest stable version of Terraform
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

# Resource group
resource "azurerm_resource_group" "rg_blob_storage" {
  name     = "rg-blobstorage-${var.environment}"
  location = var.location
  tags     = var.tags
}

# Storage account
resource "azurerm_storage_account" "sa_blob_storage" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_blob_storage.name
  location                 = azurerm_resource_group.rg_blob_storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags

  depends_on = [azurerm_resource_group.rg_blob_storage]
}

# Blob container
resource "azurerm_storage_container" "blob_container" {
  name                  = "blob-${var.environment}"
  storage_account_id    = azurerm_storage_account.sa_blob_storage.id
  container_access_type = "private"

  depends_on = [azurerm_storage_account.sa_blob_storage]
}

# Random string for unique storage account name
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}
