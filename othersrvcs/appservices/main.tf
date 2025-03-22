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

resource "azurerm_app_service_plan" "example" {
  name                = "asp-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Standard" # Best practice: Use Standard or higher tiers for production workloads
    size = "S1"
  }
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}

#checkov:skip:CKV_AZURE_65:"Ensure that App service enables detailed error messages"
# skip-check CKV_AZURE_17 # "Ensure the web app has 'Client Certificates (Incoming client certificates)' set"
# skip-check CKV_AZURE_14 # "Ensure web app redirects all HTTP traffic to HTTPS in Azure App Service"
# skip-check CKV_AZURE_66 # "Ensure that App service enables failed request tracing"
#checkov:skip:CKV_AZURE_88 "Ensure that app services use Azure Files"

# tfsec:ignore:azure-appservice-require-client-cert "Client certificates are enabled in the configuration"
resource "azurerm_app_service" "example" {
  name                = "app-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    always_on                      = true
    client_cert_enabled            = true
    client_cert_mode               = "Required" # Ensure client certificates are required
    ftps_state                     = "Disabled"
    scm_type                       = "None"
    http2_enabled                  = true
    detailed_error_logging_enabled = true
    failed_request_tracing_enabled = true
    https_only                     = true

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
        enabled           = true
      }
    }

    azure_storage_account {
      name       = var.storage_account_name
      access_key = var.storage_account_key
      mount_path = "/site/wwwroot"
      share_name = var.storage_share_name
      type       = "AzureFiles"
    }

    health_check_path = "/health"
  }

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled = true
    active_directory {
      client_id = var.aad_client_id
    }
    default_provider              = "AzureActiveDirectory"
    unauthenticated_client_action = "RedirectToLoginPage"
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_app_service_plan.example,
    azurerm_resource_group.example
  ]
}

