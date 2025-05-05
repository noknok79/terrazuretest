variable "subscription_id" {
  description = "The subscription ID for the Azure resources."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the Azure resources."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)."
  type        = string
}

variable "owner" {
  description = "The owner of the resource."
  type        = string
}

variable "project" {
  description = "The project associated with the resource."
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
}

variable "geo_replication_locations" {
  description = "A list of locations for geo-replication of the ACR."
  type        = list(string)
  default     = []
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the subnet for the ACR."
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The address prefix for the subnet."
  type        = list(string)
}

variable "enable_private_endpoint" {
  description = "Whether to enable a private endpoint for the ACR."
  type        = bool
}

variable "private_endpoint_subnet" {
  description = "The subnet ID for the private endpoint."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
}