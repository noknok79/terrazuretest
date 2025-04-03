variable "resource_group_name" {
  description = "The name of the existing resource group for the VM"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
}

variable "image_reference" {
  description = "The image reference for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "linux_custom_script_command" {
  description = "Custom script command for Linux VMs"
  type        = string
}

variable "windows_custom_script_command" {
  description = "Custom script command for Windows VMs"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "os_type" {
  description = "The operating system type of the VM (Linux or Windows)"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM will be deployed"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
  
}

variable "project" {
  description = "The project name for the deployment"
  type        = string
  
}