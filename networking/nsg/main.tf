# Terraform block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use a stable version of the AzureRM provider
    }
  }

  required_version = ">= 1.3.0" # Specify a stable Terraform version
}

# Define the provider
provider "azurerm" {
  features {}
}

# Resource group (replace with your actual resource group)
resource "azurerm_resource_group" "network_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Network Security Group
resource "azurerm_network_security_group" "main-nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  tags = var.tags
}

# NSG Rules
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
  resource_group_name         = azurerm_resource_group.example.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "Allow-HTTP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
  resource_group_name         = azurerm_resource_group.example.name
}

resource "azurerm_network_security_rule" "allow_https" {
  name                        = "Allow-HTTPS"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
  resource_group_name         = azurerm_resource_group.example.name
}