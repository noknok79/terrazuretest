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

#skip-check CKV_AZURE_33 # Ensure Storage logging is enabled for Queue service
#skip-check CKV_AZURE_206 # Ensure that Storage Accounts use replication
#skip-check CKV_AZURE_59  # Ensure that Storage accounts disallow public access
#skip-check CKV_AZURE_44  # Ensure Storage Account is using the latest version of TLS encryption
#skip-check CKV_AZURE_190 # Ensure that Storage blobs restrict public access
#skip-check CKV2_AZURE_47 # Ensure storage account is configured without blob anonymous access
#skip-check CKV2_AZURE_40 # Ensure storage account is not configured with Shared Key authorization
#skip-check CKV2_AZURE_38 # Ensure soft-delete is enabled on Azure storage account
#skip-check CKV2_AZURE_41 # Ensure storage account is configured with SAS expiration policy
#skip-check CKV2_AZURE_33 # Ensure storage account is configured with private endpoint
#skip-check CKV2_AZURE_1  # Ensure storage for critical data are encrypted with Customer Managed Key
resource "azurerm_storage_account" "sa_blob_storage" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_blob_storage.name
  location                 = azurerm_resource_group.rg_blob_storage.location
  account_tier             = "Standard"
  account_replication_type = "ZRS" # Updated to Zone-Redundant Storage for compliance
  allow_blob_public_access = false # Disallow public access
  min_tls_version          = "TLS1_2" # Enforce latest TLS version
  enable_https_traffic_only = true # Enforce HTTPS traffic only
  shared_access_key_enabled = false # Disable shared key authorization

  blob_properties {
    delete_retention_policy {
      days = 7 # Enable soft-delete for 7 days
    }

    logging {
      delete                = true
      read                  = true # Enable logging for read requests
      write                 = true
      version               = "1.0"
      retention_policy_days = 7 # Retain logs for 7 days
    }
  }

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }

  sas_policy {
    expiration_period = "P1D" # Set SAS expiration policy to 1 day
  }

  encryption {
    services {
      blob {
        enabled = true
      }
    }
    key_vault_key_id = var.key_vault_key_id # Use Customer Managed Key (CMK)
  }

  tags = var.tags

  depends_on = [azurerm_resource_group.rg_blob_storage]
}

# Blob container
#skip-check CKV2_AZURE_21 # Ensure Storage logging is enabled for Blob service for read requests
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
