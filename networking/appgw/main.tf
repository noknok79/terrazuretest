# Define the provider
provider "azurerm" {
  features {}
}

# Define resource group
resource "azurerm_resource_group" "appgw_rg" {
  name     = "rg-appgw"
  location = "East US"
}

# Define virtual network
resource "azurerm_virtual_network" "appgw_vnet" {
  name                = "vnet-appgw"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.appgw_rg.location
  resource_group_name = azurerm_resource_group.appgw_rg.name
}

# Define subnet for Application Gateway
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "subnet-appgw"
  resource_group_name  = azurerm_resource_group.appgw_rg.name
  virtual_network_name = azurerm_virtual_network.appgw_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define public IP for Application Gateway
resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "pip-appgw"
  location            = azurerm_resource_group.appgw_rg.location
  resource_group_name = azurerm_resource_group.appgw_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Define Application Gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  location            = azurerm_resource_group.appgw_rg.location
  resource_group_name = azurerm_resource_group.appgw_rg.name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  backend_address_pool {
    name = "appgw-backend-pool"
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "appgw-backend-pool"
    backend_http_settings_name = "appgw-http-settings"
  }

  backend_http_settings {
    name                  = "appgw-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  tags = {
    environment = "production"
  }
}