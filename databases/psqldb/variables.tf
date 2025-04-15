# Subscription and Tenant Information
variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account"
  type        = string
}

# Resource Group
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
}

# Project and Environment
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

# Virtual Network
variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_subnets" {
  description = "A list of subnets in the virtual network"
  type = list(object({
    name           = string
    id             = string
    address_prefix = string
  }))
}

# PostgreSQL Flexible Server
variable "psql_server_name" {
  description = "The name of the PostgreSQL Flexible Server"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the PostgreSQL Flexible Server (e.g., GP_Standard_D2s_v2)"
  type        = string
}

variable "admin_username" {
  description = "The administrator username for the PostgreSQL Flexible Server"
  type        = string
}

variable "admin_password" {
  description = "The administrator password for the PostgreSQL Flexible Server"
  type        = string
  sensitive   = true
}

# Storage Account
variable "storage_account_name" {
  description = "The base name of the storage account. A unique suffix will be appended."
  type        = string
}

variable "storage_container_name" {
  description = "The base name of the storage container. A unique suffix will be appended."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the PostgreSQL server will be deployed."
  type        = string
}

