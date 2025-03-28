resource_group_name = "rg-example"
location            = "eastus"
vnet_name           = "vnet-dev-eastus"
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

vnet_config = {
  resource_group_name = "RG-vnet-dev-eastus"
  subnet_ids = {
    subnet-akscluster = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus/subnets/subnet-akscluster"
    subnet-azsqldbs   = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus/subnets/subnet-azsqldbs"
    subnet-computevm  = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus/subnets/subnet-computevm"
    subnet-vmscaleset = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus/subnets/subnet-vmscaleset"
  }
  vnet_address_space = toset([
    "10.0.0.0/16",
  ])
  vnet_id          = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus"
  vnet_name        = "vnet-dev-eastus"
  vnet_resource_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus"
}

tags = {
  environment = "dev"
  project     = "example-project"
}
