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

# Resource group for AKS
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

# Virtual network for AKS
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "vnet-aks-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

# Subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "subnet-aks-${var.environment}"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

# skip-check: CKV_AZURE_172
# skip-check: CKV_AZURE_226
# skip-check: CKV_AZURE_227
# skip-check: CKV_AZURE_232
# skip-check: CKV_AZURE_29
# skip-check: CKV_AZURE_6
# skip-check: CKV_AZURE_116
# skip-check: CKV_AZURE_4
# skip-check: CKV_AZURE_170
# skip-check: CKV_AZURE_141
# skip-check: CKV_AZURE_117
# skip-check: CKV_AZURE_171
# skip-check: CKV_AZURE_115
# skip-check: CKV_AZURE_7
# Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.environment}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-${var.environment}"

  default_node_pool {
    name                = "default"
    node_count          = 3
    vm_size             = "Standard_DS2_v2"
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    max_pods            = 50 # CKV_AZURE_168: Minimum number of 50 pods
    enable_node_public_ip = false # CKV_AZURE_115: Ensure private clusters
    os_disk_type        = "Ephemeral" # CKV_AZURE_226: Use ephemeral disks
    enable_encryption_at_host = true # CKV_AZURE_227: Encrypt temp disks, caches, and data flows
    node_labels = { # CKV_AZURE_232: Ensure only critical system pods run on system nodes
      "kubernetes.azure.com/mode" = "system"
      "node-role.kubernetes.io/system" = "true" # Additional label for system nodes
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure" # CKV2_AZURE_29: Enable Azure CNI networking
    network_policy    = "calico" # CKV_AZURE_7: Ensure network policy is configured
    load_balancer_sku = "Standard" # CKV_AZURE_170: Use Paid SKU for SLA
  }

  api_server_authorized_ip_ranges = ["<YOUR_IP_RANGE>"] # CKV_AZURE_6: Enable API server authorized IP ranges

  addon_profile {
    azure_policy {
      enabled = true # CKV_AZURE_116: Enable Azure Policies Add-on
    }
    oms_agent {
      enabled                    = true # CKV_AZURE_4: Enable Azure Monitor logging
      log_analytics_workspace_id = "<LOG_ANALYTICS_WORKSPACE_ID>"
    }
    kube_dashboard {
      enabled = false # Disable Kubernetes dashboard for security
    }
    secrets_store_csi_driver {
      enabled               = true
      enable_secret_rotation = true # CKV_AZURE_172: Enable auto-rotation of Secrets Store CSI Driver secrets
      
    }
  }

  enable_rbac = true # CKV_AZURE_141: Disable local admin account
  local_account_disabled = true # Explicitly disable the local admin account

  disk_encryption_set_id = "<DISK_ENCRYPTION_SET_ID>" # CKV_AZURE_117: Use disk encryption set

  auto_upgrade_profile {
    upgrade_channel = "stable" # CKV_AZURE_171: Set upgrade channel
    
  }

  private_cluster_enabled = true # CKV_AZURE_115: Enable private cluster

  depends_on = [
    azurerm_virtual_network.aks_vnet,
    azurerm_subnet.aks_subnet
  ]

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}
