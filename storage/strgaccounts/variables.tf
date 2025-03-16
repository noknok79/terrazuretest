variable "resource_group_name" {
  description = "The name of the resource group in which to create resources."
  type        = string
  default     = "stroge-rg"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "The name of the storage account. Must be globally unique."
  type        = string
  default     = "examplestorageacct"
}

variable "account_tier" {
  description = "The performance tier of the storage account. Options are 'Standard' or 'Premium'."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication strategy for the storage account. Options are 'LRS', 'GRS', 'RAGRS', or 'ZRS'."
  type        = string
  default     = "LRS"
}

variable "enable_https_traffic_only" {
  description = "Whether to only allow HTTPS traffic to the storage account."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default = {
    environment = "production"
    owner       = "team-main-storage"
  }
}

variable "storage_container_name" {
  description = "The name of the storage container."
  type        = string
  default     = "script-container"
}

variable "container_access_type" {
  description = "The access type of the storage container. Options are 'private', 'blob', or 'container'."
  type        = string
  default     = "private"
}