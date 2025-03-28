# This Terraform configuration defines resources for an Azure Key Vault instance.
# These resources have been set in the keyvault.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="security/keyvaults/keyvaults.tfvars" --out="keyvault.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="security/keyvaults/keyvaults.tfvars" --input=false
# #2 terraform destroy -var-file="security/keyvaults/keyvaults.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

terraform {
  required_version = ">= 1.4.6"
}

provider "azurerm" {
  alias           = "vnet" # Define the alias for the vnet provider
  subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "RG-vnet-${replace(var.environment, "/[^a-zA-Z0-9_-]/", "")}-${replace(var.location, "/[^a-zA-Z0-9_-]/", "")}"
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "./networking/vnet"

  providers = {
    azurerm = azurerm.vnet
  }

  # Pass individual variables
  vnet_name           = var.vnet_config.vnet_name
  resource_group_name = var.vnet_config.resource_group_name
  location            = var.vnet_config.location
  address_space       = var.vnet_config.address_space
  subnets             = var.vnet_config.subnets
  tags                = var.vnet_config.tags
  environment         = var.vnet_config.environment
  owner               = var.vnet_config.owner
  subscription_id     = var.subscription_id
  vnet_id             = var.vnet_config.vnet_id

  subnet_configs = [
    {
      name           = "subnet-akscluster"
      address_prefix = "10.0.2.0/23"
    },
    {
      name           = "subnet-azsqldbs"
      address_prefix = "10.0.7.0/24"
    },
    {
      name           = "subnet-computevm"
      address_prefix = "10.0.8.0/24"
    }
  ]


  virtual_network_name = "example-vnet"
}

# Grouped variables for better organization and maintainability
variable "vnet_config" {
  description = "Configuration for the Azure Virtual Network."
  type = object({
    vnet_name           = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subscription_id     = string
    subnets = optional(list(object({
      name           = string
      address_prefix = string
    })))
    tags        = map(string)
    environment = string
    owner       = string
    vnet_id     = string
  })
  default = {
    vnet_name           = "example-vnet"
    resource_group_name = "example-resource-group"
    location            = "eastus"
    address_space       = ["10.0.0.0/16"]
    subscription_id     = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    subnets = [
      {
        name           = "subnet-akscluster"
        address_prefix = "10.0.2.0/23"
      },
      {
        name           = "subnet-azsqldbs"
        address_prefix = "10.0.7.0/24"
      },
      {
        name           = "subnet-computevm"
        address_prefix = "10.0.8.0/24"
      },
      {
        name           = "subnet-vmscaleset"
        address_prefix = "10.0.9.0/24"
      }
    ]
    tags = {
      environment = "dev"
      owner       = "example-owner"
    }
    environment = "dev"
    owner       = "example-owner"
    vnet_id     = "example-vnet-id"
  }
}

output "vnet_config" {
  description = "Configuration details of the Virtual Network from the networking/vnet module"
  value = {
    vnet_name           = module.vnet.vnet_name
    vnet_address_space  = module.vnet.vnet_address_space
    vnet_id             = module.vnet.vnet_id
    vnet_resource_id    = module.vnet.vnet_resource_id
    resource_group_name = module.vnet.resource_group_name
    subnet_ids          = module.vnet.subnet_ids # Reference the correct output
  }
}





