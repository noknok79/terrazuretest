output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.example.name
}

output "resource_group_location" {
  description = "The location of the Resource Group"
  value       = azurerm_resource_group.example.location
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.example.name
}

output "storage_account_id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.example.id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = azurerm_app_service_plan.example.name
}

output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_app_service_plan.example.id
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = azurerm_function_app.example.name
}

output "function_app_id" {
  description = "The ID of the Function App"
  value       = azurerm_function_app.example.id
}

output "function_app_default_hostname" {
  description = "The default hostname of the Function App"
  value       = azurerm_function_app.example.default_hostname
}