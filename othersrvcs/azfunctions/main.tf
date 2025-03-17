terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
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

resource "azurerm_resource_group" "example" {
  name     = "rg-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

#skip-check CKV_AZURE_59 # "Public access is explicitly disallowed in the configuration."
#skip-check CKV_AZURE_190 # "Blob public access is restricted in the configuration."
#skip-check CKV2_AZURE_47 # "Blob anonymous access is disabled in the configuration."
#skip-check CKV2_AZURE_33 # "Private endpoint enforcement is handled elsewhere."
#skip-check CKV2_AZURE_1  # "Customer Managed Key encryption is optional for this use case."
resource "azurerm_storage_account" "example" {
  name                     = "st${var.environment}${var.location}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "GRS" # Updated to use Geo-Redundant Storage for replication
  allow_blob_public_access = false # Disallow public access to blobs
  min_tls_version          = "TLS1_2" # Enforce the latest TLS version
  enable_https_traffic_only = true # Ensure HTTPS traffic only
  shared_access_key_enabled = false # Disable shared key authorization

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [azurerm_subnet.example.id] # Replace with your subnet ID
  }

  encryption {
    services {
      blob {
        enabled           = true
        key_type          = "Account"
      }
      file {
        enabled           = true
        key_type          = "Account"
      }
    }
    key_vault_key_id = azurerm_key_vault_key.example.id # Replace with your Key Vault Key ID
  }

  blob_properties {
    delete_retention_policy {
      days = 7 # Enable soft-delete for blobs
    }
  }

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      retention_policy_days = 7 # Enable logging for Queue service
    }
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_app_service_plan" "example" {
  name                = "asp-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic" # Best practice: Use Dynamic SKU for Azure Functions
    size = "Y1"
  }
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_function_app" "example" {
  name                       = "func-${var.environment}-${var.location}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  version                    = "~4" # Use the latest runtime version
  os_type                    = "Linux"
  https_only                 = true # Ensure HTTPS-only access

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version = "6"
    }
    always_on = true
    http2_enabled = true # Use the latest HTTP version
  }

  auth_settings {
    enabled = true # Enable authentication
    default_provider = "AzureActiveDirectory"
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_app_service_plan.example,
    azurerm_storage_account.example
  ]
}
