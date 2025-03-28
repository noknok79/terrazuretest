# This Terraform configuration defines resources for a Virtual Machine.
# These resources have been set in the computevm.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/vm/vm.tfvars" --out="computevm.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/vm/vm.tfvars" --input=false
# #2 terraform destroy -var-file="compute/vm/vm.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

# Define variables for the compute/vm module


# Module block to create the networking resources

terraform {
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0" # Ensure consistent version
    }
  }
}

provider "azurerm" {
  alias = "computevm"
  subscription_id = var.subscription_id
  features {}
}


module "vm" {
  source                  = "./compute/vm"
    providers = {
    azurerm = azurerm.computevm
  }
  vm_name                 = var.vm_name
  vm_size                 = var.vm_size
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  vnet_name               = module.networking.vnet_name
  subnet_name             = module.networking.subnet_name
  subnet_id               = data.azurerm_subnet.subnet.id
  public_ip_enabled       = var.public_ip_enabled
  resource_group_name     = module.networking.resource_group_name
  location                = var.location
  virtual_network_name    = module.networking.vnet_name
  subnet_address_prefixes = ["10.0.1.0/24"]
  custom_script           = "echo Hello, World!"
  subnet_configs = [
    {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"
    }
  ]
  vnet_id       = module.networking.vnet_resource_id
  address_space = var.address_space
}

module "networking" {
  source               = "./networking/vnet" # Adjust the path to the actual location of the networking module
   providers = {
    azurerm = azurerm.computevm
  }
  resource_group_name  = var.resource_group_name
  location             = var.location
  address_space        = var.address_space
  vnet_name            = var.vnet_name
  subscription_id      = var.subscription_id
  tags                 = var.tags
  environment          = var.environment
  owner                = var.owner
  subnet_configs       = var.subnet_configs
  vnet_id              = var.vnet_id
  virtual_network_name = var.vnet_name # Add this argument
}

# Data block to retrieve the virtual network from the networking/vnet module
data "azurerm_virtual_network" "vnet" {
  name                = module.networking.vnet_name
  resource_group_name = module.networking.resource_group_name
}

# Data block to retrieve the subnet from the networking module
data "azurerm_subnet" "subnet" {
  name                 = module.networking.subnet_name
  virtual_network_name = module.networking.vnet_name
  resource_group_name  = module.networking.resource_group_name
}

# Data block to retrieve the existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Module block to create the Virtual Machine




variable "vnet_id" {
  description = "The ID of the virtual network"
  type        = string
}

variable "subnet_configs" {
  description = "A list of subnet configurations for the virtual network"
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the Virtual Machine will be deployed"
  type        = string
}

# Output block to expose values from the compute/vm module
output "vm_ids" {
  description = "The ID of the Virtual Machine"
  value       = module.vm.vm_ids
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine"
  value       = module.vm.vm_public_ip
}

output "subnet_name" {
  description = "The name of the subnet from the networking module"
  value       = module.networking.subnet_name
}

output "vnet_name" {
  description = "The name of the virtual network from the networking module"
  value       = module.networking.vnet_name
}

output "linux_vm_name" {
  description = "The name of the Linux Virtual Machine"
  value       = module.vm.linux_vm_name
}

output "windows_vm_name" {
  description = "The name of the Windows Virtual Machine"
  value       = module.vm.windows_vm_name
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = module.vm.vm_name
}