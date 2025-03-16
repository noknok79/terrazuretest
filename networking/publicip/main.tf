# Define the provider
provider "azurerm" {
  features {}
}

# Define variables for reusability and flexibility
variable "resource_group_name" {
  description = "The name of the resource group where the public IP will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the public IP will be created"
  type        = string
  default     = "East US"
}

variable "public_ip_name" {
  description = "The name of the public IP resource"
  type        = string
}

variable "allocation_method" {
  description = "The allocation method for the public IP (Static or Dynamic)"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the public IP (Basic or Standard)"
  type        = string
  default     = "Standard"
}

# Create the public IP resource
resource "azurerm_public_ip" "example" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.sku

  tags = {
    environment = "production"
  }
}

# Output the public IP address
