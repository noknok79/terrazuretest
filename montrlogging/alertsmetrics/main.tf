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
resource "azurerm_resource_group" "alerts_metrics_rg" {
  name     = "rg-alerts-metrics"
  location = var.location
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "alerts_metrics_law" {
  name                = "law-alerts-metrics"
  location            = azurerm_resource_group.alerts_metrics_rg.location
  resource_group_name = azurerm_resource_group.alerts_metrics_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Metric Alert
resource "azurerm_monitor_metric_alert" "cpu_high_alert" {
  name                = "cpu-high-alert"
  resource_group_name = azurerm_resource_group.alerts_metrics_rg.name
  scopes              = [azurerm_virtual_machine.example.id] # Replace with your VM or resource ID
  description         = "Alert for high CPU usage"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = azurerm_monitor_action_group.example.id # Replace with your action group ID
  }
  depends_on = [azurerm_virtual_machine.example]
}

# Action Group
resource "azurerm_monitor_action_group" "example" {
  name                = "action-group-alerts"
  resource_group_name = azurerm_resource_group.alerts_metrics_rg.name
  short_name          = "alerts"
  email_receiver {
    name          = "admin-email"
    email_address = var.admin_email
  }
}
