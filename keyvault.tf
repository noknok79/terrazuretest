# This Terraform configuration defines resources for an Azure Key Vault instance.
# These resources have been set in the keyvault.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="security/keyvaults/keyvaults.tfvars" --out="keyvault.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="security/keyvaults/keyvaults.tfvars" --input=false
# #2 terraform destroy -var-file="security/keyvaults/keyvaults.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

# terraform {
#   required_version = ">= 1.4.6"
# }

# module "keyvaults" {
#   source = "./security/keyvaults"

#   # General configuration
#   owner                      = var.owner
#   rg_keyvault                = var.rg_keyvault
#   keyvault_name              = var.keyvault_config.name
#   location                   = var.keyvault_config.location
#   sku_name                   = var.keyvault_config.sku_name
#   enable_soft_delete         = var.keyvault_config.enable_soft_delete
#   soft_delete_retention_days = var.keyvault_config.soft_delete_retention_days
#   enable_purge_protection    = var.keyvault_config.enable_purge_protection
#   enable_rbac_authorization  = var.keyvault_config.enable_rbac_authorization
#   consistency_level          = var.keyvault_config.consistency_level
#   tags                       = var.keyvault_config.tags

#   # Network ACLs configuration
#   network_acls_ip_rules            = var.network_acls.ip_rules
#   network_acls_default_action      = var.network_acls.default_action
#   network_acls_virtual_network_ids = var.network_acls.virtual_network_ids
#   network_acls_bypass              = var.network_acls.bypass

#   # Access policies configuration
#   access_policies_object_ids              = [for policy in var.access_policies : policy.object_id]
#   access_policies_tenant_ids              = [for policy in var.access_policies : policy.tenant_id]
#   access_policies_key_permissions         = [for policy in var.access_policies : policy.key_permissions]
#   access_policies_secret_permissions      = [for policy in var.access_policies : policy.secret_permissions]
#   access_policies_certificate_permissions = [for policy in var.access_policies : policy.certificate_permissions]

#   # Required attributes
#   key_vault_key_id = var.keyvault_data.key_vault_key_id
#   tenant_id        = var.keyvault_data.tenant_id
#   subnet_id        = var.keyvault_data.subnet_id
#   key_name         = var.keyvault_data.key_name
#   subscription_id  = var.keyvault_data.subscription_id
#   environment      = var.keyvault_data.environment
# }

# # Grouped variables for better organization and maintainability

# variable "keyvault_config" {
#   description = "Configuration for the Azure Key Vault."
#   type = object({
#     name                       = string
#     location                   = string
#     sku_name                   = string
#     enable_soft_delete         = bool
#     soft_delete_retention_days = number
#     enable_purge_protection    = bool
#     enable_rbac_authorization  = bool
#     consistency_level          = string
#     tags                       = map(string)
#   })
#   default = {
#     name                       = "example-keyvault"
#     location                   = "eastus"
#     sku_name                   = "standard"
#     enable_soft_delete         = true
#     soft_delete_retention_days = 90
#     enable_purge_protection    = true
#     enable_rbac_authorization  = true
#     consistency_level          = "Session"
#     tags                       = { environment = "dev", owner = "example-owner" }
#   }
# }

# variable "network_acls" {
#   description = "Network ACLs for the Azure Key Vault."
#   type = object({
#     ip_rules            = list(string)
#     default_action      = string
#     virtual_network_ids = list(string)
#     bypass              = string
#   })
#   default = {
#     ip_rules            = ["192.168.1.1", "192.168.1.2"]
#     default_action      = "Deny"
#     virtual_network_ids = ["/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet"]
#     bypass              = "AzureServices"
#   }
# }

# variable "access_policies" {
#   description = "Access policies for the Azure Key Vault."
#   type = list(object({
#     object_id               = string
#     tenant_id               = string
#     key_permissions         = list(string)
#     secret_permissions      = list(string)
#     certificate_permissions = list(string)
#   }))
#   default = [
#     {
#       object_id               = "096534ab-9b99-4153-8505-90d030aa4f08"
#       tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
#       key_permissions         = ["Get", "List", "Create"]
#       secret_permissions      = ["Get", "List", "Set"]
#       certificate_permissions = ["Get", "List"]
#     }
#   ]
# }

# variable "owner" {
#   description = "The owner of the Key Vault."
#   type        = string
#   default     = "example-owner"
# }

# variable "rg_keyvault" {
#   description = "The name of the resource group for the Key Vault."
#   type        = string
#   default     = "example-resource-group"
# }

# # Declare the missing variable
# variable "key_vault_key_id" {
#   description = "The ID of the key to be used in the Azure Key Vault."
#   type        = string
#   default     = "https://example-keyvault.vault.azure.net/keys/example-key/00000000000000000000000000000000"
# }




# variable "keyvault_data" {
#   description = "Additional configuration for the Azure Key Vault."
#   type = object({
#     owner            = string
#     rg_keyvault      = string
#     key_vault_key_id = string
#     tenant_id        = string
#     subnet_id        = string
#     subscription_id  = string
#     environment      = string
#     key_name         = string
#   })
#   default = {
#     owner            = "example-owner"
#     rg_keyvault      = "example-resource-group"
#     key_vault_key_id = "https://example-keyvault.vault.azure.net/keys/example-key/00000000000000000000000000000000"
#     tenant_id        = "72f988bf-86f1-41af-91ab-2d7cd011db47"
#     subnet_id        = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
#     subscription_id  = "096534ab-9b99-4153-8505-90d030aa4f08"
#     environment      = "dev"
#     key_name         = "example-key"
#   }
# }



# output "key_vault_uri" {
#   description = "The URI of the created Azure Key Vault."
#   value       = module.keyvaults.key_vault_uri
# }


