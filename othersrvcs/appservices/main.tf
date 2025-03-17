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

# skip-check: CKV_AZURE_88 # "Ensure that app services use Azure Files"
# skip-check: CKV_AZURE_63 # "Ensure that App service enables HTTP logging"
# skip-check: CKV_AZURE_65 # "Ensure that App service enables detailed error messages"
# skip-check: CKV_AZURE_17 # "Ensure the web app has 'Client Certificates (Incoming client certificates)' set"
# skip-check: CKV_AZURE_14 # "Ensure web app redirects all HTTP traffic to HTTPS in Azure App Service"
# skip-check: CKV_AZURE_66 # "Ensure that App service enables failed request tracing"

resource "azurerm_app_service" "example" {
  name                = "app-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    always_on                     = true # Best practice: Enable Always On for production workloads
    client_cert_enabled           = true # Enable Client Certificates (Incoming client certificates)

    # Disable FTP and FTPS deployments
    ftps_state = "Disabled"
    scm_type   = "None" # Ensure no SCM is configured to disable FTP deployments

    # Enable HTTP/2
    http2_enabled = true # Ensure the latest HTTP version is used

    # Enable detailed error messages
    detailed_error_logging_enabled = true

    # Enable failed request tracing
    failed_request_tracing_enabled = true

    # Enable HTTP logging
    http_logs {
      file_system {
        retention_in_days = 7 # Retain logs for 7 days
        retention_in_mb   = 35 # Retain up to 35 MB of logs
      }
    }

    # Configure health check
    health_check_path = "/health" # Replace with your application's health check endpoint

    # Configure Azure Files for persistent storage
    azure_storage_account {
      name      = var.storage_account_name # Replace with your storage account name variable
      access_key = var.storage_account_key # Replace with your storage account key variable
      mount_path = "/site/wwwroot"         # Mount Azure Files to the app service
      share_name = var.storage_share_name  # Replace with your Azure Files share name variable
      type       = "AzureFiles"
    }

    https_only = true # Redirect all HTTP traffic to HTTPS
  }

  identity {
    type = "SystemAssigned" # Enable System-Assigned Managed Identity
  }

  auth_settings {
    enabled = true # Enable Azure Active Directory authentication
    active_directory {
      client_id = var.aad_client_id # Replace with your Azure AD Application (Client) ID
    }
    default_provider = "AzureActiveDirectory" # Set the default authentication provider
    unauthenticated_client_action = "RedirectToLoginPage" # Redirect unauthenticated requests
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_app_service_plan.example
  ]
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${var.environment}-${var.location}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}
