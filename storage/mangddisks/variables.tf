# Variables
variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "disk_size_gb" {
  description = "The size of the managed disk in GB"
  type        = number
  default     = 128 # Default size is 128GB
}

variable "disk_encryption_set_id" {
  description = "The ID of the disk encryption set to use for customer-managed key encryption"
  type        = string
}