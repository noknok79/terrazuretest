
# Variables for reusability and best practices
variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for accessing the storage account"
  type        = list(string)
  default     = [] # Default to no IP restrictions
}

# Output for visibility
output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.example.name
}