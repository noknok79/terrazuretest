# VNet Configuration using Data Blocks
variable "vneteastus_config" {
  description = "Configuration for the VNet in East US"
  type = object({
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = list(string)
    subnets             = map(object({
      name           = string
      address_prefix = string
    }))
    project         = string
    environment     = string
    subscription_id = string
    tenant_id       = string
    tags            = map(string)
  })

  default = {
    resource_group_name = "RG-VNET-EASTUS"
    location            = "eastus"
    vnet_name           = "vnet-dev-eastus"
    address_space       = ["10.0.0.0/16"]
    subnets = {
      subnet1 = {
        name           = "subnet-akscluster"
        address_prefix = "10.0.2.0/24"
      },
      subnet2 = {
        name           = "subnet-azsqldbs"
        address_prefix = "10.0.7.0/24"
      },
      subnet3 = {
        name           = "subnet-cosmosdb"
        address_prefix = "10.0.8.0/24"
      },
      subnet4 = {
        name           = "subnet-vmscaleset"
        address_prefix = "10.0.9.0/24"
      },
      subnet5 = {
        name           = "subnet-keyvault"
        address_prefix = "10.0.6.0/24"
      },
      subnet6 = {
        name           = "subnet-computevm"
        address_prefix = "10.0.3.0/24"
      },
      subnet7 = {
        name           = "subnet-mysqldb"
        address_prefix = "10.0.10.0/24"
      }
    }
    project         = "my-project"
    environment     = "dev"
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    tags = {
      "Environment" = "dev"
      "Project"     = "my-project"
      "Owner"       = "team-name"
    }
  }
}

variable "vnetcentralus_config" {
  description = "Configuration for the VNet in Central US"
  type = object({
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = list(string)
    subnets             = map(object({
      name           = string
      address_prefix = string
    }))
    project         = string
    environment     = string
    subscription_id = string
    tenant_id       = string
    tags            = map(string)
  })

  default = {
    resource_group_name = "RG-VNET-CENTRALUS"
    location            = "centralus"
    vnet_name           = "vnet-dev-centralus"
    address_space       = ["10.1.0.0/16"]
    subnets = {
      subnet1 = {
        name           = "subnet-psqldb-centralus"
        address_prefix = "10.1.1.0/24"
      }
    }
    project         = "project-centralus"
    environment     = "dev"
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    tags = {
      "Environment" = "dev"
      "Project"     = "project-centralus"
      "Owner"       = "team-name"
    }
  }
}

# Outputs

# Outputs for vnet_centralus
output "vnet_centralus_name" {
  description = "The name of the virtual network in Central US"
  value       = module.vnet_centralus.vnet_name
}

output "vnet_centralus_address_space" {
  description = "The address space of the virtual network in Central US"
  value       = module.vnet_centralus.address_space
}

# output "vnet_centralus_subnets" {
#   description = "A map of all subnets with their names and address prefixes in Central US"
#   value       = module.vnet_centralus.subnets
# }

output "vnet_centralus_subnet_names" {
  description = "A list of all subnet names in Central US"
  value       = [for subnet_key, subnet in module.vnet_centralus.subnets : subnet.name]
}

output "vnet_centralus_subnet_address_prefixes" {
  description = "A list of all subnet address prefixes in Central US"
  value       = [for subnet_key, subnet in module.vnet_centralus.subnets : subnet.address_prefix]
}

# Outputs for vnet_eastus
output "vnet_eastus_name" {
  description = "The name of the virtual network in East US"
  value       = module.vnet_eastus.vnet_name
}

output "vnet_eastus_address_space" {
  description = "The address space of the virtual network in East US"
  value       = module.vnet_eastus.address_space
}

output "vnet_eastus_subnets" {
  description = "A map of all subnets with their names and address prefixes in East US"
  value       = module.vnet_eastus.subnets
}

output "vnet_eastus_subnet_names" {
  description = "A list of all subnet names in East US"
  value       = [for subnet_key, subnet in module.vnet_eastus.subnets : subnet.name]
}

output "vnet_eastus_subnet_address_prefixes" {
  description = "A list of all subnet address prefixes in East US"
  value       = [for subnet_key, subnet in module.vnet_eastus.subnets : subnet.address_prefix]
}

output "vnet_subnets" {
  description = "A list of subnets with their names and IDs"
  value = [
    for subnet_key, subnet in module.vnet_eastus.subnets : {
      name           = subnet.name
      id             = subnet.id
      address_prefix = subnet.address_prefix
    }
  ]
}

output "vnet_centralus_subnets" {
  description = "A list of subnets with their names and IDs"
  value = module.vnet_centralus.subnets
}

output "vnet_subnets_centralus" {
  description = "A list of subnets with their names and IDs"
  value = module.vnet_centralus.subnets
}

output "vnet_eastus_ubnets" {
  description = "A map of subnets with their names and IDs"
  value       = { for subnet_name, subnet in module.vnet_eastus.subnets : subnet_name => { id = subnet.id, network_security_group_id = subnet.network_security_group_id } }
}

output "vnet_eastus_vnet_id" {
  description = "The ID of the virtual network"
  value       = module.vnet_eastus.vnet_id
}