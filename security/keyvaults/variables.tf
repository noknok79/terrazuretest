variable "owner" {
  description = "The owner of the resources"
  type        = string
}


# Subscription ID
variable "subscription_id" {
  description = "The subscription ID for the Azure Key Vault"
  type        = string
}

# Environment
variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

# Location
variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Resource Group for Key Vault
variable "rg_keyvault" {
  description = "The name of the resource group for the Key Vault"
  type        = string
}

# Key Vault Name
variable "keyvault_name" {
  description = "The name of the Key Vault"
  type        = string
}

# SKU Name
variable "sku_name" {
  description = "The SKU name for the Key Vault"
  type        = string
}

# Tenant ID
variable "tenant_id" {
  description = "The Azure Active Directory tenant ID"
  type        = string
}

# Enable RBAC Authorization
variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for the Key Vault"
  type        = bool
}

# Subnet ID
variable "subnet_id" {
  description = "The subnet ID for the private endpoint"
  type        = string
}

# Network ACLs - Individual Variables
variable "network_acls_bypass" {
  description = "Specifies which traffic can bypass the network rules"
  type        = string
}

variable "network_acls_default_action" {
  description = "The default action for network rules"
  type        = string
}

variable "network_acls_ip_rules" {
  description = "A list of IP rules for the Key Vault"
  type        = list(string)
}

variable "network_acls_virtual_network_ids" {
  description = "A list of virtual network IDs for the Key Vault"
  type        = list(string)
}

# Access Policies - Individual Variables
variable "access_policies_tenant_ids" {
  description = "A list of tenant IDs for the access policies"
  type        = list(string)
}

variable "access_policies_object_ids" {
  description = "A list of object IDs for the access policies"
  type        = list(string)
}

variable "access_policies_key_permissions" {
  description = "A list of key permissions for the access policies"
  type        = list(list(string))
}

variable "access_policies_secret_permissions" {
  description = "A list of secret permissions for the access policies"
  type        = list(list(string))
}

variable "access_policies_certificate_permissions" {
  description = "A list of certificate permissions for the access policies"
  type        = list(list(string))
}

# Key Vault Key ID
variable "key_vault_key_id" {
  description = "The Key Vault key identifier for Cosmos DB"
  type        = string
}

# Key Name
variable "key_name" {
  description = "The name of the Key Vault key"
  type        = string
}

# Enable Soft Delete
variable "enable_soft_delete" {
  description = "Enable soft delete for the Azure Key Vault"
  type        = bool
}

# Soft Delete Retention Days
variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted Key Vaults"
  type        = number
}

# Enable Purge Protection
variable "enable_purge_protection" {
  description = "Enable purge protection for the Key Vault"
  type        = bool
}

# Consistency Level
variable "consistency_level" {
  description = "The consistency level for Cosmos DB"
  type        = string
}
