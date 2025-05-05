# VNet Configuration using Data Blocks
variable "vneteastus_config" {
  description = "Configuration for the VNet in East US"
  type = object({
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = list(string)
    subnets = map(object({
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
      subnet8 = {
        name           = "subnet-appgateway"
        address_prefix = "10.0.11.0/24"
      }
      subnet9 = {
        name           = "subnet-appservice"
        address_prefix = "10.0.12.0/24"
      }
      subnet10 = {
        name           = "subnet-acr"
        address_prefix = "10.0.13.0/24"
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
    subnets = map(object({
      name           = string
      address_prefix = string
    }))
    project         = string
    environment     = string
    subscription_id = string
    tenant_id       = string
    tags            = map(string)
    address_prefix  = string
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
      subnet2 = {
        name           = "subnet-akscluster-centralus"
        address_prefix = "10.1.2.0/24"
      }
      subnet3 = {
        name           = "AzureFirewallSubnet"
        address_prefix = "10.1.3.0/24"
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
    address_prefix = "10.1.0.0/16" # Added this attribute to match the type definition
  }
}


# VNet Configuration for West US
variable "vnetwestus_config" {
  description = "Configuration for the VNet in West US"
  type = object({
    resource_group_name = string
    location            = string
    vnet_name           = string
    address_space       = list(string)
    subnets = map(object({
      name           = string
      address_prefix = string
    }))
    project         = string
    environment     = string
    subscription_id = string
    tenant_id       = string
    tags            = map(string)
    address_prefix  = list(string)
  })

  default = {
    resource_group_name = "RG-VNET-WESTUS"
    location            = "westus"
    vnet_name           = "vnet-dev-westus"
    address_space       = ["10.2.0.0/16"]
    subnets = {
      subnet1 = {
        name           = "subnet-akscluster-westus"
        address_prefix = "10.2.2.0/24"
      },
      subnet2 = {
        name           = "subnet-azsqldbs-westus"
        address_prefix = "10.2.7.0/24"
      },
      subnet3 = {
        name           = "subnet-computevm-westus"
        address_prefix = "10.2.8.0/24"
      },
      subnet4 = {
        name           = "subnet-vmscaleset-westus"
        address_prefix = "10.2.9.0/24"
      },
      subnet5 = {
        name           = "subnet-appservice-westus"
        address_prefix = "10.2.10.0/24"
      },
      subnet6 = {
        name           = "subnet-keyvault"
        address_prefix = "10.2.6.0/24"
      }
      subnet7 = {
        name           = "AzureFirewallSubnet"
        address_prefix = "10.2.11.0/24"
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
    address_prefix = ["10.2.0.0/16"] # Fix: Ensure this is a list of strings
  }
}


output "eastus_vnet_and_subnets" {
  description = "Details of the East US VNet and its subnets, including names and address prefixes"
  value = {
    vnet_name     = var.vneteastus_config.vnet_name
    address_space = var.vneteastus_config.address_space
    subnets = [
      for subnet in var.vneteastus_config.subnets : {
        name           = subnet.name
        address_prefix = subnet.address_prefix
      }
    ]
  }
}


output "centralus_vnet_and_subnets" {
  description = "Details of the Central US VNet and its subnets, including names and address prefixes"
  value = {
    vnet_name     = var.vnetcentralus_config.vnet_name
    address_space = var.vnetcentralus_config.address_space
    subnets = [
      for subnet_key, subnet in var.vnetcentralus_config.subnets : {
        name           = subnet.name
        address_prefix = subnet.address_prefix
      }
    ]
  }
}

output "westus_vnet_and_subnets" {
  description = "Details of the West US VNet and its subnets, including names and address prefixes"
  value = {
    vnet_name     = var.vnetwestus_config.vnet_name
    address_space = var.vnetwestus_config.address_space
    subnets = [
      for subnet_key, subnet in var.vnetwestus_config.subnets : {
        name           = subnet.name
        address_prefix = subnet.address_prefix
      }
    ]
  }
}