

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
  })
  default = {
    subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
    resource_group_name = "RG-VNET-dev-eastus"
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
        address_prefix = "10.0.8.0/23"
      }
      subnet6 = {
        name           = "subnet-vmscaleset"
        address_prefix = "10.0.11.0/24"
      }
      subnet7 = {
        name           = "subnet-cosmosdb"
        address_prefix = "10.0.12.0/23"
      }
    }
    tags = {
      environment = "dev"
      owner       = "team"
    }
  }
}



# output "subnet_name" {
#   description = "The name of the subnet"
#   value       = module.vnet.subnets[2] # Assuming subnet5 is the third element

# }


