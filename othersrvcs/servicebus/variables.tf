# Variables
variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault key to use for encryption"
  type        = string
}
