variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
}

variable "os_disk_caching" {
  description = "The caching mode for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "The publisher of the source image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the source image"
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "The SKU of the source image"
  type        = string
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "The version of the source image"
  type        = string
  default     = "latest"
}