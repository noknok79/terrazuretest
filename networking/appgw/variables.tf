# Variable for Resource Group
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

# Variable for Virtual Network
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the virtual network."
  type        = list(string)
}

# Variable for Subnet
variable "subnet_name" {
  description = "The name of the subnet for the Application Gateway."
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
}

# Variable for Public IP
variable "public_ip_name" {
  description = "The name of the public IP for the Application Gateway."
  type        = string
}

variable "public_ip_allocation_method" {
  description = "The allocation method for the public IP."
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "The SKU of the public IP."
  type        = string
  default     = "Standard"
}

# Variable for Application Gateway
variable "appgw_name" {
  description = "The name of the Application Gateway."
  type        = string
}

variable "appgw_sku_name" {
  description = "The SKU name for the Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "appgw_sku_tier" {
  description = "The SKU tier for the Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "appgw_capacity" {
  description = "The capacity of the Application Gateway."
  type        = number
  default     = 2
}

variable "appgw_tags" {
  description = "Tags for the Application Gateway."
  type        = map(string)
  default     = {
    environment = "production"
  }
}