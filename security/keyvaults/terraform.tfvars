# Owner of the resources
owner = "example-owner"

# Subscription ID for the Azure Key Vault
subscription_id = "00000000-0000-0000-0000-000000000000"

# Environment (e.g., dev, prod)
environment = "dev"

# Azure region where resources will be deployed
location = "eastus"

# Tags to apply to resources
tags = {
  environment = "dev"
  owner       = "example-owner"
}

# Name of the resource group for the Key Vault
rg_keyvault = "example-resource-group"

# Name of the Key Vault
keyvault_name = "example-keyvault"

# SKU name for the Key Vault
sku_name = "standard"

# Azure Active Directory tenant ID
tenant_id = "00000000-0000-0000-0000-000000000000"

# Enable RBAC authorization for the Key Vault
enable_rbac_authorization = true

# Subnet ID for the private endpoint
subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"

# Network ACLs - Individual Variables
network_acls_bypass              = "AzureServices"
network_acls_default_action      = "Deny"
network_acls_ip_rules            = ["192.168.1.1", "192.168.1.2"]
network_acls_virtual_network_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet"]

# Access Policies - Individual Variables
access_policies_tenant_ids              = ["00000000-0000-0000-0000-000000000000"]
access_policies_object_ids              = ["11111111-1111-1111-1111-111111111111"]
access_policies_key_permissions         = [["get", "list"]]
access_policies_secret_permissions      = [["get", "list"]]
access_policies_certificate_permissions = [["get", "list"]]

# Key Vault key identifier for Cosmos DB
key_vault_key_id = "https://example-keyvault.vault.azure.net/keys/example-key/00000000000000000000000000000000"

# Name of the Key Vault key
key_name = "example-key"

# Enable soft delete for the Azure Key Vault
enable_soft_delete = true

# Number of days to retain soft-deleted Key Vaults
soft_delete_retention_days = 90

# Enable purge protection for the Key Vault
enable_purge_protection = true

# Consistency level for Cosmos DB
consistency_level = "Session"
