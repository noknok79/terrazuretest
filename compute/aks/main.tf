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

provider "azurerm" {
  alias = "aksazure"
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg_aks" {
  name = var.resource_group_name
  #name     = "rg-aks-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "azurerm_virtual_network" "vnet_aks" {
  name                = "vnet-aks-${var.environment}"
  address_space       = ["10.0.0.0/16"] # Changed to avoid overlap
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "azurerm_subnet" "subnet_aks" {
  name                 = "subnet-aks-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_aks.name
  address_prefixes     = ["10.0.2.0/23"] # Adjusted to fit within new VNet range
  depends_on           = [azurerm_virtual_network.vnet_aks]
}

resource "azurerm_subnet" "subnet_linux" {
  name                 = "subnet-linux-${var.environment}"
  resource_group_name  = var.resource_group_name

  virtual_network_name = azurerm_virtual_network.vnet_aks.name
  address_prefixes     = ["10.0.4.0/23"] # Adjusted to fit within new VNet range
}

resource "azurerm_subnet" "subnet_windows" {
  name                 = "subnet-windows-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_aks.name
  address_prefixes     = ["10.0.6.0/24"] # Adjusted to fit within new VNet range
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name            = "default"
    vm_size         = var.vm_size
    node_count      = var.node_count
    vnet_subnet_id = azurerm_subnet.subnet_aks.id
    #vnet_subnet_id  = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16" # Changed to avoid overlap with VNet
    dns_service_ip = "10.1.0.10"
    # Removed invalid attribute docker_bridge_cidr
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
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

resource "azurerm_kubernetes_cluster_node_pool" "windows_node_pool" {
  name                  = "winpl"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = var.windows_vm_size
  node_count            = var.windows_node_count
  os_type               = "Windows"
  vnet_subnet_id        = azurerm_subnet.subnet_windows.id
  max_pods              = 110
  node_labels           = { "namespace" = "winpl" }
  orchestrator_version  = var.kubernetes_version
}

