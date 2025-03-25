variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}


# Variables
variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}


variable "rg_vmss" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "team"
  }
}

variable "admin_username" {
  description = "Admin username for the virtual machine scale set"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine scale set"
  type        = string
  sensitive   = true
}

# Add your variable declarations here

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file to be used for authentication"
  type        = string
}
