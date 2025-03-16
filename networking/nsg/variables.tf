variable "resource_group_name" {
  description = "The name of the resource group where the NSG will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}