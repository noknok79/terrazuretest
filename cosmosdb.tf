variable "cosmosdb_config" {
  description = "Configuration for Cosmos DB"
  type = object({
    subscription_id                          = string
    tenant_id                                = string
    resource_group_name                      = string
    location                                 = string
    environment                              = string
    owner                                    = string
    project                                  = string
    cost_center                              = string
    client_ip                                = string
    keyvault_name                            = string
    key_name                                 = string
    keyvault_secret_value                    = string
    sku_name                                 = string
    enable_rbac_authorization                = bool
    soft_delete_retention_days               = number
    enable_purge_protection                  = bool
    public_network_access_enabled            = bool
    virtual_network_name                     = string
    virtual_network_address_space            = list(string)
    subnet_name                              = string
    subnet_address_prefixes                  = list(string)
    subnet_service_endpoints                 = list(string)
    private_endpoint_subnet_address_prefixes = list(string)
    private_endpoint_service_endpoints       = list(string)
    subnet_id                                = string
    storage_account_id                       = string
    log_analytics_workspace_id               = string
    access_policies = list(object({
      tenant_id = string
      object_id = string
      permissions = object({
        keys         = list(string)
        secrets      = list(string)
        certificates = list(string)
      })
    }))
    tags                              = map(string)
    network_acls_bypass               = string
    network_acls_default_action       = string
    network_acls_ip_rules             = list(string)
    network_acls_virtual_network_ids  = list(string)
    consistency_level                 = string
    enable_automatic_failover         = bool
    enable_multiple_write_locations   = bool
    is_virtual_network_filter_enabled = bool
    sql_database_name                 = string
    sql_container_name                = string
    partition_key_path                = string
    virtual_network_subnet_ids        = list(string)
    cosmosdb_partition_key_path       = string
  })

  default = {
    subscription_id                          = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id                                = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    resource_group_name                      = "RG-COSMOSDB"
    location                                 = "Central US"
    environment                              = "dev"
    owner                                    = "John Doe"
    project                                  = "my-project"
    cost_center                              = "IT-001"
    client_ip                                = "136.158.30.104"
    keyvault_name                            = "keyvault-dev-eastust"
    key_name                                 = "key-dev-eastust"
    keyvault_secret_value                    = ">ha.16mGCKKj/RL5Oj(I%T,Bc49}S'"
    sku_name                                 = "standard"
    enable_rbac_authorization                = true
    soft_delete_retention_days               = 90
    enable_purge_protection                  = true
    public_network_access_enabled            = true
    virtual_network_name                     = "vnet-keyvault"
    virtual_network_address_space            = ["10.0.0.0/16"]
    subnet_name                              = "keyvault-subnet"
    subnet_address_prefixes                  = ["10.0.1.0/24"]
    subnet_service_endpoints                 = ["Microsoft.KeyVault"]
    private_endpoint_subnet_address_prefixes = ["10.0.2.0/24"]
    private_endpoint_service_endpoints       = ["Microsoft.Storage"]
    subnet_id                                = ""
    storage_account_id                       = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-STORAGE/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
    log_analytics_workspace_id               = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-LOG/providers/Microsoft.OperationalInsights/workspaces/my-log-analytics"
    access_policies = [
      {
        tenant_id = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
        object_id = "ac2a3d05-eff3-4e60-baa6-4e15c08ddc4d"
        permissions = {
          keys         = ["Get", "List"]
          secrets      = ["Get", "List"]
          certificates = ["Get", "List"]
        }
      }
    ]
    tags = {
      environment = "dev"
      owner       = "default_owner"
      project     = "default_project"
    }
    network_acls_bypass               = "AzureServices"
    network_acls_default_action       = "Deny"
    network_acls_ip_rules             = ["136.158.30.104", "136.158.30.105"]
    network_acls_virtual_network_ids  = []
    consistency_level                 = "BoundedStaleness"
    enable_automatic_failover         = true
    enable_multiple_write_locations   = true
    is_virtual_network_filter_enabled = true
    sql_database_name                 = "my-cosmosdb-sql-database"
    sql_container_name                = "my-cosmosdb-sql-container"
    partition_key_path                = "/partitionKey"
    cosmosdb_partition_key_path       = ""
    virtual_network_subnet_ids = [
      "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/vnet-keyvault/subnets/example-subnet"
    ]
  }
}

