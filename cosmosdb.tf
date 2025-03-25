# This Terraform configuration defines resources for a CosmosDB instance.
# These resources have been set in the cosmosdb.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="databases/cosmosdb/cosmosdb.tfvars" --out="cosmosdb.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="databases/cosmosdb/cosmosdb.tfvars" --input=false
# #2 terraform destroy -var-file="databases/cosmosdb/cosmosdb.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>


# terraform {
#   required_version = ">= 1.4.6"
# }


# module "cosmosdb" {
#   source              = "./databases/cosmosdb"
#   environment         = var.cosmosdb_config.general.environment
#   location            = var.cosmosdb_config.general.location
#   key_vault_key_id    = var.cosmosdb_config.database.key_vault_key_id
#   subnet_id           = var.cosmosdb_config.database.subnet_id
#   resource_group_name = var.cosmosdb_config.general.resource_group_name
#   throughput          = var.cosmosdb_config.database.throughput
#   subscription_id     = var.cosmosdb_config.general.subscription_id
#   tags                = var.cosmosdb_config.general.tags
#   account_name        = var.cosmosdb_config.database.account_name
#   consistency_level   = var.cosmosdb_config.database.consistency_level

# }


# variable "cosmosdb_config" {
#   description = "Consolidated configuration for the CosmosDB module"
#   type = object({
#     general = object({
#       subscription_id     = string
#       environment         = string
#       location            = string
#       tags                = map(string)
#       resource_group_name = string
#     })
#     database = object({
#       account_name      = string
#       throughput        = number
#       key_vault_key_id  = string
#       subnet_id         = string
#       consistency_level = string # Added consistency_level
#     })
#   })
#   default = {
#     general = {
#       subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
#       environment         = "dev"
#       location            = "East US"
#       tags                = { environment = "dev", owner = "team" }
#       resource_group_name = "rg-database-dev"
#     }
#     database = {
#       account_name      = "cosmosdbaccount"
#       throughput        = 400
#       key_vault_key_id  = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-keyvault-dev/providers/Microsoft.KeyVault/vaults/my-keyvault/keys/my-key"
#       subnet_id         = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/subnet-dev"
#       consistency_level = "Session" # Added default value for consistency_level
#     }
#   }
# }


# output "cosmosdb_config_output" {
#   description = "CosmosDB configuration outputs"
#   value = {
#     account_name        = module.cosmosdb.account_name
#     resource_group_name = var.cosmosdb_config.general.resource_group_name
#     location            = module.cosmosdb.location
#     consistency_level   = module.cosmosdb.consistency_level
#     throughput          = module.cosmosdb.throughput
#     subscription_id     = module.cosmosdb.subscription_id
#   }
# }

