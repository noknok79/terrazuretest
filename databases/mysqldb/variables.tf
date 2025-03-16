
# Variables
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for MySQL server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for MySQL server"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "Owner of the resources for tagging purposes"
  type        = string
}
