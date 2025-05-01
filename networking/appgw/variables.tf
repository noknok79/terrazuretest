variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "backend_address_pool_name" {
  description = "Name of the backend address pool for the Application Gateway."
}

variable "frontend_port_name" {
  description = "Name of the frontend port for the Application Gateway."
}

variable "frontend_ip_configuration_name" {
  description = "Name of the frontend IP configuration for the Application Gateway."
}

variable "http_setting_name" {
  description = "Name of the HTTP settings for the Application Gateway."
}

variable "listener_name" {
  description = "Name of the HTTP listener for the Application Gateway."
}

variable "request_routing_rule_name" {
  description = "Name of the request routing rule for the Application Gateway."
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "frontend_subnet_name" {
  description = "Name of the frontend subnet"
  type        = string
}

variable "backend_subnet_name" {
  description = "Name of the backend subnet"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the public IP"
  type        = string
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}

variable "app_gateway_name" {
  description = "Name of the application gateway"
  type        = string
}

variable "vm_admin_username" {
  description = "Admin username for the backend virtual machines."
}

variable "vm_admin_password" {
  description = "Admin password for the backend virtual machines."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the backend virtual machines."
}

variable "use_public_ip" {
  description = "Set to true to use a public IP for the Application Gateway"
  type        = bool
}


variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "sku_name" {
  description = "SKU name for the Application Gateway."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Application Gateway."
}

variable "capacity" {
  type        = number
  description = "Capacity of the Application Gateway."
}

variable "tier" {
  type        = string
  description = "Tier of the Application Gateway."
}

variable "ssl_certificate_name" {
  type        = string
  description = "SSL certificate name for the Application Gateway."
}