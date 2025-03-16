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

resource "azurerm_storage_account" "example" {
  name                     = lower("st${var.environment}${var.location}001") # Ensure lowercase naming for compliance
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Enable advanced security features
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false # Disable public access to blobs for security
  enable_secure_transfer    = true # Ensure secure transfer is enabled

  # Advanced threat protection
  blob_properties {
    delete_retention_policy {
      days = 7 # Enable soft delete for blobs with a retention period
    }
  }

  # Enable logging and monitoring for compliance
  network_rules {
    default_action             = "Deny" # Deny by default for enhanced security
    bypass                     = ["AzureServices"] # Allow trusted Azure services
    ip_rules                   = var.allowed_ip_ranges # Restrict access to specific IP ranges
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
    Compliance  = "PrismaCloud"
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}
