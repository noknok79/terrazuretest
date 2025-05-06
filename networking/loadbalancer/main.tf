terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Resource Group
resource "azurerm_resource_group" "load_balancer_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "load_balancer_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  depends_on = [azurerm_resource_group.load_balancer_rg]
}

# Network Security Group for the Load Balancer Subnet
resource "azurerm_network_security_group" "load_balancer_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.load_balancer_rg]
}

# Subnet for Load Balancer
resource "azurerm_subnet" "load_balancer_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefix

  depends_on = [azurerm_virtual_network.load_balancer_vnet]
}

resource "azurerm_subnet_network_security_group_association" "load_balancer_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.load_balancer_subnet.id
  network_security_group_id = azurerm_network_security_group.load_balancer_nsg.id

  depends_on = [
    azurerm_subnet.load_balancer_subnet,
    azurerm_network_security_group.load_balancer_nsg
  ]
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "load_balancer_pip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [azurerm_resource_group.load_balancer_rg]
}

# Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "load-balancer-frontend-ip" # Ensure this matches references
    public_ip_address_id = azurerm_public_ip.load_balancer_pip.id
  }

  depends_on = [
    azurerm_public_ip.load_balancer_pip,
    azurerm_resource_group.load_balancer_rg
  ]
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "load_balancer_backend_pool" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.load_balancer.id

  depends_on = [azurerm_lb.load_balancer]
}

# Health Probe
resource "azurerm_lb_probe" "load_balancer_health_probe" {
  name                = var.health_probe_name
  loadbalancer_id     = azurerm_lb.load_balancer.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2

  depends_on = [azurerm_lb.load_balancer]
}

# Load Balancer Rule
resource "azurerm_lb_rule" "load_balancer_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "load-balancer-frontend-ip"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.load_balancer_backend_pool.id]
  probe_id                       = azurerm_lb_probe.load_balancer_health_probe.id
  disable_outbound_snat          = true # Required to avoid conflict with outbound rule

  depends_on = [
    azurerm_lb.load_balancer,
    azurerm_lb_backend_address_pool.load_balancer_backend_pool,
    azurerm_lb_probe.load_balancer_health_probe
  ]
}

resource "azurerm_lb_nat_pool" "load_balancer_nat_pool" {
  resource_group_name            = azurerm_resource_group.load_balancer_rg.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "SampleApplicationPool"
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 81
  backend_port                   = 8080
  frontend_ip_configuration_name = "load-balancer-frontend-ip" # Corrected name
  depends_on = [
    azurerm_lb.load_balancer,
    azurerm_lb_backend_address_pool.load_balancer_backend_pool,
    azurerm_public_ip.load_balancer_pip
  ]
}


resource "azurerm_lb_nat_rule" "load_balancer_nat_rule_rdp" {
  resource_group_name            = azurerm_resource_group.load_balancer_rg.name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "load-balancer-frontend-ip" # Corrected name
  depends_on = [
    azurerm_lb.load_balancer,
    azurerm_lb_backend_address_pool.load_balancer_backend_pool,
    azurerm_public_ip.load_balancer_pip
  ]
}

# Outbound Rule
resource "azurerm_lb_outbound_rule" "load_balancer_outbound_rule" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.load_balancer.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.load_balancer_backend_pool.id

  frontend_ip_configuration {
    name = "load-balancer-frontend-ip"
  }

  depends_on = [
    azurerm_lb.load_balancer,
    azurerm_lb_backend_address_pool.load_balancer_backend_pool,
    azurerm_public_ip.load_balancer_pip
  ]
}