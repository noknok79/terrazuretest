# Output for Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group where the SQL Server and Database are deployed."
  value       = azurerm_resource_group.rg_sql.name
}

# Output for SQL Server Name
output "sql_server_name" {
  description = "The name of the Azure SQL Server."
  value       = azurerm_mssql_server.sql_server.name
}

# Output for SQL Server Fully Qualified Domain Name (FQDN)
output "sql_server_fqdn" {
  description = "The fully qualified domain name of the Azure SQL Server."
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

# Output for SQL Database Names
output "sql_database_names" {
  description = "The names of the Azure SQL Databases."
  value       = [for db in azurerm_mssql_database.sql_db : db.name]
}

# Output for SQL Firewall Rule Name
output "sql_firewall_rule_name" {
  description = "The name of the SQL Server firewall rule."
  value       = azurerm_mssql_firewall_rule.sql_firewall.name
}

# Output for SQL Firewall Rule Start IP
output "sql_firewall_start_ip" {
  description = "The start IP address of the SQL Server firewall rule."
  value       = azurerm_mssql_firewall_rule.sql_firewall.start_ip_address
}

# Output for SQL Firewall Rule End IP
output "sql_firewall_end_ip" {
  description = "The end IP address of the SQL Server firewall rule."
  value       = azurerm_mssql_firewall_rule.sql_firewall.end_ip_address
}

# Output for Log Analytics Workspace ID
output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace associated with the SQL Server."
  value       = var.log_analytics_workspace_id
}

output "primary_access_key" {
  value = azurerm_storage_account.sql_storage.primary_access_key
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.sql_storage.primary_blob_endpoint
}
