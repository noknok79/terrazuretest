# This Terraform configuration defines resources for an AKS cluster.
# These resources have been set in the akscluster.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/aks/aks.tfvars" --out="akscluster.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/aks/aks.tfvars" --input=false
# #2 terraform destroy -var-file="compute/aks/aks.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>


terraform {
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  alias = "aksazure"
  features {}
  subscription_id = var.aks_config.subscription_id
  tenant_id       = var.aks_config.tenant_id
}

module "aks_cluster" {
  # DO NOT REMOVE THIS THIS BLOCK OF CODE
  source = "./compute/aks"
  providers = {
    azurerm = azurerm.aksazure
  }

  admin_group_object_ids     = var.aks_config.admin_group_object_ids
  log_analytics_workspace_id = var.aks_config.log_analytics_workspace_id

  # General configuration
  environment = var.aks_config.environment
  location    = var.aks_config.location
  project     = var.aks_config.project

  # AKS-specific configuration
  node_count                      = var.aks_config.node_count
  vm_size                         = var.aks_config.vm_size
  api_server_authorized_ip_ranges = var.aks_config.api_server_authorized_ip_ranges

  # New required arguments
  windows_vm_size      = var.aks_config.windows_vm_size
  authorized_ip_ranges = var.aks_config.authorized_ip_ranges
  linux_vm_size        = var.aks_config.linux_vm_size
  linux_node_count     = var.aks_config.linux_node_count
  windows_node_count   = var.aks_config.windows_node_count
  kubernetes_version   = var.aks_config.kubernetes_version

  # Tags
  tags = var.aks_config.tags
}

variable "aks_config" {
  description = "Configuration for the AKS cluster"
  type = object({
    location                        = string
    environment                     = string
    project                         = string
    node_count                      = number
    vm_size                         = string
    authorized_ip_ranges            = list(string)
    log_analytics_workspace_id      = string
    api_server_authorized_ip_ranges = list(string)
    admin_group_object_ids          = list(string)
    tags                            = map(string)
    kubernetes_version              = string
    linux_vm_size                   = string
    linux_node_count                = number
    windows_vm_size                 = string
    windows_node_count              = number
    subscription_id                 = string
    tenant_id                       = string
    admin_password                  = string
  })
  default = {
    location    = "East US"
    environment = "dev"
    project     = "aks-cluster-testing"

    kubernetes_version = "1.30.10"
    node_count         = 1
    vm_size            = "Standard_D2s_v3"

    linux_node_count = 3
    linux_vm_size    = "Standard_D2_v2"

    windows_node_count = 2
    windows_vm_size    = "Standard_D2_v2"

    api_server_authorized_ip_ranges = ["0.0.0.0/0"]
    authorized_ip_ranges            = ["0.0.0.0/0"]

    admin_group_object_ids = [
      "743472b6-0f67-4f53-bd45-a3b34a2e9fe2",
      "cecfb3fd-7113-401a-b3d2-216522cb3202"
    ]

    log_analytics_workspace_id = "test-log-analytics-workspace-id"

    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"

    tags = {
      Environment = "dev"
      Project     = "aks-cluster-testing"
    }

    admin_password = "xQ3@mP4z!Bk8*wHy"
  }
}

output "aks_outputs" {
  description = "Grouped outputs for the AKS cluster"
  value = {
    aks_cluster_id         = module.aks_cluster.aks_cluster_id
    aks_cluster_name       = module.aks_cluster.aks_cluster_name
    aks_cluster_fqdn       = module.aks_cluster.aks_cluster_fqdn
    kubeconfig             = module.aks_cluster.kubeconfig
    admin_group_object_ids = module.aks_cluster.admin_group_object_ids
    default_node_count     = module.aks_cluster.default_node_count
    linux_node_count       = module.aks_cluster.linux_node_count
    windows_node_count     = module.aks_cluster.windows_node_count
  }
  sensitive = true # Mark the output as sensitive
}
