terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

provider "azurerm" {
  alias                      = "vnet_eastus"
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "vnet_centralus"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "euswuspeering"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


provider "azurerm" {
  alias                      = "euscuspeering"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "cosmosdb"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "azsqldb"
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias           = "keyvault"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "vmss"
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "appgw"
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "psqldb"
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "vnet_eastus" {
  source = "./networking/vnet/vneteastus"

  resource_group_name = var.vneteastus_config.resource_group_name
  location            = var.vneteastus_config.location
  vnet_name           = var.vneteastus_config.vnet_name
  address_space       = var.vneteastus_config.address_space
  subnets             = var.vneteastus_config.subnets

  project         = var.vneteastus_config.project
  environment     = var.vneteastus_config.environment
  subscription_id = var.vneteastus_config.subscription_id
  tenant_id       = var.vneteastus_config.tenant_id
  tags            = var.vneteastus_config.tags
}

module "vnet_centralus" {
  source = "./networking/vnet/vnetcentralus"

  resource_group_name = var.vnetcentralus_config.resource_group_name
  location            = var.vnetcentralus_config.location
  vnet_name           = var.vnetcentralus_config.vnet_name
  address_space       = var.vnetcentralus_config.address_space
  subnets             = var.vnetcentralus_config.subnets

  project         = var.vnetcentralus_config.project
  environment     = var.vnetcentralus_config.environment
  subscription_id = var.vnetcentralus_config.subscription_id
  tenant_id       = var.vnetcentralus_config.tenant_id
  tags            = var.vnetcentralus_config.tags
}

module "vnet_westus" {
  source = "./networking/vnet/vnetwestus"

  resource_group_name = var.vnetwestus_config.resource_group_name
  location            = var.vnetwestus_config.location
  vnet_name           = var.vnetwestus_config.vnet_name
  address_space       = var.vnetwestus_config.address_space
  subnets             = var.vnetwestus_config.subnets

  project         = var.vnetwestus_config.project
  environment     = var.vnetwestus_config.environment
  subscription_id = var.vnetwestus_config.subscription_id
  tenant_id       = var.vnetwestus_config.tenant_id
  tags            = var.vnetwestus_config.tags
}


module "euscus_peering" {
  source = "./networking/peering/vneteuscuspeering"


  eastus_vnet_name              = module.vnet_eastus.vnet_name
  eastus_resource_group_name    = module.vnet_eastus.resource_group_name
  centralus_vnet_name           = module.vnet_centralus.vnet_name
  centralus_resource_group_name = module.vnet_centralus.resource_group_name

  subscription_id       = var.subscription_id
  tenant_id             = var.tenant_id
  vnet_eastus_vnetid    = module.vnet_eastus.vnet_id
  vnet_centralus_vnetid = module.vnet_centralus.vnet_id
}

module "euswus_peering" {
  source = "./networking/peering/vneteuswuspeering"


  eastus_vnet_name           = module.vnet_eastus.vnet_name
  eastus_resource_group_name = module.vnet_eastus.resource_group_name
  westus_vnet_name           = module.vnet_westus.vnet_name
  westus_resource_group_name = module.vnet_westus.resource_group_name

  subscription_id    = var.subscription_id
  tenant_id          = var.tenant_id
  vnet_eastus_vnetid = module.vnet_eastus.vnet_id
  vnet_westus_vnetid = module.vnet_westus.vnet_id
}


module "compute_vm" {
  source = "./compute/vm"

  subscription_id               = var.subscription_id
  tenant_id                     = var.tenant_id
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
  environment                   = var.vm_config.environment
  project                       = var.vm_config.project
  os_type                       = var.vm_config.os_type
  ssh_public_key                = file("/root/.ssh/id_rsa.pub")

  virtual_network_name = module.vnet_eastus.vnet_name
  address_space        = module.vnet_eastus.address_space
  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-computevm"
  )
  subnet_name = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-computevm"
  )
  subnet_address_prefix = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
    "subnet-computevm"
  )
}

module "aks" {
  source = "./compute/aks"

  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
  resource_group_name = var.aks_config.resource_group_name
  location            = var.aks_config.location
  dns_prefix          = var.aks_config.dns_prefix

  vnet_name    = module.vnet_eastus.vnet_name
  vnet_subnets = { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id }
  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
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
  windows_admin_password          = var.aks_config.windows_admin_password
}

module "keyvault" {
  source = "./security/keyvaults"

  resource_group_name = var.keyvault_config.resource_group_name
  location            = var.keyvault_config.location
  keyvault_name       = var.keyvault_config.keyvault_name
  sku_name            = var.keyvault_config.sku_name
  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id

  virtual_network_name = module.vnet_eastus.vnet_name
  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-keyvault"
  )
  subnet_name = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-keyvault"
  )

  subnet_address_prefixes = [lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
    "subnet-keyvault",
    "10.0.6.0/24"
  )]
  keyvault_secret_value = var.keyvault_config.keyvault_secret_value

  owner           = var.keyvault_config.owner
  admin_object_id = var.keyvault_config.admin_object_id # Added this line

  access_policies = var.keyvault_config.access_policies

  tags        = var.keyvault_config.tags
  environment = var.keyvault_config.environment
  project     = var.keyvault_config.project
}

module "vmss" {
  source = "./compute/vmscalesets"

  subscription_id = var.vmss_azure.subscription_id
  tenant_id       = var.vmss_azure.tenant_id
  location        = var.vmss_azure.location
  rg_vmss         = var.vmss_azure.resource_group
  tags            = var.vmss_azure.tags
  environment     = var.vmss_azure.environment

  vmss_name                         = var.vmss_config.name
  vmss_sku                          = var.vmss_config.sku
  vmss_instances                    = var.vmss_config.instances
  vmss_image_publisher              = var.vmss_config.image.publisher
  vmss_image_offer                  = var.vmss_config.image.offer
  vmss_image_sku                    = var.vmss_config.image.sku
  vmss_image_version                = var.vmss_config.image.version
  vmss_os_disk_storage_account_type = var.vmss_config.os_disk.storage_account_type
  vmss_os_disk_caching              = var.vmss_config.os_disk.caching
  vmss_ip_config_name               = var.vmss_config.ip_config_name
  nic_name                          = var.vmss_config.nic_name
  load_balancer_id                  = var.vmss_config.load_balancer_id
  backend_pool_id                   = var.vmss_config.backend_pool_id
  log_analytics_workspace_id        = var.vmss_config.log_analytics_workspace_id

  admin_username      = var.vmss_network.admin_username
  admin_password      = var.vmss_network.admin_password
  ssh_public_key_path = var.vmss_network.ssh_public_key_path

  vnet_name          = module.vnet_eastus.vnet_name
  vnet_address_space = module.vnet_eastus.address_space
  subnet_name        = module.vnet_eastus.vnet_subnets[2].name
  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-vmscaleset"
  )
  subnet_address_prefixes = [module.vnet_eastus.vnet_subnets[2].address_prefix]
  subnets                 = module.vnet_eastus.vnet_subnets

  public_ip_enabled                   = var.vmss_network.public_ip_enabled
  nic_ip_config_name                  = var.vmss_network.nic_ip_config_name
  nic_ip_allocation                   = var.vmss_network.nic_ip_allocation
  nsg_name                            = var.vmss_network.nsg_name
  nsg_rule_name                       = var.vmss_network.nsg_rule.name
  nsg_rule_priority                   = var.vmss_network.nsg_rule.priority
  nsg_rule_protocol                   = var.vmss_network.nsg_rule.protocol
  nsg_rule_direction                  = var.vmss_network.nsg_rule.direction
  nsg_rule_access                     = var.vmss_network.nsg_rule.access
  nsg_rule_source_address_prefix      = var.vmss_network.nsg_rule.source_address_prefix
  nsg_rule_source_port_range          = var.vmss_network.nsg_rule.source_port_range
  nsg_rule_destination_address_prefix = var.vmss_network.nsg_rule.destination_address_prefix
  nsg_rule_destination_port_range     = var.vmss_network.nsg_rule.destination_port_range
}

module "azsql" {
  source = "./databases/azsqldbs"

  project         = var.config.project
  subscription_id = var.config.subscription_id
  environment     = var.config.environment
  location        = var.config.location

  tags = var.config.tags

  sql_server_name           = var.config.sql_server_name
  sql_server_admin_username = var.config.sql_server_admin_username
  sql_server_admin_password = var.config.sql_server_admin_password

  database_names        = var.config.database_names
  sql_database_sku_name = var.config.sql_database_sku_name
  max_size_gb           = var.config.max_size_gb

  storage_account_name = var.config.storage_account_name

  log_analytics_workspace_id = var.config.log_analytics_workspace_id

  tenant_id           = var.config.tenant_id
  aad_admin_object_id = var.config.aad_admin_object_id

  admin_username = var.config.admin_username
  admin_password = var.config.admin_password

  resource_group_name = var.config.resource_group_name

  vnet_name          = module.vnet_eastus.vnet_name
  vnet_address_space = module.vnet_eastus.address_space
  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-azsqldbs"
  )
  subnet_name = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-azsqldbs"
  )
  subnet_address_prefix = [lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
    "subnet-azsqldbs"
  )]
}

module "cosmosdb" {
  source = "./databases/cosmosdb"

  subscription_id                     = var.cosmosdb_config.subscription_id
  resource_group_name                 = var.cosmosdb_config.resource_group_name
  location                            = var.cosmosdb_config.location
  environment                         = var.cosmosdb_config.environment
  owner                               = var.cosmosdb_config.owner
  project                             = var.cosmosdb_config.project
  cosmosdb_virtual_network_subnet_ids = var.cosmosdb_config.virtual_network_subnet_ids

  keyvault_name               = module.keyvault.keyvault_name
  tenant_id                   = var.tenant_id
  cosmosdb_partition_key_path = var.cosmosdb_config.partition_key_path
  access_policies = tomap({
    for policy in var.cosmosdb_config.access_policies :
    policy.tenant_id => {
      tenant_id               = policy.tenant_id
      object_id               = policy.object_id
      certificate_permissions = policy.permissions.certificates
      key_permissions         = policy.permissions.keys
      secret_permissions      = policy.permissions.secrets
    }
  })

  cosmosdb_sql_container_name = var.cosmosdb_config.sql_container_name
  cosmosdb_sql_database_name  = var.cosmosdb_config.sql_database_name
  sku_name                    = var.cosmosdb_config.sku_name

  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    var.cosmosdb_config.subnet_name,
    ""
  )

  virtual_network_name          = module.vnet_eastus.vnet_name
  virtual_network_address_space = module.vnet_eastus.address_space
  subnet_name = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-cosmosdb"
  )

  subnet_address_prefixes = [
    lookup(
      { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
      var.cosmosdb_config.subnet_name,
      "10.0.8.0/24"
    )
  ]

  tags = var.cosmosdb_config.tags
}

module "mysqldb" {
  source = "./databases/mysqldb"

  subscription_id         = var.mysqldb_config.subscription_id
  tenant_id               = var.mysqldb_config.tenant_id
  resource_group_name     = var.mysqldb_config.resource_group_name
  resource_group_location = var.mysqldb_config.resource_group_location
  location                = var.mysqldb_config.location
  environment             = var.mysqldb_config.environment
  project_name            = var.mysqldb_config.project_name
  server_name             = var.mysqldb_config.server_name
  admin_username          = var.mysqldb_config.admin_username
  admin_password          = var.mysqldb_config.admin_password
  sku_name                = var.mysqldb_config.sku_name
  mysql_version           = var.mysqldb_config.mysql_version
  mysql_server            = var.mysqldb_config.mysql_server
  mysql_server_name       = var.mysqldb_config.mysql_server_name

  vnet_name    = module.vnet_eastus.vnet_name
  vnet_subnets = { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet }

  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-mysqldb",
    null
  )

  virtual_network_id = module.vnet_eastus.vnet_id

  network_security_group_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.network_security_group_id },
    "subnet-mysqldb",
    null
  )

  start_ip_address = var.mysqldb_config.start_ip_address
  end_ip_address   = var.mysqldb_config.end_ip_address

  availability_zone         = var.mysqldb_config.availability_zone
  standby_availability_zone = var.mysqldb_config.standby_availability_zone

  storage_account_name   = var.mysqldb_config.storage_account_name
  storage_container_name = var.mysqldb_config.storage_container_name

  owner = var.mysqldb_config.owner
}

module "psqldb" {
  source = "./databases/psqldb"

  subscription_id     = var.psqldb_config.subscription_id
  tenant_id           = var.psqldb_config.tenant_id
  resource_group_name = var.psqldb_config.resource_group_name
  location            = var.psqldb_config.location
  environment         = var.psqldb_config.environment
  project_name        = var.psqldb_config.project_name
  owner               = var.psqldb_config.owner

  psql_server_name = var.psqldb_config.psql_server_name
  sku_name         = var.psqldb_config.sku_name
  admin_username   = var.psqldb_config.admin_username
  admin_password   = var.psqldb_config.admin_password

  vnet_name    = module.vnet_centralus.vnet_name
  vnet_subnets = module.vnet_centralus.vnet_subnets


  subnet_id = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-psqldb-centralus",
    null
  )

  storage_account_name   = var.psqldb_config.storage_account_name
  storage_container_name = var.psqldb_config.storage_container_name
}

module "appgw" {
  source = "./networking/appgw"

  resource_group_name = var.appgw_config.resource_group_name
  location            = var.appgw_config.location
  // Removed invalid attribute "tags"

  app_gateway_name = var.appgw_config.app_gateway_name
  // Removed invalid attribute "sku"
  // Removed invalid attribute "capacity"
  // Removed invalid attribute "tier"

  vnet_name = module.vnet_eastus.vnet_name
  backend_subnet_name = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-appgateway"
  )

  // Removed invalid attribute "ssl_certificate_name"

  frontend_ip_configuration_name = var.appgw_config.frontend_ip_configuration_name
  frontend_port_name             = var.appgw_config.frontend_port_name
  listener_name                  = var.appgw_config.listener_name

  backend_address_pool_name = var.appgw_config.backend_address_pool_name
  http_setting_name         = var.appgw_config.http_setting_name
  request_routing_rule_name = var.appgw_config.request_routing_rule_name
  public_ip_name            = var.appgw_config.public_ip_name

  vm_admin_username    = var.appgw_config.vm_admin_username
  vm_admin_password    = var.appgw_config.vm_admin_password
  nsg_name             = var.appgw_config.nsg_name
  vm_size              = var.appgw_config.vm_size
  frontend_subnet_name = var.appgw_config.frontend_subnet_name
}