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
    admin_object_id               = string # Added admin_object_id variable

    key_vault_sku_name                      = string
    key_vault_purge_protection_enabled      = bool
    key_vault_public_network_access_enabled = bool
    key_vault_default_action                = string
    key_vault_bypass                        = string
    keyvault_secret_value                   = string

    ip_rules = list(string)
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
    location                      = "eastus"
    environment                   = "dev"
    keyvault_name                 = "keyvault-dev-eastust"
    owner                         = "John Doe"
    project                       = "my-project"
    virtual_network_name          = "vnet-keyvault"
    virtual_network_address_space = ["10.0.0.0/16"]
    subnet_name                   = "subnet-keyvault"
    subnet_address_prefixes       = ["10.0.6.0/24"]
    subnet_service_endpoints      = ["Microsoft.KeyVault"]
    subnet_id                     = "subnet-id-placeholder"                # Default value for subnet_id
    admin_object_id               = "394166a3-9a96-4db9-94b7-c970f2c97b27" # Added default value for admin_object_id

    key_vault_sku_name                      = "standard"
    key_vault_purge_protection_enabled      = true
    key_vault_public_network_access_enabled = false
    key_vault_default_action                = "Deny"
    key_vault_bypass                        = "AzureServices"
    keyvault_secret_value                   = ">ha.16mGCKKj/RL5Oj(I%T,Bc49}S'"

    ip_rules = ["136.158.30.104", "136.158.30.105"]
    access_policies = {
      admin_policy = {
        tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
        object_id               = "394166a3-9a96-4db9-94b7-c970f2c97b27"
        secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"]
        key_permissions         = ["Get", "List", "Update", "Delete", "Recover", "Backup", "Restore", "Create", "Import"] # Ensure "Get" is included
        certificate_permissions = ["Get", "List", "Create", "Delete", "Import", "Update", "ManageContacts", "ManageIssuers", "Recover", "Backup", "Restore"]
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


output "keyvault_name" {
  description = "The name of the Key Vault"
  value       = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  description = "The URI of the Key Vault"
  value       = module.keyvault.keyvault_uri
}

# Output the Key Vault Key Name
output "keyvault_key_name" {
  description = "The name of the Key Vault Key"
  value       = module.keyvault.keyvault_name
}

# Output the Key Vault Key ID
output "keyvault_key_id" {
  description = "The ID of the Key Vault Key"
  value       = module.keyvault.keyvault_uri
}

# Output the Key Vault Secret Name
output "keyvault_secret_name" {
  description = "The name of the Key Vault Secret"
  value       = module.keyvault.keyvault_secret_name
}

# Output the Key Vault Secret ID
output "keyvault_secret_id" {
  description = "The ID of the Key Vault Secret"
  value       = module.keyvault.keyvault_secret_id
}

# Output the Key Vault Certificate Name
output "keyvault_certificate_name" {
  description = "The name of the Key Vault Certificate"
  value       = module.keyvault.keyvault_certificate_name
}

# Output the Key Vault Certificate ID
output "keyvault_certificate_id" {
  description = "The ID of the Key Vault Certificate"
  value       = module.keyvault.keyvault_certificate_id
}

# Output the IP Rules for the Key Vault
output "keyvault_ip_rules" {
  description = "The IP rules applied to the Key Vault"
  value       = module.keyvault.keyvault_ip_rules
}

