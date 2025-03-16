# Output the Resource Group name
output "resource_group_name" {
  description = "The name of the Resource Group hosting the Cosmos DB resources"
  value       = azurerm_resource_group.rg.name
}

# Output the Cosmos DB Account name
output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.name
}

# Output the Cosmos DB Account endpoint
output "cosmosdb_account_endpoint" {
  description = "The endpoint of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}

# Output the Cosmos DB SQL Database name
output "cosmosdb_sql_database_name" {
  description = "The name of the Cosmos DB SQL Database"
  value       = azurerm_cosmosdb_sql_database.database.name
}

# Output the Cosmos DB SQL Container name
output "cosmosdb_sql_container_name" {
  description = "The name of the Cosmos DB SQL Container"
  value       = azurerm_cosmosdb_sql_container.container.name
}

# Output the Cosmos DB SQL Container partition key path
output "cosmosdb_sql_container_partition_key_path" {
  description = "The partition key path of the Cosmos DB SQL Container"
  value       = azurerm_cosmosdb_sql_container.container.partition_key_path
}