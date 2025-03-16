variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the storage account will be created"
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account (LRS, GRS, ZRS, etc.)"
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "The name of the blob container"
  type        = string
}

variable "container_access_type" {
  description = "The access level of the blob container (private, blob, or container)"
  type        = string
  default     = "private"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}