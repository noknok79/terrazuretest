output "resource_group_name" {
  description = "The name of the resource group where the NSG is deployed"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "The location of the resource group where the NSG is deployed"
  value       = azurerm_resource_group.rg.location
}

output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = azurerm_network_security_group.nsg.name
}

output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg.id
}

output "nsg_security_rules" {
  description = "The security rules defined in the Network Security Group"
  value       = azurerm_network_security_group.nsg.security_rule
}