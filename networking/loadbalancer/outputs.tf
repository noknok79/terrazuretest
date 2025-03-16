
# Outputs
output "load_balancer_id" {
  value = azurerm_lb.load_balancer.id
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.load_balancer_pip.ip_address
}