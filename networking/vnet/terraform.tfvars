resource_group_name = "rg-example"
location            = "eastus"
vnet_name           = "vnet-example"
vnet_address_space  = ["10.0.0.0/16"]

subnets = {
  subnet1 = {
    name          = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
  subnet2 = {
    name          = "subnet2"
    address_prefix = "10.0.2.0/24"
  }
}

tags = {
  environment = "dev"
  project     = "example-project"
}