variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
  default     = "dev" # Default to 'dev' environment
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus" # Default Azure region
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "admin@example.com" # Replace with the actual owner email or name
}

variable "allowed_ssh_source" {
  description = "The allowed source IP range for SSH access"
  type        = string
  default     = "136.158.57.0/32" # Replace with your actual IP or range
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
  default     = "RG-VNET-EASTUS" # Default resource group name
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
  default     = "nsg-standard" # Default NSG name
}

variable "tags" {
  description = "Tags to apply to the NSG"
  type        = map(string)
  default     = {}
}