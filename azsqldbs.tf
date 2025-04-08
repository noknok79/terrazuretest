variable "config" {
  description = "Configuration map for all variables"
  type = object({
    project                     = string
    subscription_id             = string
    resource_group_name         = string
    environment                 = string
    location                    = string
    tags                        = map(string)
    sql_server_name             = string
    sql_server_admin_username   = string
    sql_server_admin_password   = string
    database_names              = list(string)
    sql_database_sku_name       = string
    max_size_gb                 = number
    storage_account_name        = string
    log_analytics_workspace_id  = string
    tenant_id                   = string
    aad_admin_object_id         = string
    admin_username              = string
    admin_password              = string
    vnet_address_space          = list(string)
    subnet_address_prefix       = list(string)
    subnet_name                 = string
  })

  default = {
    project         = "mssql-server-project"
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    environment     = "dev"
    location        = "westus"
    tags = {
      Environment = "Development"
      Project     = "SQLServerProject"
    }
    sql_server_name           = "nokie-sql-server"
    sql_server_admin_username = "sqladmin"
    sql_server_admin_password = "P@ssw0rd123" # Replace with a secure password
    database_names            = ["db1"]
    sql_database_sku_name     = "S0" # Valid SKU name
    max_size_gb               = 10
    storage_account_name      = "sqlstorageacctnokie"
    log_analytics_workspace_id = "test-log-analytics-workspace-id"
    tenant_id                 = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    aad_admin_object_id       = "394166a3-9a96-4db9-94b7-c970f2c97b27"
    admin_username            = "adminuser"
    admin_password            = "xQ3@mP4z!Bk8*wHy" # Replace with a secure password
    resource_group_name       = "rg-sql-dev-eastus"
    vnet_address_space        = ["10.0.0.0/16"]
    subnet_address_prefix     = ["10.0.1.0/24"]
    subnet_name               = "subnet-azsqldbs"
  }
}