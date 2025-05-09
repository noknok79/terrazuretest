subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
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

}

environment = "dev"
project     = "my-project"
tags = {
  Environment = "dev"
  Project     = "my-project"
}