# Variables
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the load balancer"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network for the load balancer"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet for the load balancer"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for the load balancer subnet"
  type        = list(string)
}

variable "nsg_name" {
  description = "Name of the network security group for the load balancer subnet"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the public IP for the load balancer"
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "backend_pool_name" {
  description = "Name of the backend address pool for the load balancer"
  type        = string
}

variable "health_probe_name" {
  description = "Name of the health probe for the load balancer"
  type        = string
}

variable "lb_rule_name" {
  description = "Name of the load balancer rule"
  type        = string
}

variable "frontend_ip_configs" {
  description = "List of frontend IP configurations for the load balancer"
  type = list(object({
    name                  = string
    private_ip_address    = string
    private_ip_allocation = string
  }))
}
