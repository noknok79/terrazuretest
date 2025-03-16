
# Variables for reusability and best practices
variable "environment" {
  description = "The environment for the resource (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where the resource will be created"
  type        = string
}

variable "owner" {
  description = "The owner of the resource"
  type        = string
}