terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
}

provider "azurerm" {
  alias = "vnet_eastus"
  subscription_id           = var.subscription_id
  tenant_id                = var.tenant_id
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "vnet_centralus"
  subscription_id           = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "peering"
  subscription_id           = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "cosmosdb"
  subscription_id = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                     = "aksazure"
  subscription_id           = var.subscription_id
  tenant_id                 = var.tenant_id
  features {
    # resource_group {
    #   prevent_deletion_if_contains_resources = false
    # }
  }
  skip_provider_registration = true 
}

provider "azurerm" {
  alias = "compute"
  subscription_id = var.subscription_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "keyvault"
  subscription_id = var.subscription_id
    tenant_id               = var.tenant_id

  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
# }
# # Resource Group for VNet
# provider "azurerm" {
#   alias           = "vmss"
#   subscription_id = var.subscription_id
#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#   }
# }

# provider "azurerm" {
#   alias = "mysqldb"
#   subscription_id = var.subscription_id
#   skip_provider_registration = true

#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#   }
# }

provider "azurerm" {
  alias = "psqldb"
  subscription_id           = var.subscription_id
  tenant_id                 = var.tenant_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
# VNet Module
module "vnet_eastus" {
  source = "./networking/vnet/vneteastus"

  providers = {
    azurerm = azurerm.vnet_eastus
  }

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

  providers = {
    azurerm = azurerm.vnet_centralus
  }

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

module "vnet_peering" {
  source = "./networking/vnet/peering"

  providers = {
    azurerm = azurerm.peering
  }

  eastus_vnet_name             = module.vnet_eastus.vnet_name
  eastus_resource_group_name   = module.vnet_eastus.resource_group_name
  centralus_vnet_name          = module.vnet_centralus.vnet_name
  centralus_resource_group_name = module.vnet_centralus.resource_group_name

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  vnet_eastus_vnetid = module.vnet_eastus.vnet_id
  vnet_centralus_vnetid = module.vnet_centralus.vnet_id
  #depends_on = [ module.vnet_eastus, module.vnet_centralus ]

}

  #  subnet5 = {
  #       name           = "subnet-computevm"
  #       address_prefix = "10.0.8.0/24"
  #     }
# Compute VM Module
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
  environment                   = var.vm_config.environment
  project                       = var.vm_config.project
  os_type                       = var.vm_config.os_type
  ssh_public_key                = file("/root/.ssh/id_rsa.pub")

  # Networking Configuration
  # Networking Configuration
  virtual_network_name  = module.vnet_eastus.vnet_name
  address_space         = module.vnet_eastus.address_space
  subnet_id             = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-computevm"
  )
  subnet_name           = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-computevm"
  )
  subnet_address_prefix = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
    "subnet-computevm"
  )
}

#     # subnet3 = {
#     #     name           = "subnet-akscluster"
#     #     address_prefix = "10.0.2.0/24"
#     #   }
      
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
  
  vnet_name  = module.vnet_eastus.vnet_name
  subnet_id  = lookup(
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
}


#     #  subnet7 = {
#     #     name           = "subnet-keyvault"
#     #     address_prefix = "10.0.6.0/24"
#     #   }
# # Key Vault Module
# # Key Vault Module
module "keyvault" {
  source = "./security/keyvaults"

  resource_group_name   = var.keyvault_config.resource_group_name
  location              = var.keyvault_config.location
  keyvault_name         = var.keyvault_config.keyvault_name
  sku_name              = var.keyvault_config.sku_name
  # tenant_id attribute removed as it is not valid here
  subscription_id       = var.subscription_id
  tenant_id             = var.tenant_id # Added tenant_id argument

  # Networking Configuration
   virtual_network_name  = module.vnet_eastus.vnet_name
  subnet_id             = lookup(
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
  "10.0.6.0/24" # Updated to a non-overlapping range
)]

  owner                 = var.keyvault_config.owner

  # Access Policies
  access_policies = var.keyvault_config.access_policies

  # Tags and Metadata
  tags        = var.keyvault_config.tags
  environment = var.keyvault_config.environment
  project     = var.keyvault_config.project
}



#       # subnet6 = {
#       #   name           = "subnet-vmscaleset"
#       #   address_prefix = "10.0.9.0/24"
#       # }
# # VMSS Module
# module "vmss" {
#   source = "./compute/vmscalesets"

#   providers = {
#     azurerm = azurerm.vmss
#   }

#   # Azure Configuration
#   subscription_id                  = var.vmss_azure.subscription_id
#   tenant_id                        = var.vmss_azure.tenant_id
#   location                         = var.vmss_azure.location
#   rg_vmss                          = var.vmss_azure.resource_group
#   tags                             = var.vmss_azure.tags
#   environment                      = var.vmss_azure.environment

#   # VM Scale Set Configuration
#   vmss_name                        = var.vmss_config.name
#   vmss_sku                         = var.vmss_config.sku
#   vmss_instances                   = var.vmss_config.instances
#   vmss_image_publisher             = var.vmss_config.image.publisher
#   vmss_image_offer                 = var.vmss_config.image.offer
#   vmss_image_sku                   = var.vmss_config.image.sku
#   vmss_image_version               = var.vmss_config.image.version
#   vmss_os_disk_storage_account_type = var.vmss_config.os_disk.storage_account_type
#   vmss_os_disk_caching             = var.vmss_config.os_disk.caching
#   vmss_ip_config_name              = var.vmss_config.ip_config_name
#   nic_name                         = var.vmss_config.nic_name
#   load_balancer_id                 = var.vmss_config.load_balancer_id
#   backend_pool_id                  = var.vmss_config.backend_pool_id
#   log_analytics_workspace_id       = var.vmss_config.log_analytics_workspace_id

#   # Networking Configuration
#   admin_username                   = var.vmss_network.admin_username
#   admin_password                   = var.vmss_network.admin_password
#   ssh_public_key_path              = var.vmss_network.ssh_public_key_path
  
#   vnet_name                        = module.vnet_eastus.vnet_name
#   vnet_address_space               = module.vnet_eastus.address_space
#   subnet_name                      = module.vnet_eastus.vnet_subnets[2].name # Assuming subnet5 is the third element
#   subnet_id                        = lookup(
#     { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
#     "subnet-vmscaleset"
#   )
#   subnet_address_prefixes          = [module.vnet_eastus.vnet_subnets[2].address_prefix] # Assuming subnet5 is the third element
  
#   public_ip_enabled                = var.vmss_network.public_ip_enabled
#   nic_ip_config_name               = var.vmss_network.nic_ip_config_name
#   nic_ip_allocation                = var.vmss_network.nic_ip_allocation
#   nsg_name                         = var.vmss_network.nsg_name
#   nsg_rule_name                    = var.vmss_network.nsg_rule.name
#   nsg_rule_priority                = var.vmss_network.nsg_rule.priority
#   nsg_rule_protocol                = var.vmss_network.nsg_rule.protocol
#   nsg_rule_direction               = var.vmss_network.nsg_rule.direction
#   nsg_rule_access                  = var.vmss_network.nsg_rule.access
#   nsg_rule_source_address_prefix   = var.vmss_network.nsg_rule.source_address_prefix
#   nsg_rule_source_port_range       = var.vmss_network.nsg_rule.source_port_range
#   nsg_rule_destination_address_prefix = var.vmss_network.nsg_rule.destination_address_prefix
#   nsg_rule_destination_port_range  = var.vmss_network.nsg_rule.destination_port_range
# }

#   #  subnet4 = {
#   #       name           = "subnet-azsqldbs"
#   #       address_prefix = "10.0.7.0/24"
#   #     }

# # Azure SQL Module
# module "azsql" {
#   source = "./databases/azsqldbs"
 

#   # General Configuration
#   project         = var.config.project
#   subscription_id = var.config.subscription_id
#   environment     = var.config.environment
#   location        = var.config.location

#   # Tags
#   tags = var.config.tags

#   # SQL Server Configuration
#   sql_server_name           = var.config.sql_server_name
#   sql_server_admin_username = var.config.sql_server_admin_username
#   sql_server_admin_password = var.config.sql_server_admin_password

#   # SQL Database Configuration
#   database_names        = var.config.database_names
#   sql_database_sku_name = var.config.sql_database_sku_name
#   max_size_gb           = var.config.max_size_gb

#   # Storage Account Configuration
#   storage_account_name = var.config.storage_account_name

#   # Monitoring Configuration
#   log_analytics_workspace_id = var.config.log_analytics_workspace_id

#   # Azure Active Directory Configuration
#   tenant_id           = var.config.tenant_id
#   aad_admin_object_id = var.config.aad_admin_object_id

#   # Admin Credentials
#   admin_username = var.config.admin_username
#   admin_password = var.config.admin_password

#   # Resource Group
#   resource_group_name = var.config.resource_group_name

#   # Networking Configuration
#   vnet_name             = module.vnet_eastus.vnet_name
#   vnet_address_space    = module.vnet_eastus.address_space
#   subnet_id             = lookup(
#     { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
#     "subnet-azsqldbs"
#   )
#   subnet_name           = lookup(
#     { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
#     "subnet-azsqldbs"
#   )
#   subnet_address_prefix = [lookup(
#     { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
#     "subnet-azsqldbs"
#   )]
# }


#   # subnet5 = {
#   #       name           = "subnet-cosmosdb"
#   #       address_prefix = "10.0.8.0/24"
#   #     }
# # Cosmos DB Module
# # Cosmos DB Module
module "cosmosdb" {
  source = "./databases/cosmosdb"

  # General Configuration
  subscription_id     = var.cosmosdb_config.subscription_id
  resource_group_name = var.cosmosdb_config.resource_group_name
  location            = var.cosmosdb_config.location
  environment         = var.cosmosdb_config.environment
  owner               = var.cosmosdb_config.owner
  project             = var.cosmosdb_config.project
  # cosmosdb_partition_key_path = var.cosmosdb_config.partition_key_path

  # Required Arguments
  keyvault_name                = module.keyvault.keyvault_name
  tenant_id                    = var.tenant_id
  cosmosdb_partition_key_path  = var.cosmosdb_config.partition_key_path
  access_policies = tomap({
    for policy in var.cosmosdb_config.access_policies : 
    policy.tenant_id => {
      tenant_id              = policy.tenant_id
      object_id              = policy.object_id
      certificate_permissions = policy.permissions.certificates
      key_permissions         = policy.permissions.keys
      secret_permissions      = policy.permissions.secrets
    }
  })
  
  cosmosdb_sql_container_name  = var.cosmosdb_config.sql_container_name
  cosmosdb_sql_database_name   = var.cosmosdb_config.sql_database_name
  sku_name                     = var.cosmosdb_config.sku_name

  # Networking Configuration
  subnet_id                    = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    var.cosmosdb_config.subnet_name,
    ""
  )

  virtual_network_name           = module.vnet_eastus.vnet_name
  virtual_network_address_space  = module.vnet_eastus.address_space
  subnet_name                    = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name },
    "subnet-cosmosdb"
  )

  subnet_address_prefixes        = [
    lookup(
      { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix },
      var.cosmosdb_config.subnet_name,
      "10.0.8.0/24" # Default value to avoid null
    )
  ]

  # Tags
  tags = var.cosmosdb_config.tags
}




      # subnet9 = {
      #   name           = "subnet-mysqldb"
      #   address_prefix = "10.0.10.0/24"
      # }
# # MySQL DB Module
# # MySQL DB Module
module "mysqldb" {
  source = "./databases/mysqldb"

  # General Configuration
  subscription_id             = var.mysqldb_config.subscription_id
  tenant_id                   = var.mysqldb_config.tenant_id
  resource_group_name         = var.mysqldb_config.resource_group_name
  resource_group_location     = var.mysqldb_config.resource_group_location
  location                    = var.mysqldb_config.location
  environment                 = var.mysqldb_config.environment
  project_name                = var.mysqldb_config.project_name
  server_name                 = var.mysqldb_config.server_name
  admin_username              = var.mysqldb_config.admin_username
  admin_password              = var.mysqldb_config.admin_password
  sku_name                    = var.mysqldb_config.sku_name
  mysql_version               = var.mysqldb_config.mysql_version
  mysql_server                = var.mysqldb_config.mysql_server
  mysql_server_name           = var.mysqldb_config.mysql_server_name

  # Networking Configuration
  vnet_name                   = module.vnet_eastus.vnet_name
  subnet_id                   = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.id },
    "subnet-mysqldb"
  )
  virtual_network_id          = module.vnet_eastus.vnet_id
  network_security_group_id   = lookup(
    { for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.network_security_group_id },
    "subnet-mysqldb",
    null
  )

  start_ip_address            = var.mysqldb_config.start_ip_address
  end_ip_address              = var.mysqldb_config.end_ip_address

  # Availability Zones
  availability_zone           = var.mysqldb_config.availability_zone
  standby_availability_zone   = var.mysqldb_config.standby_availability_zone

  # Storage Configuration
  storage_account_name        = var.mysqldb_config.storage_account_name
  storage_container_name      = var.mysqldb_config.storage_container_name
  # storage_account_id          = var.mysqldb_config.storage_account_id

  # Tags and Metadata
  owner                       = var.mysqldb_config.owner
}

#PostgreSQL DB Module
module "psqldb" {
  source = "./databases/psqldb"
 
  # providers = {
  #   azurerm = azurerm.psqldb
  # }
  # General Configuration
  subscription_id       = var.psqldb_config.subscription_id
  tenant_id             = var.psqldb_config.tenant_id
  resource_group_name   = var.psqldb_config.resource_group_name
  location              = var.psqldb_config.location
  environment           = var.psqldb_config.environment
  project_name          = var.psqldb_config.project_name
  owner                 = var.psqldb_config.owner

  # PostgreSQL Server Configuration
  psql_server_name      = var.psqldb_config.psql_server_name
  sku_name              = var.psqldb_config.sku_name
  admin_username        = var.psqldb_config.admin_username
  admin_password        = var.psqldb_config.admin_password

  #Networking Configuration
   # Networking Configuration
  vnet_name             = module.vnet_centralus.vnet_name
  vnet_subnets          = module.vnet_centralus.subnets
    subnet_id             = lookup(
    { for subnet in module.vnet_centralus.subnets : subnet.name => subnet.id },
    "subnet-psqldb-centralus",
    null
  )

  
  storage_account_name  = var.psqldb_config.storage_account_name
  storage_container_name = var.psqldb_config.storage_container_name
}

