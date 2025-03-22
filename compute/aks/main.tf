# This Terraform configuration defines resources for an AKS cluster.
# This resources has been set on the akscluster.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/aks/aks.tfvars" --out="akscluster.plan" --input=false

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0" # Use the latest stable version
    }
  }
}

# Define the resource group for AKS
# This resource has been created in akscluster.plan
resource "azurerm_resource_group" "rg_aks" {
  name     = "rg-aks-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Define the virtual network for AKS
# This resource has been created in akscluster.plan
resource "azurerm_virtual_network" "vnet_aks" {
  name                = "vnet-aks-${var.environment}"
  address_space       = ["10.0.0.0/16"] # Ensure this is large enough to accommodate subnets
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Define the subnet for AKS
# This resource has been created in akscluster.plan
resource "azurerm_subnet" "subnet_aks" {
  name                 = "subnet-aks-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.vnet_aks.name
  address_prefixes     = ["10.0.1.0/24"] # Ensure this is within the virtual network's address space
  depends_on           = [azurerm_virtual_network.vnet_aks]
}

# Define the AKS cluster
# This resource has been created in akscluster.plan
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-${var.environment}"
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  dns_prefix          = "aks-${var.environment}"

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.subnet_aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.admin_group_object_ids
  }
  # Enable Role-Based Access Control (RBAC) with Azure Active Directory
  # azure_active_directory_role_based_access_control {
  #   admin_group_object_ids = slice(var.admin_group_object_ids, 0, min(length(var.admin_group_object_ids), 3))
  # }

  network_profile {
    network_plugin = "azure"       # Use Azure CNI for advanced networking
    network_policy = "calico"      # Set the network policy to Calico
    service_cidr   = "10.0.2.0/24" # Ensure this does not overlap with the subnet
    dns_service_ip = "10.0.2.10"   # Ensure this is within the service CIDR
    #docker_bridge_cidr = "172.17.0.1/16" # Ensure this does not overlap with the virtual network
  }

  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  tags = {
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [
    azurerm_resource_group.rg_aks,
    azurerm_virtual_network.vnet_aks,
    azurerm_subnet.subnet_aks
  ]
}

