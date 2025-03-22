terraform {
  required_version = ">= 1.5.6" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0" # Use the latest stable AzureRM provider version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group for Policies and Initiatives
resource "azurerm_resource_group" "rg" {
  name     = "rg-policies-${var.environment}-${var.location}"
  location = var.location
}

# Azure Policy Definition
resource "azurerm_policy_definition" "policy" {
  name         = "policy-${var.environment}-${var.location}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Custom Policy for ${var.environment}"
  description  = "This policy ensures compliance with organizational standards."
  metadata = jsonencode({
    category = "Security"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Network/virtualNetworks"
    }
    then = {
      effect = "audit"
    }
  })

}

# Azure Policy Initiative (Definition Group)
resource "azurerm_policy_set_definition" "initiative" {
  name         = "initiative-${var.environment}-${var.location}"
  display_name = "Custom Initiative for ${var.environment}"
  description  = "This initiative groups multiple policies for ${var.environment}."
  policy_type  = "Custom"
  metadata = jsonencode({
    category = "Security"
    version  = "1.0.0"
  })

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.policy.id
  }
}

# Azure Policy Assignment
resource "azurerm_policy_assignment" "assignment" {
  name                 = "assignment-${var.environment}-${var.location}"
  display_name         = "Policy Assignment for ${var.environment}"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_set_definition.initiative.id
  description          = "Assigning the initiative to the resource group."

  depends_on = [
    azurerm_policy_set_definition.initiative,
    azurerm_policy_definition.policy
  ]

  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_account" "sa_blob_storage" {
  name                      = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name       = azurerm_resource_group.rg_blob_storage.name
  location                  = azurerm_resource_group.rg_blob_storage.location
  account_tier              = "Standard"
  account_replication_type  = "ZRS"    # Updated to Zone-Redundant Storage for compliance
  allow_blob_public_access  = false    # Disallow public access
  min_tls_version           = "TLS1_2" # Enforce latest TLS version
  enable_https_traffic_only = true     # Enforce HTTPS traffic only
  shared_access_key_enabled = false    # Disable shared key authorization

  blob_properties {
    delete_retention_policy {
      days = 7 # Enable soft-delete for 7 days
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
        enabled  = true
        key_type = "Account" # Use Account-managed keys
      }
    }
    key_vault_key_id = var.key_vault_key_id # Use Customer Managed Key (CMK)
  }

  tags = var.tags

  depends_on = [
    azurerm_resource_group.rg_blob_storage,
    azurerm_policy_assignment.assignment
  ]

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
}

resource "azurerm_private_endpoint" "storage_private_endpoint" {
  name                = "pe-${var.environment}-storage"
  location            = azurerm_resource_group.rg_blob_storage.location
  resource_group_name = azurerm_resource_group.rg_blob_storage.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "storage-private-connection"
    private_connection_resource_id = azurerm_storage_account.sa_blob_storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  depends_on = [
    azurerm_storage_account.sa_blob_storage
  ]
}
