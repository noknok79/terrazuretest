output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.example.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.example.location
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.example.name
}

output "storage_account_primary_endpoint" {
  description = "The primary endpoint for the storage account"
  value       = azurerm_storage_account.example.primary_blob_endpoint
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.example.id
}