keyvault_config = {
  subscription_id           = "096534ab-9b99-4153-8505-90d030aa4f08"
  environment               = "dev"
  location                  = "East US"
  tags                      = { environment = "dev", owner = "team" }
  rg_keyvault               = "rg-keyvault-dev"
  keyvault_name             = "keyvault-dev"
  resource_group_name       = "rg-keyvault-dev"
  keyvault_name_alias       = "keyvault-alias-dev"
  sku_name                  = "standard"
  tenant_id                 = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  enable_rbac_authorization = true
  subnet_id                 = subnet_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
  network_acls = {
    bypass              = "AzureServices"
    default_action      = "Deny"
    ip_rules            = ["192.168.1.0/24", "10.0.0.0/16"]
    virtual_network_ids = ["/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev"]
  }
  access_policies = [
    {
      object_id               = "ac2a3d05-eff3-4e60-baa6-4e15c08ddc4d"
      tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
      key_permissions         = ["Get", "List", "Create"]
      secret_permissions      = ["Get", "List", "Set"]
      certificate_permissions = ["Get", "List"]
    },
    {
      object_id               = "88668631-3d17-4e05-941b-2752e4b7b4f1"
      tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
      key_permissions         = ["Get"]
      secret_permissions      = ["Get"]
      certificate_permissions = ["Get"]
  }]
  key_vault_key_id           = "https://my-keyvault.vault.azure.net/keys/my-key/<key-version>"
  soft_delete_retention_days = 90
  key_name                   = "my-key"
  enable_purge_protection    = true
  enable_soft_delete         = true
  consistency_level          = "Eventual"
}
