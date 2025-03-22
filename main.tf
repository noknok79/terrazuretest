terraform {
  required_version = ">= 1.5.0"

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
}

module "computevm" {
  source              = "./compute/vm"
  environment         = var.environment
  location            = var.location
  tags                = var.tags
  vm_count            = var.vm_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  ssh_public_key_path = var.ssh_public_key_path
  subscription_id     = var.subscription_id
}

module "aks_cluster" {
  source = "./compute/aks"
  providers = {
    azurerm = azurerm
  }

  admin_group_object_ids     = var.admin_group_object_ids
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # General configuration
  environment = var.environment
  location    = var.location
  project     = var.project

  # AKS-specific configuration
  node_count                      = var.node_count
  vm_size                         = var.vm_size
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  # Tags
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

