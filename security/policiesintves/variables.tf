
# Variables
variable "environment" {
  description = "The environment for the Policies and Initiatives (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}