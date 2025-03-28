# This Terraform configuration defines resources for a Virtual Machine.
# These resources have been set in the computevm.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/vm/vm.tfvars" --out="computevm.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/vm/vm.tfvars" --input=false
# #2 terraform destroy -var-file="compute/vm/vm.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

# Define local values
# locals {
#   resource_group_name = "RG-vnet-dev-eastus"
#   location            = "East US"
#   vm_name             = "compute-vm-dev"
#   vm_size             = "Standard_DS1_v2"
#   admin_username      = "azureadmin"
#   admin_password      = "xQ3@mP4z!Bk8*wHy"
#   subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
#   vnet_name           = "vnet-dev-eastus"
#   subnet_name         = "subnet-computevm"
#   subnet_id           = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus/subnets/subnet-computevm"
#   vnet_id             = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus"
#   subnet_configs      = [
#     {
#       name           = "subnet-computevm"
#       address_prefix = "10.0.1.0/24"
#     }
#   ]
#   environment         = "dev"
#   tags                = {
#     environment = "dev"
#     owner       = "team"
#   }
#   address_space       = ["10.0.0.0/16"]
#   owner               = "team"
# }

# # Module block to create the networking resources

# terraform {
#   required_version = ">= 1.4.6"

#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">= 4.0.0, < 5.0.0" # Ensure consistent version
#     }
#   }
# }

# provider "azurerm" {
#   alias = "computevm"
#   subscription_id = var.subscription_id
#   features {}
# }

# module "vm" {
#   source                  = "./compute/vm"
#   providers = {
#     azurerm = azurerm.computevm
#   }
#   vm_name                 = local.vm_name
#   vm_size                 = local.vm_size
#   admin_username          = local.admin_username
#   admin_password          = local.admin_password
#   vnet_name               = local.vnet_name
#   subnet_name             = local.subnet_name
#   subnet_id               = local.subnet_id
#   public_ip_enabled       = var.public_ip_enabled
#   resource_group_name     = local.resource_group_name
#   location                = local.location
#   virtual_network_name    = local.vnet_name
#   subnet_address_prefixes = ["10.0.1.0/24"]
#   custom_script           = "echo Hello, World!"
#   subnet_configs          = local.subnet_configs
#   vnet_id                 = local.vnet_id
#   address_space           = local.address_space
# }

# module "networking" {
#   source               = "./networking/vnet" # Adjust the path to the actual location of the networking module
#   providers = {
#     azurerm = azurerm.computevm
#   }
#   resource_group_name  = local.resource_group_name
#   location             = local.location
#   address_space        = local.address_space
#   vnet_name            = local.vnet_name
#   virtual_network_name = local.vnet_name # Add this line to pass the required argument
#   tags                 = local.tags
#   environment          = local.environment
#   owner                = local.owner
# }

# # Data block to retrieve the virtual network from the networking/vnet module
# data "azurerm_virtual_network" "vnet" {
#   name                = module.networking.vnet_name
#   resource_group_name = module.networking.resource_group_name
# }

# # Data block to retrieve the subnet from the networking module
# data "azurerm_subnet" "subnet" {
#   name                 = module.networking.subnet_name
#   virtual_network_name = module.networking.vnet_name
#   resource_group_name  = module.networking.resource_group_name
# }

# # Data block to retrieve the existing virtual network
# data "azurerm_virtual_network" "existing_vnet" {
#   name                = var.vnet_name
#   resource_group_name = var.resource_group_name
# }

# # Module block to create the Virtual Machine

# # Output block to expose values from the compute/vm module
# output "vm_ids" {
#   description = "The ID of the Virtual Machine"
#   value       = module.vm.vm_ids
# }

# output "vm_public_ip" {
#   description = "The public IP address of the virtual machine"
#   value       = module.vm.vm_public_ip
# }

# output "subnet_name" {
#   description = "The name of the subnet from the networking module"
#   value       = module.networking.subnet_name
# }

# output "vnet_name" {
#   description = "The name of the virtual network from the networking module"
#   value       = module.networking.vnet_name
# }

# output "linux_vm_name" {
#   description = "The name of the Linux Virtual Machine"
#   value       = module.vm.linux_vm_name
# }

# output "windows_vm_name" {
#   description = "The name of the Windows Virtual Machine"
#   value       = module.vm.windows_vm_name
# }

# output "vm_name" {
#   description = "The name of the virtual machine"
#   value       = module.vm.vm_name
# }