# This Terraform configuration defines resources for an Azure Virtual Network (VNet).
# These resources have been set in the vnet.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="networking/vnet/vnet.tfvars" --out="vnet.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="networking/vnet/vnet.tfvars" --input=false
# #2 terraform destroy -var-file="networking/vnet/vnet.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

terraform {
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.64.0"
    }
  }
}



module "vnet" {
  source = "./networking/vnet"

  # Variables for the module
  resource_group_name = local.resource_group_name
  location            = local.location
  vnet_name           = local.vnet_name
  address_space       = local.address_space
  subnets             = local.subnets
  tags                = local.tags
}




locals {
  subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  aad_admin_object_id = "394166a3-9a96-4db9-94b7-c970f2c97b27"
  resource_group_name = "rg-example"
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
      name           = "ubnet-computevm"
      address_prefix = "10.0.8.0/23"
    }
    subnet6 = {
      name           = "subnet-vmscaleset"
      address_prefix = "10.0.9.0/2"
    }
  }

  tags = {
    environment = "dev"
    owner       = "team"
  }
}









