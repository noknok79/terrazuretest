variable "acr_config" {
  description = "Configuration for the Azure Container Registry and related resources."
  type = object({
    subscription_id           = string
    tenant_id                 = string
    resource_group_name       = string
    location                  = string
    environment               = string
    owner                     = string
    project                   = string
    acr_name                  = string
    acr_sku                   = string
    geo_replication_locations = list(string)
    vnet_name                 = string
    vnet_address_space        = list(string)
    subnet_name               = string
    subnet_address_prefixes   = list(string)
    enable_private_endpoint   = bool
    private_endpoint_subnet   = string
    tags                      = map(string)
  })

  default = {
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    resource_group_name       = "RG-ACR"
    location                  = "eastus"
    environment               = "Production"
    owner                     = "TeamName"
    project                   = "ContainerRegistry"
    acr_name                  = "acrdeveastus"
    acr_sku                   = "Premium"
    geo_replication_locations = ["West US", "Central US"]
    vnet_name                 = "vnet-dev-eastus"
    vnet_address_space        = ["10.0.0.0/16"]
    subnet_name               = "subnet-acr"
    subnet_address_prefixes   = ["10.0.13.0/24"]
    enable_private_endpoint   = true
    private_endpoint_subnet   = "subnet-id"
    tags = {
      Environment = "Production"
      Owner       = "TeamName"
      Purpose     = "ContainerRegistry"
    }
  }
}
