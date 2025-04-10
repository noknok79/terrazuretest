# Variables
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for MySQL server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for MySQL server"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "Owner of the resources for tagging purposes"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the MySQL server"
  type        = string
}

variable "server_name" {
  description = "The name of the MySQL server"
  type        = string 
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string  
}

variable "network_security_group_id" {
  description = "The ID of the network security group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network"
  type        = string
}