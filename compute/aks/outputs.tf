# Output the kubeconfig for the AKS cluster
output "kube_config" {
  description = "Kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

# Output the AKS cluster name
output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

# Output the resource group name
output "resource_group_name" {
  description = "The name of the resource group where the AKS cluster is deployed"
  value       = azurerm_resource_group.aks_rg.name
}

# Output the location of the resource group
output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.aks_rg.location
}