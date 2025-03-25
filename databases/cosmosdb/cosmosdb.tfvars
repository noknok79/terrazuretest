subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
environment     = "dev"
location        = "East US"
tags = {
  environment = "dev"
  owner       = "team"
  project     = "keyvault-project"
}
rg_keyvault               = "rg-keyvault-dev"
keyvault_name             = "keyvault-dev"
sku_name                  = "standard"
tenant_id                 = "72f988bf-86f1-41af-91ab-2d7cd011db47"
enable_rbac_authorization = true
access_policies = [
  {
    tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    object_id = "00000000-0000-0000-0000-000000000000"
    permissions = {
      keys         = ["get", "list", "create", "delete"]
      secrets      = ["get", "list", "set", "delete"]
      certificates = ["get", "list", "create", "delete"]
    }
  }
]
subnet_id                  = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/subnet-dev"
owner                      = "team"
enable_soft_delete         = true
soft_delete_retention_days = 90
enable_purge_protection    = true
network_acls = {
  bypass              = "AzureServices"
  default_action      = "Deny"
  ip_rules            = ["192.168.1.0/24", "10.0.0.0/16"]
  virtual_network_ids = ["/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev"]
}
