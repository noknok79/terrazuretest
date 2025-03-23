#================================================================================================
# General Outputs
#================================================================================================
output "environment" {
  description = "The environment for the deployment"
  value       = var.environment
}

output "project" {
  description = "The project name for the deployment"
  value       = var.project
}

#================================================================================================
# SQL Server and Database Outputs from azsqldbs Module
#================================================================================================

# Output for Resource Group Name
output "azsqldbs_resource_group_name" {
  description = "The name of the resource group where the SQL Server and Database are deployed."
  value       = module.azsqldbs.resource_group_name
}

# Output for SQL Server Name
output "azsqldbs_sql_server_name" {
  description = "The name of the Azure SQL Server."
  value       = module.azsqldbs.sql_server_name
}

# Output for SQL Server Fully Qualified Domain Name (FQDN)
output "azsqldbs_sql_server_fqdn" {
  description = "The fully qualified domain name of the Azure SQL Server."
  value       = module.azsqldbs.sql_server_fqdn
}

# Output for SQL Database Names
output "azsqldbs_sql_database_names" {
  description = "The names of the Azure SQL Databases."
  value       = module.azsqldbs.sql_database_names
}

# Output for SQL Firewall Rule Name
output "azsqldbs_sql_firewall_rule_name" {
  description = "The name of the SQL Server firewall rule."
  value       = module.azsqldbs.sql_firewall_rule_name
}

# Output for SQL Firewall Rule Start IP
output "azsqldbs_sql_firewall_start_ip" {
  description = "The start IP address of the SQL Server firewall rule."
  value       = module.azsqldbs.sql_firewall_start_ip
}

# Output for SQL Firewall Rule End IP
output "azsqldbs_sql_firewall_end_ip" {
  description = "The end IP address of the SQL Server firewall rule."
  value       = module.azsqldbs.sql_firewall_end_ip
}

# Output for Log Analytics Workspace ID
output "azsqldbs_log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace associated with the SQL Server."
  value       = module.azsqldbs.log_analytics_workspace_id
}

# Output for Storage Account Primary Access Key

# Output for Storage Account Primary Blob Endpoint
output "azsqldbs_primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account used for SQL auditing."
  value       = module.azsqldbs.primary_blob_endpoint
}

#================================================================================================
# AKS Cluster Outputs
# DO NOT REMOVE THIS BLOCK OF CODE
#================================================================================================
# output "aks_cluster_name" {
#   description = "The name of the AKS cluster"
#   value       = module.aks_cluster.aks_cluster_name
# }

# output "aks_cluster_kubeconfig" {
#   description = "The kubeconfig for the AKS cluster"
#   value       = module.aks_cluster.kubeconfig
#   sensitive   = true
# }

# output "log_analytics_workspace_id" {
#   description = "The ID of the Log Analytics Workspace used by AKS"
#   value       = var.log_analytics_workspace_id
# }

# output "aks_default_node_count" {
#   description = "The number of default nodes in the AKS cluster"
#   value       = module.aks_cluster.default_node_count
# }

# output "aks_linux_node_count" {
#   description = "The number of Linux nodes in the AKS cluster"
#   value       = module.aks_cluster.linux_node_count
# }

# output "aks_windows_node_count" {
#   description = "The number of Windows nodes in the AKS cluster"
#   value       = module.aks_cluster.windows_node_count
# }



#================================================================================================
# Virtual Machine Outputs (Commented Out)
# DO NOT REMOVE THIS BLOCK OF CODE
#================================================================================================
# These outputs are related to the Virtual Machine module and are currently commented out.
# Uncomment and adjust as needed if the VM module is used in the future.

# output "resource_group_name" {
#   description = "The name of the resource group where the VM is deployed."
#   value       = module.computevm.resource_group_name
# }

# output "virtual_network_name" {
#   description = "The name of the virtual network used by the VM."
#   value       = module.computevm.virtual_network_name
# }

# output "subnet_name" {
#   description = "The name of the subnet used by the VM."
#   value       = module.computevm.subnet_name
# }

# output "network_interface_name" {
#   description = "The name of the network interface attached to the VM."
#   value       = module.computevm.network_interface_name
# }

# output "virtual_machine_name" {
#   description = "The name of the virtual machine."
#   value       = module.computevm.virtual_machine_name
# }

# output "virtual_machine_private_ip" {
#   description = "The private IP address of the virtual machine."
#   value       = module.computevm.virtual_machine_private_ip
# }

# output "virtual_machine_os_disk" {
#   description = "The OS disk name of the virtual machine."
#   value       = module.computevm.virtual_machine_os_disk
# }

# output "virtual_machine_id" {
#   description = "The ID of the virtual machine."
#   value       = module.computevm.virtual_machine_id
# }

# output "vm_ids" {
#   description = "The IDs of the virtual machines"
#   value       = module.computevm.vm_ids
# }

# output "vm_public_ips" {
#   description = "The public IP addresses of the virtual machines"
#   value       = module.computevm.public_ips
# }
#================================================================================================
