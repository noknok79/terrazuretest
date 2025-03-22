# Output for Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group where the VM is deployed."
  value       = azurerm_resource_group.rg_vm.name
}

# Output for Virtual Network Name
output "virtual_network_name" {
  description = "The name of the virtual network used by the VM."
  value       = azurerm_virtual_network.vnet_vm.name
}

# Output for Subnet Name
output "subnet_name" {
  description = "The name of the subnet used by the VM."
  value       = azurerm_subnet.subnet_vm.name
}

# Output for Network Interface Name
output "network_interface_name" {
  description = "The name of the network interface attached to the VM."
  value       = [for nic in azurerm_network_interface.nic_vm : nic.name]
}

# Output for Virtual Machine Name
output "virtual_machine_name" {
  description = "The name of the virtual machine."
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

# Output for Virtual Machine Public IP
output "virtual_machine_private_ip" {
  description = "The private IP address of the virtual machine."
  value       = [for nic in azurerm_network_interface.nic_vm : nic.ip_configuration[0].private_ip_address]
}

# Output for Virtual Machine OS Disk
output "virtual_machine_os_disk" {
  description = "The OS disk name of the virtual machine."
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.os_disk[0].name]
}

output "virtual_machine_id" {
  description = "The ID of the virtual machine."
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.id]
}

output "vm_ids" {
  description = "The IDs of the virtual machines"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.id]
}

output "public_ips" {
  description = "The public IP addresses of the virtual machines"
  value       = [for ip in azurerm_public_ip.vm_ip : ip.ip_address]
}
