terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  alias = "vnet"
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "aksazure"
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
}

provider "azurerm" {
  alias = "compute"
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "keyvault"
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
}
# Resource Group for VNet
provider "azurerm" {
  alias           = "vmss"
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#
# VNet Module
module "vnet" {
  source = "./networking/vnet"

  providers = {
    azurerm = azurerm.vnet
  }

  resource_group_name = var.vnet_config_group.resource_group_name
  location            = var.vnet_config_group.location
  vnet_name           = var.vnet_config_group.vnet_name
  address_space       = var.vnet_config_group.address_space
  subnets             = var.vnet_config_group.subnets
  
  subscription_id     = var.vnet_config_group.subscription_id
  tags                = var.vnet_config_group.tags
  environment         = var.vnet_config_group.environment
  project             = var.vnet_config_group.project
}


# Compute VM Module
module "compute_vm" {
  source = "./compute/vm"

  providers = {
    azurerm = azurerm.compute
  }

  resource_group_name           = var.vm_config.resource_group_name
 
  location                      = var.vm_config.location
  prefix                        = var.vm_config.prefix
  vm_size                       = var.vm_config.vm_size
  admin_username                = var.vm_config.admin_username
  admin_password                = var.vm_config.admin_password
  os_disk_storage_account_type  = var.vm_config.os_disk_storage_account_type
  image_reference               = var.vm_config.image_reference
  linux_custom_script_command   = var.vm_config.linux_custom_script_command
  windows_custom_script_command = var.vm_config.windows_custom_script_command
  tags                          = var.vm_config.tags
  environment         = var.vm_config.environment
  project             = var.vm_config.project
  os_type                       = var.vm_config.os_type
  ssh_public_key                = file("/root/.ssh/id_rsa.pub")

  virtual_network_name  = module.vnet.vnet_name
  subnet_name           = module.vnet.vnet_subnets[2].name # Assuming subnet5 is the third element
  address_space         = module.vnet.address_space
  subnet_address_prefix = module.vnet.vnet_subnets[2].address_prefix # Assuming subnet5 is the third element
  subnet_id = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-computevm"
  )
}


# AKS Module
module "aks" {
  source = "./compute/aks"

  providers = {
    azurerm = azurerm.aksazure
  }

  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
  resource_group_name = var.aks_config.resource_group_name
  location            = var.aks_config.location
  dns_prefix          = var.aks_config.dns_prefix
  vnet_name           = module.vnet.vnet_name
  subnet_id = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-akscluster"
  )
  cluster_name                    = var.aks_config.cluster_name
  kubernetes_version              = var.aks_config.kubernetes_version
  linux_vm_size                   = var.aks_config.linux_vm_size
  linux_node_count                = var.aks_config.linux_node_count
  windows_vm_size                 = var.aks_config.windows_vm_size
  windows_node_count              = var.aks_config.windows_node_count
  vm_size                         = var.aks_config.vm_size
  node_count                      = var.aks_config.node_count
  admin_group_object_ids          = var.aks_config.admin_group_object_ids
  authorized_ip_ranges            = var.aks_config.authorized_ip_ranges
  api_server_authorized_ip_ranges = var.aks_config.api_server_authorized_ip_ranges
  log_analytics_workspace_id      = var.aks_config.log_analytics_workspace_id
  tags                            = var.aks_config.tags
  environment                     = var.aks_config.environment
  project                         = var.aks_config.project
}


# Key Vault Module
module "keyvault" {
  source = "./security/keyvaults"

  resource_group_name   = var.keyvault_config.resource_group_name
  location              = var.keyvault_config.location
  keyvault_name         = var.keyvault_config.keyvault_name
  sku_name              = var.keyvault_config.sku_name
  tenant_id             = var.tenant_id
  subscription_id       = var.subscription_id
  virtual_network_name  = module.vnet.vnet_name
  subnet_id             = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-keyvault"
  )
  owner                 = var.keyvault_config.owner

  # Access Policies
  access_policies = var.keyvault_config.access_policies

  # Tags and Metadata
  tags        = var.keyvault_config.tags
  environment = var.keyvault_config.environment
  project     = var.keyvault_config.project
}

# VMSS Module
module "vmss" {
  source = "./compute/vmscalesets"

  providers = {
    azurerm = azurerm.vmss
  }

  # Azure Configuration
  subscription_id                  = var.vmss_azure.subscription_id
  tenant_id                        = var.vmss_azure.tenant_id
  location                         = var.vmss_azure.location
  rg_vmss                          = var.vmss_azure.resource_group
  tags                             = var.vmss_azure.tags
  environment                      = var.vmss_azure.environment

  # VM Scale Set Configuration
  vmss_name                        = var.vmss_config.name
  vmss_sku                         = var.vmss_config.sku
  vmss_instances                   = var.vmss_config.instances
  vmss_image_publisher             = var.vmss_config.image.publisher
  vmss_image_offer                 = var.vmss_config.image.offer
  vmss_image_sku                   = var.vmss_config.image.sku
  vmss_image_version               = var.vmss_config.image.version
  vmss_os_disk_storage_account_type = var.vmss_config.os_disk.storage_account_type
  vmss_os_disk_caching             = var.vmss_config.os_disk.caching
  vmss_ip_config_name              = var.vmss_config.ip_config_name
  nic_name                         = var.vmss_config.nic_name
  load_balancer_id                 = var.vmss_config.load_balancer_id
  backend_pool_id                  = var.vmss_config.backend_pool_id
  log_analytics_workspace_id       = var.vmss_config.log_analytics_workspace_id

  # Networking Configuration
  admin_username                   = var.vmss_network.admin_username
  admin_password                   = var.vmss_network.admin_password
  ssh_public_key_path              = var.vmss_network.ssh_public_key_path
  vnet_name                        = module.vnet.vnet_name
  vnet_address_space               = module.vnet.address_space
  subnet_name                      = module.vnet.vnet_subnets[2].name # Assuming subnet5 is the third element
  subnet_id                        = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-vmscaleset"
  )
  subnet_address_prefixes          = [module.vnet.vnet_subnets[2].address_prefix] # Assuming subnet5 is the third element
  public_ip_enabled                = var.vmss_network.public_ip_enabled
  nic_ip_config_name               = var.vmss_network.nic_ip_config_name
  nic_ip_allocation                = var.vmss_network.nic_ip_allocation
  nsg_name                         = var.vmss_network.nsg_name
  nsg_rule_name                    = var.vmss_network.nsg_rule.name
  nsg_rule_priority                = var.vmss_network.nsg_rule.priority
  nsg_rule_protocol                = var.vmss_network.nsg_rule.protocol
  nsg_rule_direction               = var.vmss_network.nsg_rule.direction
  nsg_rule_access                  = var.vmss_network.nsg_rule.access
  nsg_rule_source_address_prefix   = var.vmss_network.nsg_rule.source_address_prefix
  nsg_rule_source_port_range       = var.vmss_network.nsg_rule.source_port_range
  nsg_rule_destination_address_prefix = var.vmss_network.nsg_rule.destination_address_prefix
  nsg_rule_destination_port_range  = var.vmss_network.nsg_rule.destination_port_range
}

# Azure SQL Module
module "azsql" {
  source = "./databases/azsqldbs"

  # General Configuration
  project         = var.config.project
  subscription_id = var.config.subscription_id
  environment     = var.config.environment
  location        = var.config.location

  # Tags
  tags = var.config.tags

  # SQL Server Configuration
  sql_server_name           = var.config.sql_server_name
  sql_server_admin_username = var.config.sql_server_admin_username
  sql_server_admin_password = var.config.sql_server_admin_password

  # SQL Database Configuration
  database_names        = var.config.database_names
  sql_database_sku_name = var.config.sql_database_sku_name
  max_size_gb           = var.config.max_size_gb

  # Storage Account Configuration
  storage_account_name = var.config.storage_account_name

  # Monitoring Configuration
  log_analytics_workspace_id = var.config.log_analytics_workspace_id

  # Azure Active Directory Configuration
  tenant_id           = var.config.tenant_id
  aad_admin_object_id = var.config.aad_admin_object_id

  # Admin Credentials
  admin_username = var.config.admin_username
  admin_password = var.config.admin_password

  # Resource Group
  resource_group_name = var.config.resource_group_name

  # Networking Configuration
  vnet_name             = module.vnet.vnet_name
  vnet_address_space    = module.vnet.address_space
  subnet_id             = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.id },
    "subnet-azsqldbs"
  )
  subnet_name           = lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.name },
    "subnet-azsqldbs"
  )
  subnet_address_prefix = [lookup(
    { for subnet in module.vnet.vnet_subnets : subnet.name => subnet.address_prefix },
    "subnet-azsqldbs"
  )]
}
