# The name of the resource group where the Load Balancer will be created
variable "resource_group_name" {
  description = "The name of the resource group where the Load Balancer will be created"
  type        = string
}

# The Azure region where the Load Balancer will be created
variable "location" {
  description = "The Azure region where the Load Balancer will be created"
  type        = string
  default     = "East US"
}

# The name of the Load Balancer
variable "load_balancer_name" {
  description = "The name of the Load Balancer"
  type        = string
}

# The SKU of the Load Balancer (Basic or Standard)
variable "sku" {
  description = "The SKU of the Load Balancer (Basic or Standard)"
  type        = string
  default     = "Standard"
}

# The ID of the public IP to associate with the Load Balancer
variable "public_ip_id" {
  description = "The ID of the public IP to associate with the Load Balancer"
  type        = string
}