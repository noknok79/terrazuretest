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
resource "azurerm_resource_group" "log_analytics_rg" {
  name     = "rg-log-analytics"
  location = var.location
  #skip-check: Ensure resource group creation is independent
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "law-log-analytics"
  location            = azurerm_resource_group.log_analytics_rg.location
  resource_group_name = azurerm_resource_group.log_analytics_rg.name
  sku                 = "PerGB2018"                               # Best practice: Use the most cost-effective SKU
  retention_in_days   = 30                                        # Retention period for logs
  depends_on          = [azurerm_resource_group.log_analytics_rg] #skip-check: Ensure dependency on resource group
}

# Diagnostic Setting (Optional for Integration)
resource "azurerm_monitor_diagnostic_setting" "log_analytics_diagnostic" {
  name                       = "diag-log-analytics"
  target_resource_id         = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  log {
    category = "Administrative"
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
    azurerm_log_analytics_workspace.log_analytics
  ] #skip-check: Ensure dependency on Log Analytics Workspace
}

