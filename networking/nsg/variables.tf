variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "allowed_ssh_source" {
  description = "The allowed source IP range for SSH access"
  type        = string
  default     = "203.0.113.0/32" # Replace with your actual IP or range
}