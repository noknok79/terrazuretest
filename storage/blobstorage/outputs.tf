# Output for the Resource Group name
output "resource_group_name" {
  description = "The name of the resource group where the storage account is created."
  value       = azurerm_resource_group.rg_blob_storage.name
}

# Output for the Storage Account name
output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.sa_blob_storage.name
}

# Output for the Storage Account primary endpoint
output "storage_account_primary_endpoint" {
  description = "The primary endpoint for the storage account."
  value       = azurerm_storage_account.sa_blob_storage.primary_blob_endpoint
}

# Output for the Blob Container name
output "blob_container_name" {
  description = "The name of the blob container."
  value       = azurerm_storage_container.blob_container.name
}

# Output for the Blob Container URL
output "blob_container_url" {
  description = "The URL of the blob container."
  value       = "${azurerm_storage_account.sa_blob_storage.primary_blob_endpoint}${azurerm_storage_container.blob_container.name}"
}