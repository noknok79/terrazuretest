
variable "environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "zones" {
  description = "Availability zones for the Azure Firewall"
  type        = list(string)
  default     = []
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}