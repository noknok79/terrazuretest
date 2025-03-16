# Resource group name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Azure region
variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "East US"
}

# Virtual network address space
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Subnet address prefix
variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# NSG name
variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "default-nsg"
}

# SSH rule priority
variable "ssh_rule_priority" {
  description = "Priority for the SSH rule in the NSG"
  type        = number
  default     = 1000
}

# VMSS instance count
variable "vmss_instance_count" {
  description = "Number of VM instances in the scale set"
  type        = number
  default     = 2
}

# VM admin username
variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

# VM admin password
variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

# VMSS SKU
variable "vmss_sku" {
  description = "SKU for the Virtual Machine Scale Set"
  type        = string
  default     = "Standard_DS1_v2"
}

# VMSS OS image details
variable "vmss_image_publisher" {
  description = "Publisher of the VMSS OS image"
  type        = string
  default     = "Canonical"
}

variable "vmss_image_offer" {
  description = "Offer of the VMSS OS image"
  type        = string
  default     = "UbuntuServer"
}

variable "vmss_image_sku" {
  description = "SKU of the VMSS OS image"
  type        = string
  default     = "18.04-LTS"
}

variable "vmss_image_version" {
  description = "Version of the VMSS OS image"
  type        = string
  default     = "latest"
}


# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "vmss_instance_count" {
  description = "Number of VM instances in the scale set"
  type        = number
  default     = 2
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
