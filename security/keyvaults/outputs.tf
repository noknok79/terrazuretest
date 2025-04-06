# Output the resource group name
output "resource_group_name" {
  description = "The name of the resource group where the Key Vault is deployed"
  value       = azurerm_resource_group.keyvault_rg.name
}

# Output the Key Vault name
output "key_vault_name" {
  description = "The name of the Azure Key Vault"
  value       = azurerm_key_vault.keyvault.name
}

# Output the Key Vault URI
output "key_vault_uri" {
  description = "The URI of the Azure Key Vault"
  value       = azurerm_key_vault.keyvault.vault_uri
}

# Output the Key Vault location
output "key_vault_location" {
  description = "The location of the Azure Key Vault"
  value       = azurerm_key_vault.keyvault.location
}

# Output the Key Vault resource ID
output "key_vault_id" {
  description = "The resource ID of the Azure Key Vault"
  value       = azurerm_key_vault.keyvault.id
}

# Remove subnet output if no subnet resource exists
# output "subnet_id" {
#   description = "The ID of the subnet for the Key Vault"
#   value       = azurerm_subnet.subnet.id
# }