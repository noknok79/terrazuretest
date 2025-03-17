# Variables
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "East US"
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault key for Cosmos DB encryption"
  type        = string
}