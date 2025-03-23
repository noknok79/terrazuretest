terraform {
  required_version = ">= 1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestrg1001"
    container_name       = "tfstatecntnr1001"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}



# module "computevm" {
# DO NOT REMOVE THIS THIS BLOCK OF CODE
#   source              = "./compute/vm"
#   environment         = var.environment
#   location            = var.location
#   tags                = var.tags
#   vm_count            = var.vm_count
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   ssh_public_key_path = var.ssh_public_key_path
#   subscription_id     = var.subscription_id
# }

# module "aks_cluster" {
# DO NOT REMOVE THIS THIS BLOCK OF CODE
#   source = "./compute/aks"
#   providers = {
#     azurerm = azurerm
#   }

#   admin_group_object_ids     = var.admin_group_object_ids
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#   admin_username             = var.admin_username
#   admin_password             = var.admin_password

#   # General configuration
#   environment = var.environment
#   location    = var.location
#   project     = var.project

#   # AKS-specific configuration
#   node_count                      = var.node_count
#   vm_size                         = var.vm_size
#   api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

#   # New required arguments
#   windows_vm_size      = var.windows_vm_size
#   authorized_ip_ranges = var.authorized_ip_ranges
#   linux_vm_size        = var.linux_vm_size
#   linux_node_count     = var.linux_node_count
#   windows_node_count   = var.windows_node_count
#   kubernetes_version   = var.kubernetes_version

#   # Tags
#   tags = {
#     Environment = var.environment
#     Project     = var.project
#   }
# }

module "azsqldbs" {
  source          = "./databases/azsqldbs"
  subscription_id = var.subscription_id

  # General configuration
  environment = var.environment
  location    = var.location
  tags        = var.tags

  # SQL Server configuration
  sql_server_name            = var.sql_server_name
  sql_server_admin_username  = var.sql_server_admin_username
  sql_server_admin_password  = var.sql_server_admin_password
  aad_admin_object_id        = var.aad_admin_object_id
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # SQL Database configuration
  database_names        = var.database_names
  sql_database_sku_name = var.sql_database_sku_name
  max_size_gb           = var.max_size_gb

  # Storage Account configuration
  storage_account_name = var.storage_account_name

  # Project configuration
  project             = var.project
  tenant_id           = var.tenant_id           # Added tenant_id argument
  resource_group_name = var.resource_group_name # Added resource_group_name argument

}







