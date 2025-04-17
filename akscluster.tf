variable "aks_config" {
  description = "Configuration for the AKS cluster"
  type = object({
        resource_group_name           = string

    location                      = string
    dns_prefix                    = string
    cluster_name                  = string
    kubernetes_version            = string
    linux_vm_size                 = string
    linux_node_count              = number
    windows_vm_size               = string
    windows_node_count            = number
    vm_size                       = string
    node_count                    = number
    admin_group_object_ids        = list(string)
    authorized_ip_ranges          = list(string)
    api_server_authorized_ip_ranges = list(string)
    log_analytics_workspace_id    = string
    tags                          = map(string)
    environment                   = string
    project                       = string
    subscription_id               = string
    tenant_id                     = string
  })
  default = {
    resource_group_name = "RG-AKSCLUSTER"
    location            = "eastus"
    dns_prefix          = "aks-dns-prefix"
    kubernetes_version = "1.30.11"
    node_count          = 3
    vm_size             = "Standard_DS2_v2"
    linux_vm_size       = "Standard_D2_v2"
    linux_node_count    = 3
    windows_vm_size     = "Standard_D2_v2"
    windows_node_count  = 2
    subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    vnet_name           = "vnet-dev-eastus"
    subnet_id           = "subnet-id-placeholder"
    subnet_name         = "subnet-akscluster"
    cluster_name        = "aks-cluster-dev"
    tags = {
      Environment = "dev"
      Project     = "aks-cluster-testing"
    }
    admin_group_object_ids = [
      "743472b6-0f67-4f53-bd45-a3b34a2e9fe2",
      "cecfb3fd-7113-401a-b3d2-216522cb3202"
    ]
    authorized_ip_ranges            = ["0.0.0.0/0"]
    log_analytics_workspace_id      = "test-log-analytics-workspace-id"
    api_server_authorized_ip_ranges = ["0.0.0.0/0"]
    environment                     = "dev"
    project                         = "aks-cluster-testing"
  }
}


output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.aks_cluster_id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_cluster_name
}