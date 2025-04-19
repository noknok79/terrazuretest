variable "subscription_id" {
  description = "Azure subscription ID"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the Key Vault"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
}

variable "owner" {
  description = "Owner of the resources"
}

variable "project" {
  description = "Project name"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
}

variable "virtual_network_address_space" {
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "subnet-keyvault"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  default     = ["10.0.1.0/24"]
}

variable "subnet_service_endpoints" {
  description = "Service endpoints for the subnet"
  default     = ["Microsoft.KeyVault"]
}

variable "key_vault_sku_name" {
  description = "SKU name for the Key Vault"
  default     = "standard"
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection for the Key Vault"
  default     = true
}

variable "key_vault_public_network_access_enabled" {
  description = "Enable public network access for the Key Vault"
  default     = false
}

variable "key_vault_default_action" {
  description = "Default action for Key Vault network ACLs"
  default     = "Deny"
}

variable "key_vault_bypass" {
  description = "Bypass setting for Key Vault network ACLs"
  default     = "AzureServices"
}

variable "ip_rules" {
  description = "IP rules for Key Vault network ACLs"
  default     = []
}

variable "access_policies" {
  description = "Access policies for the Key Vault"
  type = map(object({
    tenant_id              = string
    object_id              = string
    certificate_permissions = list(string) # Ensure this is a flat list
    key_permissions        = list(string)
    secret_permissions     = list(string)
  }))
}

variable "network_acls_virtual_network_ids" {
  description = "List of virtual network IDs for Key Vault network ACLs"
  type        = list(string)
  default     = [] # Provide a default value if applicable
}

variable "tags" {
  description = "Tags to apply to the Key Vault"
  type        = map(string)
}

variable "sku_name" {
  description = "The SKU name for the Key Vault"
  type        = string
}

variable "cost_center" {
  description = "Cost center for resource tracking"
  type        = string
  default     = "IT-001" # Adjust the default value if needed
}

variable "tenant_id" {
  description = "The tenant ID for the Key Vault"
  type        = string
}

variable "keyvault_name" {
  description = "The name of the Key Vault"
  type        = string
  
}

# Add your variable declarations here

variable "subnet_id" {
  description = "The ID of the subnet to associate with the Key Vault network ACLs"
  type        = string
}

variable "keyvault_secret_value" {
  description = "The value of the secret to be stored in the Key Vault."
  type        = string
}

# variable "keyvault_id" {
#   description = "The ID of the Key Vault."
#   type        = string
# }