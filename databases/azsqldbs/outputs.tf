# Output for Resource Group Name
output "resource_group_name" {
  description = "The name of the resource group where the SQL Server and Database are deployed."
  value       = azurerm_resource_group.rg_sql.name
}

# Output for SQL Server Name
output "sql_server_name" {
  description = "The name of the Azure SQL Server"
  value       = azurerm_mssql_server.sql_server.name
}

# Output for SQL Server Fully Qualified Domain Name (FQDN)
output "sql_server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the Azure SQL Server"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

# Output for SQL Database Names
output "sql_database_names" {
  description = "The names of the Azure SQL Databases"
  value       = [for db in azurerm_mssql_database.sql_db : db.name]
}

# Output for SQL Database IDs
output "sql_database_ids" {
  description = "The IDs of the Azure SQL Databases"
  value       = [for db in azurerm_mssql_database.sql_db : db.id]
}

# Output for SQL Private Endpoint ID
output "sql_private_endpoint_id" {
  description = "The ID of the private endpoint for the Azure SQL Server"
  value       = azurerm_private_endpoint.sql_private_endpoint.id
}

# Output for SQL Private Endpoint IP
output "sql_private_endpoint_ip" {
  description = "The private IP address of the private endpoint for the Azure SQL Server"
  value       = azurerm_private_endpoint.sql_private_endpoint.private_service_connection[0].private_ip_address
}

# Output for SQL Server Admin Username
output "sql_server_admin_username" {
  description = "The administrator username for the Azure SQL Server"
  value       = var.sql_server_admin_username
}

# Output for SQL Server Firewall Rules
output "sql_server_firewall_rules" {
  description = "Details of the SQL Server firewall rules"
  value = [
    for rule in [
      azurerm_mssql_firewall_rule.sql_firewall,
      azurerm_mssql_firewall_rule.deny_azure_services,
      azurerm_mssql_firewall_rule.sql_firewall_rule
      ] : {
      name     = rule.name
      start_ip = rule.start_ip_address
      end_ip   = rule.end_ip_address
    }
  ]
}

# Output for SQL Server Security Alert Policy State
output "sql_server_security_alert_policy_state" {
  description = "The state of the security alert policy for the Azure SQL Server"
  value       = azurerm_mssql_server_security_alert_policy.sql_security_alert_policy.state
}

# Output for SQL Server Vulnerability Assessment Storage Container Path
output "sql_server_vulnerability_assessment_storage_container_path" {
  description = "The storage container path for the vulnerability assessment of the Azure SQL Server"
  value       = azurerm_mssql_server_vulnerability_assessment.sql_va.storage_container_path
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
  value     = azurerm_storage_account.sql_storage.primary_access_key
  sensitive = true
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.sql_storage.primary_blob_endpoint
}

output "storage_account_name" {
  value = azurerm_storage_account.sql_storage.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "subnet_name" {
  description = "The name of the subnet used by the Azure SQL Server"
  value       = var.subnet_name
}