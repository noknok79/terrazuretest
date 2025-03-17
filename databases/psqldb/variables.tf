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
  description = "Administrator username for PostgreSQL server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "trusted_start_ip" {
  description = "Start of the trusted IP range"
  type        = string
  default     = "192.168.1.1" # Replace with your trusted IP
}

variable "trusted_end_ip" {
  description = "End of the trusted IP range"
  type        = string
  default     = "192.168.1.255" # Replace with your trusted IP
}
