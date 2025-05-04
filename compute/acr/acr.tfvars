# Resource Group Name
resource_group_name = "RG-ACR"
# Resource Group Location
resource_group_location = "eastus"
# Azure Container Registry Name
acr_name = "acrExample123"
# Azure Container Registry SKU
acr_sku = "Premium"
# Key Vault Name
key_vault_name = "kv-acr-example"
# Virtual Network Name
vnet_name = "vnet-acr-example"
# Subnet Name
subnet_name = "subnet-acr"
# Address Space of Virtual Network
vnet_address_space = ["10.0.0.0/16"]
# Address Prefix of Subnet
subnet_address_prefix = ["10.0.1.0/24"]
# Tags
tags = {
  Environment = "Production"
  Owner       = "TeamName"
  Purpose     = "ContainerRegistry"
}
# Geo-replication Locations
geo_replication_locations = ["West US", "Central US"]