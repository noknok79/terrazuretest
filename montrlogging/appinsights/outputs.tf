
# Outputs
output "application_insights_id" {
  value = azurerm_application_insights.app_insights.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.app_insights_law.id
}