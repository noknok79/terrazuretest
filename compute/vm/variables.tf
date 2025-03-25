# Variables
variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}


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
  default = {
    environment = "dev"
    owner       = "team"
  }
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "/root/.ssh/id_rsa.pub"
}

# Add a variable for VM count
variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 1
}
