terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "load_balancer_rg" {
  name     = "rg-load-balancer"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "load_balancer_vnet" {
  name                = "vnet-load-balancer"
  location            = azurerm_resource_group.load_balancer_rg.location
  resource_group_name = azurerm_resource_group.load_balancer_rg.name
  address_space       = ["10.1.0.0/16"]
}

# Network Security Group for the Load Balancer Subnet
resource "azurerm_network_security_group" "load_balancer_nsg" {
  name                = "nsg-load-balancer"
  location            = azurerm_resource_group.load_balancer_rg.location
  resource_group_name = azurerm_resource_group.load_balancer_rg.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.1.0.0/16" # Restrict to internal traffic or trusted IP range
    destination_address_prefix = "*"
  }
}

# Subnet for Load Balancer
resource "azurerm_subnet" "load_balancer_subnet" {
  name                      = "subnet-load-balancer"
  resource_group_name       = azurerm_resource_group.load_balancer_rg.name
  virtual_network_name      = azurerm_virtual_network.load_balancer_vnet.name
  address_prefixes          = ["10.1.1.0/24"]
  network_security_group_id = azurerm_network_security_group.load_balancer_nsg.id
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "load_balancer_pip" {
  name                = "pip-load-balancer"
  location            = azurerm_resource_group.load_balancer_rg.location
  resource_group_name = azurerm_resource_group.load_balancer_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = "load-balancer"
  location            = azurerm_resource_group.load_balancer_rg.location
  resource_group_name = azurerm_resource_group.load_balancer_rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "load-balancer-frontend-ip"
    public_ip_address_id = azurerm_public_ip.load_balancer_pip.id
  }

  depends_on = [
    azurerm_subnet.load_balancer_subnet,
    azurerm_public_ip.load_balancer_pip
  ]
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "load_balancer_backend_pool" {
  name                = "backend-pool"
  loadbalancer_id     = azurerm_lb.load_balancer.id
}

# Health Probe
resource "azurerm_lb_probe" "load_balancer_health_probe" {
  name                = "health-probe"
  resource_group_name = azurerm_resource_group.load_balancer_rg.name
  loadbalancer_id     = azurerm_lb.load_balancer.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancer Rule
resource "azurerm_lb_rule" "load_balancer_rule" {
  name                           = "http-rule"
  resource_group_name            = azurerm_resource_group.load_balancer_rg.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "load-balancer-frontend-ip"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.load_balancer_backend_pool.id
  probe_id                       = azurerm_lb_probe.load_balancer_health_probe.id
}
