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

module "vnet" {
  source = "./networking/vnet"

  # Pass the aliased provider to the module
  providers = {
    azurerm = azurerm.vnet
  }

  resource_group_name = var.vnet_config_group.resource_group_name
  location            = var.vnet_config_group.location
  vnet_name           = var.vnet_config_group.vnet_name
  address_space       = var.vnet_config_group.address_space
  subnets             = var.vnet_config_group.subnets
  tags                = var.vnet_config_group.tags
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

module "compute_vm" {
  source = "./compute/vm"

  # Pass the vm_config variable to the module
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
  os_type                       = var.vm_config.os_type
  ssh_public_key                = file("/root/.ssh/id_rsa.pub") # Pass the SSH public key

  virtual_network_name          = module.vnet.vnet_name
  subnet_name                   = module.vnet.vnet_subnets[2].name # Assuming subnet5 is the third element
  address_space                 = module.vnet.address_space
  subnet_address_prefix         = module.vnet.vnet_subnets[2].address_prefix # Assuming subnet5 is the third element
  

  # Ensure the compute_vm module depends on the vnet module
  depends_on = [
    module.vnet
  ]
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

