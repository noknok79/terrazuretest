terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestrg1001"
    container_name       = "tfstatecntnr1001"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# module "computevm" {
#   source              = "./compute/vm"
#   environment         = var.environment
#   location            = var.location
#   tags                = var.tags
#   vm_count            = var.vm_count
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   ssh_public_key_path = var.ssh_public_key_path
#   subscription_id     = var.subscription_id
# }

module "aks_cluster" {
  source = "./compute/aks"
  providers = {
    azurerm = azurerm
  }

  admin_group_object_ids     = var.admin_group_object_ids
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # General configuration
  environment = var.environment
  location    = var.location
  project     = var.project

  # AKS-specific configuration
  node_count                      = var.node_count
  vm_size                         = var.vm_size
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  # New required arguments
  windows_vm_size      = var.windows_vm_size
  authorized_ip_ranges = var.authorized_ip_ranges
  linux_vm_size        = var.linux_vm_size
  linux_node_count     = var.linux_node_count
  windows_node_count   = var.windows_node_count
  kubernetes_version   = var.kubernetes_version

  # Tags
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}




# module "vmscalesets" {
#   source = "./compute/vmscalesets"

#   environment = var.environment
#   location    = var.location
#   # resource_group_name is not required here
#   # resource_group_name = azurerm_resource_group.rg_aks.name
#   # vm_size is not required here
#   # vm_count is not required here
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   ssh_public_key_path = var.ssh_public_key_path
#   tags                = var.tags
#   subscription_id     = var.subscription_id
# }

