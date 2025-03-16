variable "resource_group_name" {
  description = "The name of the resource group where the VNet will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the VNet will be created."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
}

variable "subnets" {
  description = "A map of subnets to create within the Virtual Network."
  type = map(object({
    name           = string
    address_prefix = string
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}