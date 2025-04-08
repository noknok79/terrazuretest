

variable "vnet_config_group" {
  description = "Configuration group for managing related settings"
  type = object({
    subscription_id     = string
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = list(string)
    subnets = map(object({
      name           = string
      address_prefix = string
    }))
    tags = map(string)
        environment  = string
    project      = string
  })
  default = {
    subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
    resource_group_name = "RG-VNET"
    location            = "eastus"
    vnet_name           = "vnet-dev-eastus"
    environment         = "dev"
    project             = "vnet-project"
    address_space       = ["10.0.0.0/16"]
    subnets = {
      subnet3 = {
        name           = "subnet-akscluster"
        address_prefix = "10.0.2.0/24"
      }
      subnet4 = {
        name           = "subnet-azsqldbs"
        address_prefix = "10.0.3.0/24"
      }
      subnet5 = {
        name           = "subnet-computevm"
        address_prefix = "10.0.4.0/24"
      }
      subnet6 = {
        name           = "subnet-vmscaleset"
        address_prefix = "10.0.5.0/24"
      }
      subnet7 = {
        name           = "subnet-keyvault"
        address_prefix = "10.0.6.0/24"
        # private_endpoint_subnet in AKS Cluster =  "10.0.7.0./24"
        # should move to 10.0.8.0/24 for next subnet in VNET
      }
      subnet8 = {
        name           = "subnet-private-endpoint"
        address_prefix = "10.0.7.0/24"  # Adjusted to avoid overlap
      }

    }
    tags = {
      environment   = "dev"
      project       = "vnet-project-testing"
    }
  }
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

