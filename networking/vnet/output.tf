

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.vnet.address_space
}



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