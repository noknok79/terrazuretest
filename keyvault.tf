# Variable group configuration block

variable "keyvault_config" {
  description = "Configuration for Key Vault and related resources"
  type = object({
    subscription_id               = string
    tenant_id                     = string
    resource_group_name           = string
    location                      = string
    environment                   = string
    keyvault_name                 = string
    owner                         = string
    project                       = string
    virtual_network_name          = string
    virtual_network_address_space = list(string)
    subnet_name                   = string
    subnet_address_prefixes       = list(string)
    subnet_service_endpoints      = list(string)
    subnet_id                     = string # Added subnet_id variable

    key_vault_sku_name                      = string
    key_vault_purge_protection_enabled      = bool
    key_vault_public_network_access_enabled = bool
    key_vault_default_action                = string
    key_vault_bypass                        = string
    ip_rules                                = list(string)
    access_policies = map(object({
      tenant_id               = string
      object_id               = string
      secret_permissions      = list(string)
      key_permissions         = list(string)
      certificate_permissions = list(string)
    }))
    network_acls_virtual_network_ids = list(string)
    tags                             = map(string)
    sku_name                         = string
    cost_center                      = string
  })
  default = {
    subscription_id               = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id                     = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    resource_group_name           = "RG-KEYVAULT"
    location                      = "East US"
    environment                   = "dev"
    keyvault_name                 = "keyvault-dev-eastust"
    owner                         = "John Doe"
    project                       = "my-project"
    virtual_network_name          = "vnet-keyvault"
    virtual_network_address_space = ["10.0.0.0/16"]
    subnet_name                   = "subnet-keyvault"
    subnet_address_prefixes       = ["10.0.1.0/24"]
    subnet_service_endpoints      = ["Microsoft.KeyVault"]
    subnet_id                     = "subnet-id-placeholder" # Default value for subnet_id

    key_vault_sku_name                      = "standard"
    key_vault_purge_protection_enabled      = true
    key_vault_public_network_access_enabled = false
    key_vault_default_action                = "Deny"
    key_vault_bypass                        = "AzureServices"
    ip_rules                                = ["136.158.30.104", "136.158.30.105"]
    access_policies = {
      admin_policy = {
        tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
        object_id               = "ac2a3d05-eff3-4e60-baa6-4e15c08ddc4d"
        secret_permissions      = ["Get", "List"]
        key_permissions         = ["Get", "List"]
        certificate_permissions = ["Get", "List"]
      }
    }
    network_acls_virtual_network_ids = []
    tags = {
      environment = "dev"
      owner       = "default_owner"
      project     = "default_project"
    }
    sku_name    = "standard"
    cost_center = "IT-001"
  }
}


# Outputs for Key Vault
output "keyvault_id" {
  description = "The ID of the Key Vault"
  value       = module.keyvault.keyvault_id
}

output "keyvault_name" {
  description = "The name of the Key Vault"
  value       = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  description = "The URI of the Key Vault"
  value       = module.keyvault.keyvault_uri
}
