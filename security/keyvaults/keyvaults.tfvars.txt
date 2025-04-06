subscription_id           = "096534ab-9b99-4153-8505-90d030aa4f08"
environment               = "dev"
location                  = "East US"
tags                      = { environment = "dev", owner = "team" }
rg_keyvault               = "rg-keyvault-dev"
keyvault_name             = "keyvault-dev"
resource_group_name       = "rg-keyvault-dev"
keyvault_name_alias       = "keyvault-alias-dev"
sku_name                  = "standard"
tenant_id                 = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
enable_rbac_authorization = true
subnet_id                 = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-keyvault-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/subnet-keyvault-dev"

network_acls_bypass        = "AzureServices"
network_acls_default_action = "Deny"
#network_acls_ip_rules       = ["192.168.1.0/24", "10.0.0.0/16"]
network_acls_ip_rules = ["136.158.0.0/24"] # Replace with valid public IP ranges
access_policies = [
  {
    object_id               = "394166a3-9a96-4db9-94b7-c970f2c97b27"
    tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set"]
    certificate_permissions = ["Get", "List"]
  },
  {
    object_id               = "394166a3-9a96-4db9-94b7-c970f2c97b27"
    tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    key_permissions         = ["Get"]
    secret_permissions      = ["Get"]
    certificate_permissions = ["Get"]
  }
]

access_policies_object_ids = ["394166a3-9a96-4db9-94b7-c970f2c97b27", "ac2a3d05-eff3-4e60-baa6-4e15c08ddc4d"]
access_policies_tenant_ids = ["0e4b57cd-89d9-4dac-853b-200a412f9d3c"]

soft_delete_retention_days = 90
enable_purge_protection    = true
enable_soft_delete         = true
key_name                   = "my-key"
consistency_level          = "Eventual"