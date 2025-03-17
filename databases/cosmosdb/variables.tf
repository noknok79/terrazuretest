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

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for Cosmos DB access"
  type        = list(string)
  default     = [] # Provide default or override in tfvars

  validation {
    condition     = alltrue([for ip in var.allowed_ip_ranges : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", ip))])
    error_message = "Each IP range must be a valid CIDR block (e.g., 192.168.1.0/24)."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet for Cosmos DB VNet integration"
  type        = string
}