# Variables
variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "environment" {
  description = "The environment for the deployment."
  type        = string
}

variable "owner" {
  description = "The owner of the resources."
  type        = string
}

variable "project" {
  description = "The project associated with the resources."
  type        = string
}

variable "network_acls_ip_rules" {
  description = "The IP rules for network ACLs."
  type        = list(string)
}

variable "network_acls_virtual_network_ids" {
  description = "The virtual network IDs for network ACLs."
  type        = list(string)
}

variable "access_policies" {
  description = "The access policies for the Key Vault."
  type        = map(object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = list(string)
    key_permissions         = list(string)
    certificate_permissions = list(string)
  }))
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "keyvault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "admin_object_id" {
  description = "The object ID of the Key Vault administrator."
  type        = string
}

variable "keyvault_secret_value" {
  description = "The value of the Key Vault secret."
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Key Vault."
  type        = string
}

variable "enable_rbac_authorization" {
  description = "Whether to enable RBAC authorization for the Key Vault."
  type        = bool
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain soft-deleted Key Vaults."
  type        = number
}

variable "enable_purge_protection" {
  description = "Whether to enable purge protection for the Key Vault."
  type        = bool
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Key Vault."
  type        = bool
}

variable "key_name" {
  description = "The name of the Key Vault key."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
}

variable "subnet_service_endpoints" {
  description = "The service endpoints for the subnet."
  type        = list(string)
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "The address prefixes for the private endpoint subnet."
  type        = list(string)
}

variable "private_endpoint_service_endpoints" {
  description = "The service endpoints for the private endpoint."
  type        = list(string)
}

variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the storage account."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
}

variable "cost_center" {
  description = "The cost center for the resources."
  type        = string
}

variable "client_ip" {
  description = "The client IP address for network ACLs."
  type        = string
}

variable "network_acls_bypass" {
  description = "The bypass setting for network ACLs."
  type        = string
}

variable "network_acls_default_action" {
  description = "The default action for network ACLs."
  type        = string
}

variable "ip_rules" {
  description = "List of IP addresses allowed to access the Key Vault"
  type        = list(string)
  default     = [] # Provide an empty list as default
}

variable "virtual_network_subnet_ids" {
  description = "List of subnet IDs allowed to access the Key Vault"
  type        = list(string)
  default     = [] # Provide an empty list as default
}