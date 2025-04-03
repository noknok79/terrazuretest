variable "resource_group_name" {
  description = "The name of the existing resource group for the VNet"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "A map of subnets to create, with each subnet containing a name and address prefix"
  type = map(object({
    name           = string
    address_prefix = string
  }))
}

variable "tags" {
  description = "Tags to associate with resources"
  type        = map(string)
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string  
  
}

variable "project" {
  description = "The project name for the resources"
  type        = string   
}