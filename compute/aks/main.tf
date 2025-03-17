terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
}

# Define resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Define virtual network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "vnet-aks-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Define subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "subnet-aks-${var.environment}"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.aks_vnet]
}

# Define AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.environment}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-${var.environment}"

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure" # Use Azure CNI
    network_policy = "calico" # Set the network policy to Calico
  }

  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  tags = {
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [azurerm_subnet.aks_subnet]
}
