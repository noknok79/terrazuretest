variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
}

# Output for Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group"
  value       = var.resource_group_name
}

# Output for Virtual Network Name
output "virtual_network_name" {
  description = "The name of the virtual network used by the VM."
  value       = var.virtual_network_name
}

# Output for Subnet Name
output "subnet_name" {
  description = "The name of the subnet"
  value       = var.subnet_configs[0].name
}

# Output for Network Interface Name
output "network_interface_name" {
  description = "The name of the network interface attached to the VM."
  value       = azurerm_network_interface.nic_vm.name
}

# Output for Virtual Machine Name
output "virtual_machine_name" {
  description = "The name of the virtual machine."
  value       = azurerm_linux_virtual_machine.vm.name
}

# Output for Virtual Machine Private IP
output "virtual_machine_private_ip" {
  description = "The private IP address of the virtual machine."
  value       = azurerm_network_interface.nic_vm.ip_configuration[0].private_ip_address
}

# Output for Virtual Machine OS Disk
output "virtual_machine_os_disk" {
  description = "The OS disk of the virtual machine."
  value       = azurerm_linux_virtual_machine.vm.os_disk[0].name
}

# Output for Virtual Machine ID
output "virtual_machine_id" {
  description = "The ID of the virtual machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

# Output for Virtual Machine IDs
output "vm_ids" {
  description = "The IDs of all virtual machines."
  value       = [azurerm_linux_virtual_machine.vm.id]
}

# Output for Virtual Machine Public IPs
output "public_ips" {
  description = "The public IP addresses of the virtual machines."
  value       = [azurerm_public_ip.vm_ip.ip_address]
}

# Output for Subnet IDs
output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = [azurerm_subnet.subnet_vm.id]
}

# Output for Virtual Network ID
output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.vnet_vm.id
}

# Output for Subnet ID

output "location" {
  description = "The location of the resources"
  value       = azurerm_resource_group.rg.location
}

output "subnet_id" {
  description = "The ID of the subnet where the Virtual Machine is deployed"
  value       = var.subnet_id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = var.vnet_name
}

output "linux_vm_name" {
  description = "The name of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.linux_vm.name
}

output "windows_vm_name" {
  description = "The name of the Windows Virtual Machine"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.vm_ip.ip_address
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.name
}
