# This Terraform configuration defines resources for an Azure Key Vault and related components.
# These resources have been set in the keyvault.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="security/keyvaults/keyvaults.tfvars" --out="keyvault.plan" --input=false
# To apply the configuration, use the following command:
# terraform apply "keyvault.plan"
# To destroy, use the following commands:
# #1 terraform plan -destroy -var-file="security/keyvaults/keyvaults.tfvars" --input=false
# #2 terraform destroy -var-file="security/keyvaults/keyvaults.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>


terraform {
  required_version = ">= 1.5.6" # Ensure compatibility with the latest Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0" # Use the latest stable AzureRM provider version
    }
  }
}

# Aliased provider for AzureRM
provider "azurerm" {
  alias           = "keyvault"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {} # Required for AzureRM provider
}

# Resource group for the Key Vault
resource "azurerm_resource_group" "rg" {
  name     = var.rg_keyvault
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }

  depends_on = []
}

# Pre-requisite: Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# Pre-requisite: Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-keyvault-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # Valid delegation for Microsoft.Sql/servers
  delegation {
    name = "sql-delegation"
    service_delegation {
      name = "Microsoft.Sql/servers"
    }
  }
}

# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  provider = azurerm.keyvault

  name                          = var.keyvault_name
  location                      = var.location
  resource_group_name           = var.rg_keyvault
  sku_name                      = var.sku_name
  tenant_id                     = var.tenant_id
  enable_rbac_authorization     = var.enable_rbac_authorization
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.enable_purge_protection
  public_network_access_enabled = false

  network_acls {
    bypass                     = var.network_acls_bypass
    default_action             = var.network_acls_default_action
    ip_rules                   = var.network_acls_ip_rules
    virtual_network_subnet_ids = [var.subnet_id] # Ensure this is a valid Subnet ID
  }

  dynamic "access_policy" {
    for_each = range(length(var.access_policies_tenant_ids))
    content {
      tenant_id               = var.access_policies_tenant_ids[access_policy.value]
      object_id               = var.access_policies_object_ids[access_policy.value]
      key_permissions         = var.access_policies_key_permissions[access_policy.value]
      secret_permissions      = var.access_policies_secret_permissions[access_policy.value]
      certificate_permissions = var.access_policies_certificate_permissions[access_policy.value]
    }
  }

  tags = var.tags
}

# Azure Key Vault Key
resource "azurerm_key_vault_key" "key" {
  provider = azurerm.keyvault

  name         = var.key_name
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]

  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault_pe" {
  provider = azurerm.keyvault

  name                = "pe-keyvault-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "keyvault-connection"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
}

# Data source for tenant ID
data "azurerm_client_config" "current" {}

# Data source to retrieve the Key Vault
data "azurerm_key_vault" "kv" {
  depends_on = [azurerm_key_vault.kv]

  name                = azurerm_key_vault.kv.name
  resource_group_name = azurerm_key_vault.kv.resource_group_name
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  provider                          = azurerm.keyvault
  name                              = "cosmosdb-${var.environment}"
  location                          = var.location
  resource_group_name               = azurerm_resource_group.rg.name
  offer_type                        = "Standard"
  kind                              = "GlobalDocumentDB"
  is_virtual_network_filter_enabled = true
  public_network_access_enabled     = false
  key_vault_key_id                  = azurerm_key_vault_key.key.id # Use the versionless key ID


  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}
