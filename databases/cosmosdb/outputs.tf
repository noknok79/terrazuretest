# Output the Resource Group name
output "resource_group_name" {
  description = "The name of the Resource Group hosting the Cosmos DB resources"
  value       = var.resource_group_name
}

# Output the Cosmos DB Account name
output "account_name" {
  description = "The name of the Cosmos DB Account"
  value       = var.account_name
}

# Output the Cosmos DB Account location
output "location" {
  description = "The location of the Cosmos DB Account"
  value       = var.location
}

# Output the Cosmos DB Account consistency level
output "consistency_level" {
  description = "The consistency level of the Cosmos DB Account"
  value       = var.consistency_level
}

# Output the Cosmos DB Account throughput
output "throughput" {
  description = "The throughput of the Cosmos DB Account"
  value       = var.throughput
}

# Output the subscription ID
output "subscription_id" {
  description = "The subscription ID for the Cosmos DB Account"
  value       = var.subscription_id
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

# Output the Cosmos DB SQL Container partition key paths
output "cosmosdb_sql_container_partition_key_paths" {
  description = "The partition key paths of the Cosmos DB SQL Container"
  value       = azurerm_cosmosdb_sql_container.container.partition_key_paths
}
