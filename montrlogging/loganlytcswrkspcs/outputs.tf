
# Outputs
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}

output "log_analytics_workspace_primary_shared_key" {
  value = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  sensitive = true
}