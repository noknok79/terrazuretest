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
resource "azurerm_resource_group" "app_gateway_rg" {
  name     = "rg-app-gateway"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "app_gateway_vnet" {
  name                = "vnet-app-gateway"
  location            = azurerm_resource_group.app_gateway_rg.location
  resource_group_name = azurerm_resource_group.app_gateway_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for Application Gateway
resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "subnet-app-gateway"
  resource_group_name  = azurerm_resource_group.app_gateway_rg.name
  virtual_network_name = azurerm_virtual_network.app_gateway_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for Application Gateway
resource "azurerm_public_ip" "app_gateway_pip" {
  name                = "pip-app-gateway"
  location            = azurerm_resource_group.app_gateway_rg.location
  resource_group_name = azurerm_resource_group.app_gateway_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Application Gateway
resource "azurerm_application_gateway" "app_gateway" {
  name                = "app-gateway"
  location            = azurerm_resource_group.app_gateway_rg.location
  resource_group_name = azurerm_resource_group.app_gateway_rg.name
  sku {
    name     = "WAF_v2" # Best practice: Use WAF_v2 for enhanced security
    tier     = "WAF_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "app-gateway-ip-config"
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }
  frontend_ip_configuration {
    name                 = "app-gateway-frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway_pip.id
  }
  frontend_port {
    name = "http-port"
    port = 80
  }
  frontend_port {
    name = "https-port"
    port = 443
  }
  backend_address_pool {
    name = "app-gateway-backend-pool"
  }
  http_listener {
    name                           = "app-gateway-http-listener"
    frontend_ip_configuration_name = "app-gateway-frontend-ip"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "app-gateway-ssl-cert" # Replace with your SSL certificate name
  }
  ssl_certificate {
    name     = "app-gateway-ssl-cert"
    data     = filebase64("${path.module}/cert.pfx") # Replace with your certificate file
    password = var.ssl_certificate_password
  }
  request_routing_rule {
    name                       = "app-gateway-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "app-gateway-http-listener"
    backend_address_pool_name  = "app-gateway-backend-pool"
    backend_http_settings_name = "app-gateway-http-settings"
  }
  backend_http_settings {
    name                  = "app-gateway-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }
  depends_on = [
    azurerm_subnet.app_gateway_subnet,
    azurerm_public_ip.app_gateway_pip
  ]
}

