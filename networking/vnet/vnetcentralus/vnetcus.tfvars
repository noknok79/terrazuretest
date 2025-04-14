subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
resource_group_name = "RG-VNET-CENTRALUS"
location            = "centralus"
vnet_name           = "vnet-dev-centralus"
address_space       = ["10.1.0.0/16"]

subnets = {
  subnet3 = {
    name           = "subnet-akscluster"
    address_prefix = "10.1.2.0/24"
  }
  subnet4 = {
    name           = "subnet-azsqldbs"
    address_prefix = "10.1.7.0/24"
  }
  subnet5 = {
    name           = "subnet-computevm"
    address_prefix = "10.1.8.0/24"
  }
  subnet6 = {
    name           = "subnet-vmscaleset"
    address_prefix = "10.1.9.0/24"
  }
}

environment = "dev"
project     = "my-project"
tags = {
  Environment = "dev"
  Project     = "my-project"
}