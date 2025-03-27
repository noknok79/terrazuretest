# Variables for reusability and best practices
variable "environment" {
  description = "The environment for the virtual network (e.g., dev, staging, prod)."
  type        = string
}

variable "location" {
  description = "The Azure region where the virtual network will be created."
  type        = string
}

variable "owner" {
  description = "The owner of the virtual network."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the virtual network will be created."
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnets to create within the virtual network."
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [] # Provide an empty list as the default value to make it optional
}

variable "tags" {
  description = "Tags to apply to the virtual network and its subnets."
  type        = map(string)
}

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "vnet_id" {
  description = "The ID of the Virtual Network"
  type        = string
}

variable "subnet_configs" {
  description = "Configuration for the subnets"
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}
