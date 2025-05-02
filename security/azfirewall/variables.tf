variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account"
  type        = string
}

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
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "azfirewall_policy_name" {
  description = "Name of the Azure Firewall Policy"
  type        = string
}

variable "azfirewall_name" {
  description = "Name of the Azure Firewall"
  type        = string
}

variable "azfirewall_pip_name" {
  description = "Name of the public IP for the Azure Firewall"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier for the Azure Firewall. Use 'Premium' for advanced features."
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Azure Firewall. Use 'AZFW_VNet' for VNet SKU."
  type        = string
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for the Azure Firewall subnet"
  type        = string
}

variable "pip_allocation_method" {
  description = "Allocation method for the public IP (Static or Dynamic)"
  type        = string
}

variable "pip_sku" {
  description = "SKU for the public IP (Standard or Basic)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "use_public_ip" {
  description = "Boolean to determine if a public IP should be created and attached to the Azure Firewall"
  type        = bool
}

variable "subnets" {
  description = "List of subnets to be created"
  type = list(object({
    name = string
    address_prefix = string
    id   = string
  }))
}
