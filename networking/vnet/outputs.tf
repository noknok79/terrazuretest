output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = { for subnet in azurerm_subnet.subnets : subnet.name => subnet.id }
}