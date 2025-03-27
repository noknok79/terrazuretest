# Define required variables for the compute/vm module

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
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

variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "public_ip_enabled" {
  description = "Flag to enable or disable public IP for the Virtual Machine"
  type        = bool
  default     = false
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the Subnet"
  type        = string
}