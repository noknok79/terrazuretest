# Variables for the compute/vm module

variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the existing subnet"
  type        = string
}

variable "vm_count" {
  description = "The number of virtual machines to create"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "The admin username for the Virtual Machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the Virtual Machine"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key for the virtual machine"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "public_ip_enabled" {
  description = "Whether to enable a public IP for the Virtual Machine"
  type        = bool
  default     = false
}

variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the Virtual Machine will be deployed"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_id" {
  description = "The ID of the virtual network"
  type        = string
}

variable "custom_script" {
  description = "The custom script to execute on the virtual machine"
  type        = string
  default     = "echo Hello, World!"
}

variable "subnet_configs" {
  description = "A list of subnet configurations for the virtual network"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}