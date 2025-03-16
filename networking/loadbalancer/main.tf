# Define the provider
provider "azurerm" {
  features {}
}

# Create the Load Balancer
resource "azurerm_lb" "example" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = var.public_ip_id
  }

  tags = {
    environment = "production"
  }
}

# Create a Backend Address Pool
resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "backend-pool"
}

# Create a Load Balancer Probe
resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# Create a Load Balancer Rule
resource "azurerm_lb_rule" "example" {
  loadbalancer_id            = azurerm_lb.example.id
  name                       = "http-rule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  probe_id                       = azurerm_lb_probe.example.id
}

# Output the Load Balancer details
output "load_balancer_id" {
  description = "The ID of the Load Balancer"
  value       = azurerm_lb.example.id
}