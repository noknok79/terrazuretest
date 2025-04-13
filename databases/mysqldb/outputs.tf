output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.rg.location
}

output "mysql_server_name" {
  description = "The name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql_server.name
}

output "mysql_server_fqdn" {
  description = "The fully qualified domain name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql_server.fqdn
}

output "mysql_server_administrator_login" {
  description = "The administrator login name for the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql_server.administrator_login
}

output "mysql_database_name" {
  description = "The name of the MySQL Flexible Database"
  value       = azurerm_mysql_flexible_database.mysql_db.name
}

