output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

# Output AKS cluster details
output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "kubeconfig" {
  description = "The kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive   = true
}

output "name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "admin_group_object_ids" {
  value = var.admin_group_object_ids
}

# Output for the number of nodes in the default node pool
output "default_node_count" {
  description = "The number of nodes in the default node pool"
  value       = azurerm_kubernetes_cluster.aks_cluster.default_node_pool[0].node_count
}

# Output for the number of nodes in the Linux node pool
output "linux_node_count" {
  description = "The number of nodes in the Linux node pool"
  value       = azurerm_kubernetes_cluster_node_pool.linux_node_pool.node_count
}

# Output for the number of nodes in the Windows node pool
output "windows_node_count" {
  description = "The number of nodes in the Windows node pool"
  value       = azurerm_kubernetes_cluster_node_pool.windows_node_pool.node_count
}

