# Output for Resource Group Name
# output "resource_group_name" {
#   description = "The name of the resource group where the VM is deployed."
#   value       = module.computevm.resource_group_name
# }

# # Output for Virtual Network Name
# output "virtual_network_name" {
#   description = "The name of the virtual network used by the VM."
#   value       = module.computevm.virtual_network_name
# }

# # Output for Subnet Name
# output "subnet_name" {
#   description = "The name of the subnet used by the VM."
#   value       = module.computevm.subnet_name
# }

# # Output for Network Interface Name
# output "network_interface_name" {
#   description = "The name of the network interface attached to the VM."
#   value       = module.computevm.network_interface_name
# }

# # Output for Virtual Machine Name
# output "virtual_machine_name" {
#   description = "The name of the virtual machine."
#   value       = module.computevm.virtual_machine_name
# }

# # Output for Virtual Machine Private IP
# output "virtual_machine_private_ip" {
#   description = "The private IP address of the virtual machine."
#   value       = module.computevm.virtual_machine_private_ip
# }

# # Output for Virtual Machine OS Disk
# output "virtual_machine_os_disk" {
#   description = "The OS disk name of the virtual machine."
#   value       = module.computevm.virtual_machine_os_disk
# }

# # Output for Virtual Machine ID
# output "virtual_machine_id" {
#   description = "The ID of the virtual machine."
#   value       = module.computevm.virtual_machine_id
# }

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks_cluster.name
}

output "aks_cluster_kubeconfig" {
  description = "The kubeconfig for the AKS cluster"
  value       = module.aks_cluster.kubeconfig
  sensitive   = true
}

# output "vm_ids" {
#   description = "The IDs of the virtual machines"
#   value       = module.computevm.vm_ids
# }

# output "vm_public_ips" {
#   description = "The public IP addresses of the virtual machines"
#   value       = module.computevm.public_ips
# }

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used by AKS"
  value       = var.log_analytics_workspace_id
}

output "environment" {
  description = "The environment for the deployment"
  value       = var.environment
}

output "project" {
  description = "The project name for the deployment"
  value       = var.project
}
