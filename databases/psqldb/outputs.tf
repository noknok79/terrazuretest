# Outputs
output "psql_server_name" {
  description = "The name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.psql_server.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_subnets" {
  value = var.vnet_subnets
}