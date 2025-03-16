output "public_ip_name" {
  description = "The name of the Public IP resource"
  value       = azurerm_public_ip.example.name
}

output "public_ip_address" {
  description = "The allocated Public IP address"
  value       = azurerm_public_ip.example.ip_address
}

output "public_ip_id" {
  description = "The ID of the Public IP resource"
  value       = azurerm_public_ip.example.id
}

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.example.name
}

output "resource_group_location" {
  description = "The location of the Resource Group"
  value       = azurerm_resource_group.example.location
}