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

provider "azurerm" {
  features {}
  subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
}


# provider "azurerm" {
#   alias           = "keyvault"
#   features {}
#   subscription_id = var.subscription_id
#   tenant_id       = var.tenant_id
# }




# Resource group for the Key Vault
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
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
    depends_on = [azurerm_resource_group.rg]

}

# Pre-requisite: Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-keyvault-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.KeyVault"] # Add this line

  # Valid delegation for Microsoft.Sql/servers
  delegation {
    name = "sql-delegation"
    service_delegation {
      name = "Microsoft.Sql/managedInstances" # Updated to a valid service name
    }
  }
    depends_on = [azurerm_virtual_network.vnet]

}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "subnet-private-endpoint-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"] # Use a different address range

  service_endpoints = ["Microsoft.KeyVault"] # Optional, depending on your requirements

  depends_on = [azurerm_virtual_network.vnet]
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  #  name                          = var.keyvault_name
  name                          = "keyvault-${var.environment}-${random_string.suffix.result}"  
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku_name                      = var.sku_name
  tenant_id                     = var.tenant_id
  enable_rbac_authorization     = var.enable_rbac_authorization
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.enable_purge_protection
  public_network_access_enabled = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = var.network_acls_default_action
    ip_rules                   = concat(var.network_acls_ip_rules, ["136.158.57.203"]) # Add client IP
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]# Wrap in a list
  }

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
      object_id               = "394166a3-9a96-4db9-94b7-c970f2c97b27"
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      certificate_permissions = access_policy.value.certificate_permissions
    }
  }

  tags = var.tags
        depends_on = [azurerm_resource_group.rg, azurerm_subnet.subnet]



}

# Azure Key Vault Key
resource "azurerm_key_vault_key" "key" {
  # provider = azurerm.keyvault

  name         = var.key_name
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]

  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault_pe" {
  # provider = azurerm.keyvault

  name                = "pe-keyvault-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint_subnet.id # Use the new subnet

  private_service_connection {
    name                           = "keyvault-connection"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
    depends_on = [azurerm_key_vault.kv]

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
# resource "azurerm_cosmosdb_account" "cosmosdb" {
#   name                              = "cosmosdb-${var.environment}"
#   location                          = var.location
#   resource_group_name               = var.resource_group_name
#   offer_type                        = "Standard"
#   kind                              = "GlobalDocumentDB"
#   is_virtual_network_filter_enabled = true
#   public_network_access_enabled     = false
#   key_vault_key_id                  = "https://${azurerm_key_vault.kv.name}.vault.azure.net/keys/${azurerm_key_vault_key.key.name}"

#   consistency_policy {
#     consistency_level = var.consistency_level
#   }

#   geo_location {
#     location          = var.location
#     failover_priority = 0
#   }

#   tags = var.tags

#   lifecycle {
#     ignore_changes = [
#       "name",
#       "location",
#       "resource_group_name",
#       "offer_type",
#       "kind",
#       "is_virtual_network_filter_enabled",
#       "public_network_access_enabled",
#       "key_vault_key_id",
#       "consistency_policy",
#       "geo_location",
#       "tags"
#     ]
#   }
# }

