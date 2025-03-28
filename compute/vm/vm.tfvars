resource_group_name = "RG-vnet-dev-eastus"

location = "East US"

vm_name = "compute-vm-dev"

vm_size = "Standard_DS1_v2"

admin_username = "azureadmin"

admin_password = "xQ3@mP4z!Bk8*wHy"

subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"

vnet_name = "vnet-dev-eastus"

subnet_name = "subnet-computevm"

subnet_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus/subnets/subnet-computevm"

vnet_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-vnet-dev-eastus/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus"

subnet_configs = [
  {
    name           = "subnet-computevm"
    address_prefix = "10.0.1.0/24"
  }
]

environment = "dev"

tags = {
  environment = "dev"
  owner       = "team"
}

address_space = ["10.0.0.0/16"]

owner = "team"