# Output the Load Balancer ID
output "load_balancer_id" {
  description = "The ID of the Load Balancer"
  value       = azurerm_lb.example.id
}

# Output the Backend Address Pool ID
output "backend_address_pool_id" {
  description = "The ID of the Backend Address Pool"
  value       = azurerm_lb_backend_address_pool.example.id
}

# Output the Load Balancer Probe ID
output "load_balancer_probe_id" {
  description = "The ID of the Load Balancer Probe"
  value       = azurerm_lb_probe.example.id
}

# Output the Load Balancer Rule ID
output "load_balancer_rule_id" {
  description = "The ID of the Load Balancer Rule"
  value       = azurerm_lb_rule.example.id
}