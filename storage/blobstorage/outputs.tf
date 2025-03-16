output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "blob_container_id" {
  description = "The ID of the blob container"
  value       = azurerm_storage_container.blob_container.id
}

output "blob_container_name" {
  description = "The name of the blob container"
  value       = azurerm_storage_container.blob_container.name
}