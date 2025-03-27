resource_group_name = "rg-example"
location            = "eastus"
vnet_name           = "vnet-example"
vnet_address_space  = ["10.0.0.0/16"]
subscription_id     = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
aad_admin_object_id = "394166a3-9a96-4db9-94b7-c970f2c97b27"

subnets = {
  subnet1 = {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
  subnet2 = {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }
}

tags = {
  environment = "dev"
  project     = "example-project"
}
