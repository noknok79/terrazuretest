
# Outputs

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.subnet.id
}

output "network_security_group_name" {
  description = "The name of the network security group"
  value       = azurerm_network_security_group.nsg.name
}

output "network_interface_id" {
  description = "The ID of the network interface"
  value       = azurerm_network_interface.nic.id
}

output "vmss_name" {
  description = "The name of the Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "vmss_instances" {
  description = "The number of instances in the Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.instances
}