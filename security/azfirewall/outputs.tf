output "firewall_name" {
  description = "The name of the Azure Firewall"
  value       = azurerm_firewall.azfw.name
}

output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = azurerm_firewall.azfw.id
}

output "firewall_ip_configuration" {
  description = "The IP configuration of the Azure Firewall"
  value       = azurerm_firewall.azfw.ip_configuration
}

output "azfirewall_rg_name" {
  value = azurerm_resource_group.azfirewall_rg.name
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "The name of the subnet for the Azure Firewall"
  value       = azurerm_subnet.firewall_subnet.name
}

output "firewall_location" {
  description = "The location of the Azure Firewall"
  value       = azurerm_firewall.azfw.location
}

output "public_ip_address" {
  description = "The public IP address of the Azure Firewall"
  value       = length(azurerm_public_ip.azfw_pip) > 0 ? azurerm_public_ip.azfw_pip[0].ip_address : null
}

# output "network_security_group_id" {
#   value = var.insert_nsg && length(azurerm_network_security_group.azfirewall_nsg) > 0 ? azurerm_network_security_group.azfirewall_nsg[0].id : null
#   description = "The ID of the Network Security Group if created, otherwise null."
# }

# output "missing_subnets" {
#   value = [for subnet in var.subnets : subnet.name if !can(data.azurerm_subnet.subnet_lookup(
#     name = subnet.name,
#     virtual_network_name = azurerm_virtual_network.vnet.name,
#     resource_group_name = var.resource_group_name
#   ))]
#   description = "List of subnets that are missing in the virtual network."
# }
# output "firewall_subnet_id" {
#   value = data.azurerm_subnet.subnet_lookup[0].id
#   description = "The ID of the subnet for the Azure Firewall"
# }
