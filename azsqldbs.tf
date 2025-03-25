# This Terraform configuration defines resources for an Azure SQL Database setup.
# These resources have been set in the azsqldbs.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="databases/azsqldbs/azsql.tfvars" --out="azsqldbs.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="databases/azsqldbs/azsql.tfvars" --input=false
# #2 terraform destroy -var-file="databases/azsqldbs/azsql.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>


terraform {
  required_version = ">= 1.4.6"
}

# DO NOT REMOVE THIS COMMENT BLOCK
module "azsqldbs" {
  source = "./databases/azsqldbs"


  # General configuration
  subscription_id     = var.azsqldbs_config.subscription_id
  environment         = var.azsqldbs_config.environment
  location            = var.azsqldbs_config.location
  tags                = var.azsqldbs_config.tags
  project             = var.azsqldbs_config.project
  tenant_id           = var.azsqldbs_config.tenant_id
  resource_group_name = var.azsqldbs_config.resource_group_name

  # SQL Server configuration
  sql_server_name           = var.azsqldbs_config.sql_server_name
  sql_server_admin_username = var.azsqldbs_config.sql_server_admin_username
  sql_server_admin_password = var.azsqldbs_config.sql_server_admin_password
  aad_admin_object_id       = var.azsqldbs_config.aad_admin_object_id

  # SQL Database configuration
  database_names        = var.azsqldbs_config.database_names
  sql_database_sku_name = var.azsqldbs_config.sql_database_sku_name
  max_size_gb           = var.azsqldbs_config.max_size_gb

  # Admin configuration
  admin_username = var.azsqldbs_config.admin_username
  admin_password = var.azsqldbs_config.admin_password

  # Monitoring configuration
  log_analytics_workspace_id = var.azsqldbs_config.log_analytics_workspace_id
  storage_account_name       = var.azsqldbs_config.storage_account_name
}

variable "azsqldbs_config" {
  description = "Consolidated configuration for Azure SQL Databases"
  type = object({
    # General configuration
    subscription_id     = string
    environment         = string
    location            = string
    tags                = map(string)
    project             = string
    tenant_id           = string
    resource_group_name = string

    # SQL Server configuration
    sql_server_name           = string
    sql_server_admin_username = string
    sql_server_admin_password = string
    aad_admin_object_id       = string

    # SQL Database configuration
    database_names        = list(string)
    sql_database_sku_name = string
    max_size_gb           = number

    # Admin configuration
    admin_username = string
    admin_password = string

    # Monitoring configuration
    log_analytics_workspace_id = string
    storage_account_name       = string
  })
  default = {
    # General Configuration
    environment = "dev"
    location    = "westus"

    # Tags
    tags = {
      Environment = "Development"
      Project     = "SQLServerProject"
    }

    # SQL Server Configuration
    sql_server_name           = "nokie-sql-server"
    sql_server_admin_username = "sqladmin"
    sql_server_admin_password = "P@ssw0rd123"

    # SQL Database Configuration
    database_names        = ["db1"]
    sql_database_sku_name = "S0"
    max_size_gb           = 10

    # Storage Account Configuration
    storage_account_name = "sqlstorageacctnokie"

    # Monitoring Configuration
    log_analytics_workspace_id = "test-log-analytics-workspace-id"

    # Azure Active Directory Configuration
    tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    aad_admin_object_id = "394166a3-9a96-4db9-94b7-c970f2c97b27"
    subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"

    # Admin Credentials
    admin_username = "adminuser"
    admin_password = "xQ3@mP4z!Bk8*wHy"

    # Resource Group
    resource_group_name = "rg-sql-dev-eastus"
    project             = "mssql-server-project"
  }
}

# filepath: databases/azsqldbs/outputs.tf

output "resource_group_config" {
  description = "Resource group configuration outputs"
  value = {
    resource_group_name = module.azsqldbs.resource_group_name
  }
}

output "sql_server_config" {
  description = "SQL Server configuration outputs"
  value = {
    sql_server_name = module.azsqldbs.sql_server_name
    sql_server_fqdn = module.azsqldbs.sql_server_fqdn
    firewall_rule = {
      name     = module.azsqldbs.sql_firewall_rule_name
      start_ip = module.azsqldbs.sql_firewall_start_ip
      end_ip   = module.azsqldbs.sql_firewall_end_ip
    }
  }
}

output "sql_database_config" {
  description = "SQL Database configuration outputs"
  value = {
    database_names = module.azsqldbs.sql_database_names
  }
}

output "monitoring_config" {
  description = "Monitoring and storage configuration outputs"
  value = {
    log_analytics_workspace_id = module.azsqldbs.log_analytics_workspace_id
    storage_account = {
      name                  = module.azsqldbs.storage_account_name
      primary_blob_endpoint = module.azsqldbs.primary_blob_endpoint
      primary_access_key    = module.azsqldbs.primary_access_key
    }
  }
  sensitive = true
}

output "akssqldbs_output" {
  description = "Consolidated configuration outputs for Azure SQL Databases"
  value = {
    resource_group_config = {
      resource_group_name = module.azsqldbs.resource_group_name
    }
    sql_server_config = {
      sql_server_name = module.azsqldbs.sql_server_name
      sql_server_fqdn = module.azsqldbs.sql_server_fqdn
      firewall_rule = {
        name     = module.azsqldbs.sql_firewall_rule_name
        start_ip = module.azsqldbs.sql_firewall_start_ip
        end_ip   = module.azsqldbs.sql_firewall_end_ip
      }
    }
    sql_database_config = {
      database_names = module.azsqldbs.sql_database_names
    }
    monitoring_config = {
      log_analytics_workspace_id = module.azsqldbs.log_analytics_workspace_id
      storage_account = {
        name                  = module.azsqldbs.storage_account_name
        primary_blob_endpoint = module.azsqldbs.primary_blob_endpoint
        primary_access_key    = module.azsqldbs.primary_access_key
      }
    }
  }
  sensitive = true
}
