# VNet Configuration
variable "vneteastus_config" {
  description = <<EOT
Configuration for the virtual network, including resource group, location, address space, and subnets.
The structure should be:
{
  resource_group_name = "resource-group-name"
  location            = "azure-region"
  vnet_name           = "virtual-network-name"
  address_space       = ["address-space"]
  subnets = {
    subnet_key = {
      name           = "subnet-name"
      address_prefix = "subnet-address-prefix"
    }
  }
}
EOT
  type = object({
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = list(string)
    subnets             = map(object({
      name           = string
      address_prefix = string
    }))
  })
  default = {
    resource_group_name = "RG-VNETEASTUS"
    location            = "eastus"
    vnet_name           = "vnet-dev-eastus"
    address_space       = ["10.0.0.0/16"]
    subnets = {
      subnet3 = {
        name           = "subnet-akscluster"
        address_prefix = "10.0.2.0/23"
      }
      subnet4 = {
        name           = "subnet-azsqldbs"
        address_prefix = "10.0.7.0/24"
      }
      subnet5 = {
        name           = "subnet-computevm"
        address_prefix = "10.0.8.0/24"
      }
      subnet6 = {
        name           = "subnet-vmscaleset"
        address_prefix = "10.0.9.0/24"
      }
    }
  }
}

# Outputs
output "vnet_name" {
  description = "The name of the existing virtual network"
  value       = var.vnet_config.vnet_name
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = var.vnet_config.address_space
}

output "vnet_subnets" {
  description = "A list of subnets with their details"
  value       = var.vnet_config.subnets
}

output "subnet_name" {
  description = "The name of a specific subnet (e.g., subnet5)"
  value       = var.vnet_config.subnets["subnet5"].name
}

output "subnet_address_prefix" {
  description = "The address prefix of a specific subnet (e.g., subnet5)"
  value       = var.vnet_config.subnets["subnet5"].address_prefix
}

