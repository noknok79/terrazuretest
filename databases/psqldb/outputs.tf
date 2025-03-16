
# Outputs
output "psql_server_name" {
  description = "The name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.psql_server.name
}

output "psql_database_name" {
  description = "The name of the PostgreSQL database"
  value       = azurerm_postgresql_flexible_database.psql_db.name
}