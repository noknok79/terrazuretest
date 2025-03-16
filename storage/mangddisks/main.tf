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
resource "azurerm_resource_group" "rg_managed_disks" {
  name     = "rg-manageddisks-${var.environment}"
  location = var.location
  tags     = var.tags
}

# Managed Disk
resource "azurerm_managed_disk" "managed_disk" {
  name                 = "md-${var.environment}-${random_string.disk_suffix.result}"
  location             = azurerm_resource_group.rg_managed_disks.location
  resource_group_name  = azurerm_resource_group.rg_managed_disks.name
  storage_account_type = "Standard_LRS" # Use Standard_LRS or Premium_LRS based on requirements
  disk_size_gb         = var.disk_size_gb
  create_option        = "Empty" # Options: Empty, Import, Copy, Restore
  tags                 = var.tags

  depends_on = [azurerm_resource_group.rg_managed_disks]
}

# Random string for unique disk name suffix
resource "random_string" "disk_suffix" {
  length  = 6
  special = false
  upper   = false
}
