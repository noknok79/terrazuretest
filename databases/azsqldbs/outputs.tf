# Output for Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group where the SQL Server and Database are deployed."
  value       = azurerm_resource_group.rg_sql.name
}

# Output for SQL Server Name
output "sql_server_name" {
  description = "The name of the Azure SQL Server."
  value       = azurerm_sql_server.sql_server.name
}

# Output for SQL Server Fully Qualified Domain Name (FQDN)
output "sql_server_fqdn" {
  description = "The fully qualified domain name of the Azure SQL Server."
  value       = azurerm_sql_server.sql_server.fully_qualified_domain_name
}

# Output for SQL Database Name
output "sql_database_name" {
  description = "The name of the Azure SQL Database."
  value       = azurerm_sql_database.sql_db.name
}

# Output for SQL Firewall Rule Name
output "sql_firewall_rule_name" {
  description = "The name of the SQL Server firewall rule."
  value       = azurerm_sql_firewall_rule.sql_firewall.name
}

# Output for SQL Firewall Rule Start IP
output "sql_firewall_start_ip" {
  description = "The start IP address of the SQL Server firewall rule."
  value       = azurerm_sql_firewall_rule.sql_firewall.start_ip_address
}

# Output for SQL Firewall Rule End IP
output "sql_firewall_end_ip" {
  description = "The end IP address of the SQL Server firewall rule."
  value       = azurerm_sql_firewall_rule.sql_firewall.end_ip_address
}