# General Configuration
project         = "mssql-server-project"
subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
environment     = "dev"
location        = "westus"

# Tags
tags = {
  Environment = "Development"
  Project     = "SQLServerProject"
}

# SQL Server Configuration
sql_server_name           = "nokie-sql-server"
sql_server_admin_username = "sqladmin"
sql_server_admin_password = "P@ssw0rd123" # Replace with a secure password

# SQL Database Configuration
database_names        = ["db1"]
sql_database_sku_name = "S0" # Valid SKU name
max_size_gb           = 10

# Storage Account Configuration
storage_account_name = "sqlstorageacctnokie"

# Monitoring Configuration
log_analytics_workspace_id = "test-log-analytics-workspace-id"

# Azure Active Directory Configuration
tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
aad_admin_object_id = "394166a3-9a96-4db9-94b7-c970f2c97b27"

# Admin Credentials
admin_username = "adminuser"
admin_password = "xQ3@mP4z!Bk8*wHy" # Replace with a secure password

# Resource Group

# Networking Configuration
vnet_address_space    = ["10.0.0.0/16"]
subnet_address_prefix = ["10.0.1.0/24"]
vnet_name             = "vnet-sql-dev" # Add the required vnet_name variable
subnet_id             = "placehoder"   # Add the required subnet_id variable
subnet_name           = "subnet-azsqldbs"
resource_group_name   = "RG-AZSQLDBS" # Add the required resource_group_name variable