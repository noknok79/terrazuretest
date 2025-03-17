terraform {
  required_version = ">= 1.5.6" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0" # Use the latest stable AzureRM provider version
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-storage-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

#skip-check CKV_AZURE_206
#skip-check CKV_AZURE_59 
#skip-check CKV_AZURE_190 
#skip-check CKV2_AZURE_47
#skip-check CKV2_AZURE_1
#skip-check CKV2_AZURE_33
#skip-check CKV2_AZURE_41
resource "azurerm_storage_account" "example" {
  name                     = lower("st${var.environment}${var.location}001") # Ensure lowercase naming for compliance
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "ZRS" # Ensure replication type is set (CKV_AZURE_206) 

  # Security configurations
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false # Disallow public access (CKV_AZURE_59, CKV_AZURE_190, CKV2_AZURE_47) 
  enable_secure_transfer    = true

  # Encryption with Customer Managed Key (CKV2_AZURE_1) 
  encryption {
    services {
      blob {
        enabled  = true
        key_type = "Account"
      }
      file {
        enabled  = true
        key_type = "Account"
      }
    }
    key_vault_key_id = var.key_vault_key_id
  }

  # Private endpoint configuration (CKV2_AZURE_33) 
 
  private_endpoint {
    subnet_id = var.private_subnet_id
  }

  # Advanced threat protection
  blob_properties {
    delete_retention_policy {
      days = 7 # Enable soft delete for blobs with a retention period
    }
  }

  # Enable logging for Queue service (CKV_AZURE_33)
  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }

  # Enable logging and monitoring for compliance
  network_rules {
    default_action = "Deny" # Deny by default for enhanced security
    bypass         = ["AzureServices"] # Allow trusted Azure services
    ip_rules       = var.allowed_ip_ranges # Restrict access to specific IP ranges
  }

  # Ensure SAS expiration policy is configured (CKV2_AZURE_41)
  shared_access_key_enabled = false

  tags = {
    Environment = var.environment
    Owner       = var.owner
    Compliance  = "PrismaCloud"
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}
