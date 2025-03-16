terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "app_insights_rg" {
  name     = "rg-app-insights"
  location = var.location
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "app-insights"
  location            = azurerm_resource_group.app_insights_rg.location
  resource_group_name = azurerm_resource_group.app_insights_rg.name
  application_type    = "web" # Change to "other" if not a web application
  retention_in_days   = 90    # Retention period for logs
  depends_on          = [azurerm_resource_group.app_insights_rg]
}

# Log Analytics Workspace (Optional for Integration)
resource "azurerm_log_analytics_workspace" "app_insights_law" {
  name                = "law-app-insights"
  location            = azurerm_resource_group.app_insights_rg.location
  resource_group_name = azurerm_resource_group.app_insights_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Linking Application Insights to Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "app_insights_diagnostic" {
  name                       = "diag-app-insights"
  target_resource_id         = azurerm_application_insights.app_insights.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.app_insights_law.id

  log {
    category = "Request"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  depends_on = [
    azurerm_application_insights.app_insights,
    azurerm_log_analytics_workspace.app_insights_law
  ]
}
