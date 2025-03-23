# Output for Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group where the VMSS is deployed."
  value       = azurerm_resource_group.rg_vmss.name
}

# Output for Virtual Network Name
output "virtual_network_name" {
  description = "The name of the virtual network used by the VMSS."
  value       = azurerm_virtual_network.vnet_vmss.name
}

# Output for Subnet Name
output "subnet_name" {
  description = "The name of the subnet used by the VMSS."
  value       = azurerm_subnet.subnet_vmss.name
}

# Output for Load Balancer Name
output "load_balancer_name" {
  description = "The name of the load balancer associated with the VMSS."
  value       = azurerm_lb.lb_vmss.name
}

# Output for Virtual Machine Scale Set Name
output "vmss_name" {
  description = "The name of the Virtual Machine Scale Set."
  value       = azurerm_linux_virtual_machine_scale_set.vmss.name
}

# Output for Virtual Machine Scale Set Instances
output "vmss_instances" {
  description = "The number of instances in the Virtual Machine Scale Set."
  value       = azurerm_linux_virtual_machine_scale_set.vmss.instances
}

# Output for Virtual Machine Scale Set SKU
output "vmss_sku" {
  description = "The SKU of the Virtual Machine Scale Set."
  value       = azurerm_linux_virtual_machine_scale_set.vmss.sku
}

