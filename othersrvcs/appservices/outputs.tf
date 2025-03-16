output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = azurerm_app_service_plan.example.name
}

output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_app_service_plan.example.id
}

output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_app_service.example.name
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_app_service.example.default_site_hostname
}

output "app_service_id" {
  description = "The ID of the App Service"
  value       = azurerm_app_service.example.id
}

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.example.name
}

output "resource_group_location" {
  description = "The location of the Resource Group"
  value       = azurerm_resource_group.example.location
}