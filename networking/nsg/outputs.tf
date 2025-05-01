output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg_standard.id
}

output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = azurerm_network_security_group.nsg_standard.name
}

output "resource_group_id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.rg.name
}