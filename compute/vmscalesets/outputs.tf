# Output for Resource Group Name
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

# Output for Virtual Network Name
output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

# Output for Subnet Name
output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

# Output for Virtual Machine Scale Set Instances
output "vmss_instances" {
  description = "The number of instances in the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.instances
}

# Output for Virtual Machine Scale Set SKU
output "vmss_sku" {
  description = "The SKU of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.sku
}

# Output for Virtual Machine Scale Set ID
output "vmss_id" {
  description = "The ID of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.id
}

# Output for Virtual Machine Scale Set Public IP
output "vmss_public_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

# Output for Virtual Machine Scale Set Instance Count
output "instance_count" {
  description = "The current instance count of the Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.instances
}

# Output for Virtual Machine Scale Set Name
output "vmss_name" {
  description = "The name of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.name
}

# Output for Subnets
output "subnets" {
  value = var.subnets
}