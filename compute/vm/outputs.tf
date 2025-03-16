# ...existing code...

# Outputs for relevant resources

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
  description = "The name of the resource group."
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
  description = "The name of the subnet."
}

output "network_interface_id" {
  value = azurerm_network_interface.nic.id
  description = "The ID of the network interface."
}

output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.vm.id
  description = "The ID of the virtual machine."
}

output "virtual_machine_public_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
  description = "The public IP address of the virtual machine."
}