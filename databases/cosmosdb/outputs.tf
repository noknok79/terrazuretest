# Output the Resource Group name
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.keyvault_rg.name
}

# Output the Resource Group location
output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.keyvault_rg.location
}

# Output the Random String Suffix
output "keyvault_suffix" {
  description = "The random string suffix for the Key Vault"
  value       = random_string.unique_suffix.result
}

# Output the Virtual Network name
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.keyvault_vnet.name
}

# Output the Virtual Network ID
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.keyvault_vnet.id
}

# Output the Subnet name




# Output the Key Vault ID
output "keyvault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.keyvault.id
}

# Output the Key Vault Tenant ID
output "keyvault_tenant_id" {
  description = "The tenant ID of the Key Vault"
  value       = azurerm_key_vault.keyvault.tenant_id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.keyvault_subnet.name
}

# Output the Subnet ID
output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.keyvault_subnet.id
}



output "keyvault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.keyvault.name
}

output "keyvault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.keyvault.vault_uri
}



# Output for Cosmos DB Account Endpoint
output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}

# Output for Cosmos DB Primary Key
output "cosmosdb_primary_key" {
  value      = data.azurerm_cosmosdb_account.cosmosdb.primary_key
  sensitive  = true
}

# Output for Cosmos DB Secondary Key
output "cosmosdb_secondary_key" {
  value      = data.azurerm_cosmosdb_account.cosmosdb.secondary_key
  sensitive  = true
}