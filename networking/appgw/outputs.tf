

# Outputs
output "application_gateway_id" {
  value = azurerm_application_gateway.app_gateway.id
}

output "application_gateway_frontend_ip" {
  value = azurerm_public_ip.app_gateway_pip.ip_address
}