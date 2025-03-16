output "public_ip_address" {
  description = "The public IP address"
  value       = azurerm_public_ip.example.ip_address
}

