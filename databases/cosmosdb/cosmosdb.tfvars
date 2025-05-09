subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
resource_group_name = "RG-COSMOSDB"
#location            = "East US"
location = "Central US"

admin_object_id                          = "ac2a3d05-eff3-4e60-baa6-4e15c08ddc4d"
keyvault_secret_value                    = ">ha.16mGCKKj/RL5Oj(I%T,Bc49}S'"
sku_name                                 = "standard"
enable_rbac_authorization                = true
soft_delete_retention_days               = 90
enable_purge_protection                  = true
public_network_access_enabled            = true
keyvault_name                            = "keyvault-dev-eastust"
key_name                                 = "key-dev-eastust"
virtual_network_name                     = "vnet-keyvault"
vnet_address_space                       = ["10.0.0.0/16"]
subnet_address_prefixes                  = ["10.0.1.0/24"]
subnet_service_endpoints                 = ["Microsoft.KeyVault"]
private_endpoint_subnet_address_prefixes = ["10.0.2.0/24"]
private_endpoint_service_endpoints       = ["Microsoft.Storage"]
subnet_id                                = ""
storage_account_id                       = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-STORAGE/providers/Microsoft.Storage/storageAccounts/mystorageaccount"

log_analytics_workspace_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-LOG/providers/Microsoft.OperationalInsights/workspaces/my-log-analytics"

access_policies = {
  policy1 = {
    tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    object_id               = "ac2a3d05-eff3-4e60-baa6-4e15c08ddc4d"
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
  }
}

tags = {
  environment = "dev"
  owner       = "default_owner"
  project     = "default_project"
}

environment = "dev"
owner       = "John Doe"
cost_center = "IT-001"
project     = "my-project"
client_ip   = "136.158.30.104"

network_acls_bypass              = "AzureServices"
network_acls_default_action      = "Deny"
network_acls_ip_rules            = ["136.158.30.104", "136.158.30.105"]
network_acls_virtual_network_ids = []

ip_rules                   = ["136.158.30.104", "136.158.30.105"]
virtual_network_subnet_ids = [""]

virtual_network_address_space           = ["10.0.0.0/16"]
subnet_name                             = "keyvault-subnet"
key_vault_sku_name                      = "standard"
key_vault_purge_protection_enabled      = true
key_vault_public_network_access_enabled = false
key_vault_default_action                = "Deny"
key_vault_bypass                        = "AzureServices"

consistency_level                 = "BoundedStaleness"
enable_automatic_failover         = true
enable_multiple_write_locations   = true
is_virtual_network_filter_enabled = true
cosmosdb_sql_database_name        = "my-cosmosdb-sql-database"
cosmosdb_sql_container_name       = "my-cosmosdb-sql-container"
cosmosdb_partition_key_path       = "/partitionKey"