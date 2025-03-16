# The name of the resource group where the public IP will be created
variable "resource_group_name" {
  description = "The name of the resource group where the public IP will be created"
  type        = string
}

# The Azure region where the public IP will be created
variable "location" {
  description = "The Azure region where the public IP will be created"
  type        = string
  default     = "East US"
}

# The name of the public IP resource
variable "public_ip_name" {
  description = "The name of the public IP resource"
  type        = string
}

# The allocation method for the public IP (Static or Dynamic)
variable "allocation_method" {
  description = "The allocation method for the public IP (Static or Dynamic)"
  type        = string
  default     = "Static"
}

# The SKU of the public IP (Basic or Standard)
variable "sku" {
  description = "The SKU of the public IP (Basic or Standard)"
  type        = string
  default     = "Standard"
}