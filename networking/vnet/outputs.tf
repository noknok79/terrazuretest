output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "A map of subnet names to their IDs"
  value       = { for name, subnet in azurerm_subnet.vnet_subnets : name => subnet.id }
}

# output "subnets" {
#   description = "The subnets in the Virtual Network"
#   value       = [for subnet in azurerm_subnet.vnet_subnets : subnet.id]
# }

output "vnet_subnets" {
  description = "A list of subnets with their details"
  value = [
    for subnet in azurerm_subnet.vnet_subnets :
    {
      name           = subnet.name
      id             = subnet.id
      address_prefix = subnet.address_prefixes[0] # Use the first address prefix
    }
  ]
}