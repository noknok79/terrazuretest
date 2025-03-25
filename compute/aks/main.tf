# This Terraform configuration defines resources for an AKS cluster.
# These resources have been set in the akscluster.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/aks/aks.tfvars" --out="akscluster.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/aks/aks.tfvars" --input=false
# #2 terraform destroy -var-file="compute/aks/aks.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

# Configure the AzureRM provider with alias
provider "azurerm" {
  features {}
  alias = "aksazure"
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
  address_prefixes     = ["10.0.2.0/23"] # Corrected to align with /22 boundary
  depends_on           = [azurerm_virtual_network.vnet_aks]
}

resource "azurerm_subnet" "subnet_linux" {
  name                 = "subnet-linux-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.vnet_aks.name
  address_prefixes     = ["10.0.4.0/23"] # New subnet for Linux node pool
}

resource "azurerm_subnet" "subnet_windows" {
  name                 = "subnet-windows-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.vnet_aks.name
  address_prefixes     = ["10.0.6.0/24"] # New subnet for Windows node pool
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

  # Additional Linux node pool


  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.admin_group_object_ids
  }

  network_profile {
    network_plugin = "azure"         # Use Azure CNI for advanced networking
    network_policy = "calico"        # Set the network policy to Calico
    service_cidr   = "10.0.253.0/24" # Ensure this does not overlap with the subnet
    dns_service_ip = "10.0.253.10"   # Ensure this is within the servi  ce CIDR
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

resource "azurerm_kubernetes_cluster_node_pool" "linux_node_pool" {
  name                  = "linuxpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = var.linux_vm_size
  node_count            = var.linux_node_count
  os_type               = "Linux"
  vnet_subnet_id        = azurerm_subnet.subnet_linux.id
  max_pods              = 110
  node_labels           = { "namespace" = "linuxpool" }
  orchestrator_version  = var.kubernetes_version
}

# Additional Windows node pool
resource "azurerm_kubernetes_cluster_node_pool" "windows_node_pool" {
  name                  = "winpl" # Shortened to meet the 6-character limit
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = var.windows_vm_size
  node_count            = var.windows_node_count
  os_type               = "Windows"
  vnet_subnet_id        = azurerm_subnet.subnet_windows.id
  max_pods              = 110
  node_labels           = { "namespace" = "winpl" }
  orchestrator_version  = var.kubernetes_version
}

