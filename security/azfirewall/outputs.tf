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

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "The name of the subnet for the Azure Firewall"
  value       = azurerm_subnet.firewall_subnet.name
}

output "public_ip_address" {
  description = "The public IP address assigned to the Azure Firewall"
  value       = azurerm_public_ip.azfw_pip.ip_address
}

output "firewall_location" {
  description = "The location of the Azure Firewall"
  value       = azurerm_firewall.azfw.location
}