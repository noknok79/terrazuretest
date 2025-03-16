
# Variables
variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "East US"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}