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

variable "address_prefixes" {
  description = "Address prefixes for the firewall subnet"
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
  default     = "Standard"
}

variable "sku_name" {
  description = "The SKU name for the Azure Firewall. Use 'AZFW_VNet' for VNet SKU."
  type        = string
  default     = "AZFW_VNet"
}

variable "subnet_name" {
  description = "The name of the subnet for the Azure Firewall"
  type        = string
  default     = "firewall-subnet"
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for the Azure Firewall subnet"
  type        = string
  default     = "10.0.13.0/24"
}

variable "pip_allocation_method" {
  description = "Allocation method for the public IP (Static or Dynamic)"
  type        = string
  default     = "Static"
}

variable "pip_sku" {
  description = "SKU for the public IP (Standard or Basic)"
  type        = string
  default     = "Standard"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "use_public_ip" {
  description = "Boolean to determine if a public IP should be created and attached to the Azure Firewall"
  type        = bool
  default     = true
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration for the Azure Firewall"
  type        = string # Optional: Set a default value if applicable
}

variable "public_ip_enabled" {
  description = "Boolean to determine if a public IP should be enabled for the Azure Firewall"
  type        = bool # Optional: Set a default value if applicable
}

variable "insert_nsg" {
  description = "Boolean to determine if a Network Security Group (NSG) should be created"
  type        = bool
  default     = false # Added to support NSG creation
}

variable "subnets" {
  description = "Map of subnets with their names and IDs"
  type        = map(string)
}

variable "network_security_group_id" {
  description = "ID of the Network Security Group to associate with subnets"
  type        = string
}