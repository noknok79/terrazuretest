# Output the resource group name
output "resource_group_name" {
  description = "The name of the resource group where the Key Vault is deployed"
  value       = azurerm_resource_group.rg.name
}

# Output the Key Vault name
output "key_vault_name" {
  description = "The name of the Azure Key Vault"
  value       = azurerm_key_vault.kv.name
}

# Output the Key Vault URI
output "key_vault_uri" {
  description = "The URI of the Azure Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

# Output the Key Vault location
output "key_vault_location" {
  description = "The location of the Azure Key Vault"
  value       = azurerm_key_vault.kv.location
}

# Output the Key Vault resource ID
output "key_vault_id" {
  description = "The resource ID of the Azure Key Vault"
  value       = azurerm_key_vault.kv.id
}