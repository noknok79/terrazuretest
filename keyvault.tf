variable "keyvault_config" {
  description = "Configuration for the Azure Key Vault"
  type = object({
    resource_group_name = string
    keyvault_name       = string
    key_name            = string
    tenant_id           = string
    object_id           = string
    access_policies     = list(object({
      tenant_id               = string
      object_id               = string
      key_permissions         = list(string)
      secret_permissions      = list(string)
      certificate_permissions = list(string)
    }))
    location            = string
    enable_purge_protection = bool
    enable_rbac_authorization = bool
    network_acls_bypass = string
    access_policies_object_ids = list(string)
    access_policies_tenant_ids = list(string)
    consistency_level   = string
    subnet_id           = string
    soft_delete_retention_days = number
    owner               = string
    keyvault_name_alias = string
    sku_name            = string
    network_acls_default_action = string
    network_acls_ip_rules = list(string)
    network_acls_virtual_network_ids = list(string)
    key_vault_key_id    = string
    enable_soft_delete  = bool
    tags                = map(string)
    environment         = string
    project             = string
  })
  default = {
    resource_group_name = "RG-KEYVAULT"
    keyvault_name       = "keyvault-dev-eastus"
    key_name            = "keyvault-key-dev-eastus"
    tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    object_id           = "394166a3-9a96-4db9-94b7-c970f2c97b27"

    access_policies     = [
      {
        tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
        object_id               = "394166a3-9a96-4db9-94b7-c970f2c97b27"
        key_permissions         = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Recover", "Backup", "Restore", "Getrotationpolicy", "Setrotationpolicy",
    "Rotate"]
        secret_permissions      = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
        certificate_permissions = [
    "Get", "List", "Create", "Delete", "Import", "Update", "ManageContacts", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "ManageIssuers", "Recover", "Backup", "Restore"
  ]
      }
    ]
    location            = "East US"
    enable_purge_protection = true
    enable_rbac_authorization = true
    network_acls_bypass = "AzureServices"
    access_policies_object_ids = []
    access_policies_tenant_ids = []
    consistency_level   = ""
    subnet_id           = ""
    soft_delete_retention_days = 90
    owner               = "John Doe"
    keyvault_name_alias = ""
    sku_name            = "standard"
    network_acls_default_action = "Deny"
    network_acls_ip_rules = ["136.158.57.203", "136.158.57.204"]
    network_acls_virtual_network_ids = []
    key_vault_key_id    = ""
    enable_soft_delete  = true
    tags                = {
      Environment = "dev"
      Owner       = "John Doe"
      ManagedBy   = "Terraform"
    }
    environment         = "dev"
    project             = "my-project"
  }
}

