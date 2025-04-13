
# Outputs
output "psql_server_name" {
  description = "The name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.psql_server.name
}

