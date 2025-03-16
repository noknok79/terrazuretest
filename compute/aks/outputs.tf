# Output for the Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group where the AKS cluster is deployed."
  value       = azurerm_resource_group.aks_rg.name
}

# Output for the Virtual Network Name
output "virtual_network_name" {
  description = "The name of the virtual network used by the AKS cluster."
  value       = azurerm_virtual_network.aks_vnet.name
}

# Output for the Subnet Name
output "subnet_name" {
  description = "The name of the subnet used by the AKS cluster."
  value       = azurerm_subnet.aks_subnet.name
}

# Output for the AKS Cluster Name
output "aks_cluster_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

# Output for the AKS Cluster FQDN
output "aks_cluster_fqdn" {
  description = "The fully qualified domain name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

# Output for the AKS Cluster System Assigned Identity
output "aks_identity_principal_id" {
  description = "The Principal ID of the system-assigned identity for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# Output for the AKS Cluster API Server URL
output "aks_api_server_url" {
  description = "The API server URL of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config[0].host
}

# Output for the AKS Cluster Admin Kubeconfig
output "aks_admin_kubeconfig" {
  description = "The admin kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}