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

resource "azurerm_storage_account" "example" {
  name                     = "st${var.environment}${var.location}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
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
  version                    = "~4" # Best practice: Use the latest stable runtime version
  os_type                    = "Linux" # Best practice: Use Linux for cost efficiency and flexibility
  identity {
    type = "SystemAssigned" # Best practice: Use managed identity for secure access
  }
  site_config {
    application_stack {
      dotnet_version = "6" # Example: Specify runtime stack (adjust as needed)
    }
    always_on = true # Best practice: Enable Always On for production workloads
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
