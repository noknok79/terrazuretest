# Variable for Resource Group Name
variable "resource_group_name" {
  description = "The name of the resource group for the Azure Container Registry."
  type        = string
}

# Variable for Resource Group Location
variable "resource_group_location" {
  description = "The location of the resource group for the Azure Container Registry."
  type        = string
}

# Variable for Azure Container Registry Name
variable "acr_name" {
  description = "The globally unique name of the Azure Container Registry."
  type        = string
}

# Variable for Azure Container Registry SKU
variable "acr_sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
}

# Variable for Key Vault Name
variable "key_vault_name" {
  description = "The name of the Key Vault for ACR encryption."
  type        = string
}

# Variable for Virtual Network Name
variable "vnet_name" {
  description = "The name of the Virtual Network for the private endpoint."
  type        = string
}

# Variable for Subnet Name
variable "subnet_name" {
  description = "The name of the Subnet for the private endpoint."
  type        = string
}

# Variable for Address Space of Virtual Network
variable "vnet_address_space" {
  description = "The address space of the Virtual Network."
  type        = list(string)
}

# Variable for Address Prefix of Subnet
variable "subnet_address_prefix" {
  description = "The address prefix of the Subnet."
  type        = list(string)
}

# Variable for Tags
variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
}

# Variable for Geo-replication Locations
variable "geo_replication_locations" {
  description = "The locations for geo-replication of the Azure Container Registry."
  type        = list(string)
}