terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  alias = "vnet"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias = "aksazure"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias = "compute"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

# # Resource group for VNet
# resource "azurerm_resource_group" "rg_vnet" {
#   provider = azurerm.vnet
#   name     = var.vnet_config_group.resource_group_name
#   location = var.vnet_config_group.location
#   tags     = var.vnet_config_group.tags
# }

# # Resource group for Compute VM
# resource "azurerm_resource_group" "rg_compute" {
#   provider = azurerm.compute
#   name     = var.vm_config.resource_group_name
#   location = var.vm_config.location
#   tags     = var.vm_config.tags
# }

# # Resource group for AKS
# resource "azurerm_resource_group" "rg_akscluster" {
#   provider = azurerm.aksazure
#   name     = var.aks_config.resource_group_name
#   location = var.aks_config.location
#   tags     = var.aks_config.tags
# }

# VNet Module
module "vnet" {
  source = "./networking/vnet"

  providers = {
    azurerm = azurerm.vnet
  }

  resource_group_name = var.vnet_config_group.resource_group_name
  location            = var.vnet_config_group.location
  vnet_name           = var.vnet_config_group.vnet_name
  address_space       = var.vnet_config_group.address_space
  subnets             = var.vnet_config_group.subnets
  
  subscription_id     = var.vnet_config_group.subscription_id
  tags                = var.vnet_config_group.tags
  environment         = var.vnet_config_group.environment
  project             = var.vnet_config_group.project
}

output "vnet_name" {
  description = "The name of the existing virtual network"
  value       = module.vnet.vnet_name
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = module.vnet.address_space
}

output "vnet_subnets" {
  description = "A list of subnets with their details"
  value       = module.vnet.vnet_subnets
}

output "subnet_name" {
  description = "The name of a specific subnet (e.g., subnet5)"
  value       = module.vnet.vnet_subnets[2].name # Assuming subnet5 is the third element
}

output "subnet_address_prefix" {
  description = "The address prefix of a specific subnet (e.g., subnet5)"
  value       = module.vnet.vnet_subnets[2].address_prefix # Assuming subnet5 is the third element
}

# Compute VM Module
module "compute_vm" {
  source = "./compute/vm"

  providers = {
    azurerm = azurerm.compute
  }

  resource_group_name           = var.vm_config.resource_group_name
 
  location                      = var.vm_config.location
  prefix                        = var.vm_config.prefix
  vm_size                       = var.vm_config.vm_size
  admin_username                = var.vm_config.admin_username
  admin_password                = var.vm_config.admin_password
  os_disk_storage_account_type  = var.vm_config.os_disk_storage_account_type
  image_reference               = var.vm_config.image_reference
  linux_custom_script_command   = var.vm_config.linux_custom_script_command
  windows_custom_script_command = var.vm_config.windows_custom_script_command
  tags                          = var.vm_config.tags
  environment         = var.vm_config.environment
  project             = var.vm_config.project
  os_type                       = var.vm_config.os_type
  ssh_public_key                = file("/root/.ssh/id_rsa.pub")

  virtual_network_name  = module.vnet.vnet_name
  subnet_name           = module.vnet.vnet_subnets[2].name # Assuming subnet5 is the third element
  address_space         = module.vnet.address_space
  subnet_address_prefix = module.vnet.vnet_subnets[2].address_prefix # Assuming subnet5 is the third element
  subnet_id = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-computevm"
  )
}

output "vm_id" {
  description = "The ID of the created virtual machine"
  value       = module.compute_vm.vm_id
}

output "vm_name" {
  description = "The name of the created virtual machine"
  value       = module.compute_vm.vm_name
}

output "vm_private_ip" {
  description = "The private IP address of the virtual machine"
  value       = module.compute_vm.private_ip
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine (if applicable)"
  value       = module.compute_vm.public_ip
}

# AKS Module
module "aks" {
  source = "./compute/aks"

  providers = {
    azurerm = azurerm.aksazure
  }

  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
  resource_group_name = var.aks_config.resource_group_name
  location            = var.aks_config.location
  dns_prefix          = var.aks_config.dns_prefix
  vnet_name           = module.vnet.vnet_name
  subnet_id = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-akscluster"
  )
  cluster_name                    = var.aks_config.cluster_name
  kubernetes_version              = var.aks_config.kubernetes_version
  linux_vm_size                   = var.aks_config.linux_vm_size
  linux_node_count                = var.aks_config.linux_node_count
  windows_vm_size                 = var.aks_config.windows_vm_size
  windows_node_count              = var.aks_config.windows_node_count
  vm_size                         = var.aks_config.vm_size
  node_count                      = var.aks_config.node_count
  admin_group_object_ids          = var.aks_config.admin_group_object_ids
  authorized_ip_ranges            = var.aks_config.authorized_ip_ranges
  api_server_authorized_ip_ranges = var.aks_config.api_server_authorized_ip_ranges
  log_analytics_workspace_id      = var.aks_config.log_analytics_workspace_id
  tags                            = var.aks_config.tags
  environment                     = var.aks_config.environment
  project                         = var.aks_config.project
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.aks_cluster_id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_cluster_name
}

