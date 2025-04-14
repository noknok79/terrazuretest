subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
resource_group_name_centralus = "RG-VNETCENTRALUS"
environment         = "dev"
project             = "example-project"
vnet_name_centralus = "vnet-dev-centralus"
address_space_centralus = ["10.1.0.0/16"]

subnets_centralus = {
  subnet1 = {
    name           = "subnet-akscluster-centralus"
    address_prefix = "10.1.2.0/24"
  }
  subnet2 = {
    name           = "subnet-azsqldbs-centralus"
    address_prefix = "10.1.7.0/24"
  }
  subnet3 = {
    name           = "subnet-computevm-centralus"
    address_prefix = "10.1.8.0/24"
  }
  subnet4 = {
    name           = "subnet-vmscaleset-centralus"
    address_prefix = "10.1.9.0/24"
  }
}

tags = {
  Environment = "dev"
  Project     = "example-project"
}

keyvault_subnet_address_prefix = "10.1.6.0/24"

