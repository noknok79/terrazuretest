resource_group_name = "rg-example"
location            = "eastus"
vnet_name           = "vnet-dev-eastus"
vnet_address_space  = ["10.0.0.0/16"]
subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
aad_admin_object_id = "394166a3-9a96-4db9-94b7-c970f2c97b27"

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

vm_name        = "example-vm"
vm_size        = "Standard_DS1_v2"
admin_username = "azureuser"
admin_password = "P@ssw0rd123!"
subnet_name    = "subnet-akscluster"

environment = "dev"

tags = {
  environment = "dev"
  owner       = "team"
}