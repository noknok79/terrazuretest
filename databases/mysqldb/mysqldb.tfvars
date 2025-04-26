# General Configuration
environment  = "dev"       # Matches variable "environment"
location     = "eastus2"   # Matches variable "location"
project_name = "myproject" # Matches variable "project_name"

# Subscription and Resource Group
subscription_id         = "096534ab-9b99-4153-8505-90d030aa4f08" # Matches variable "subscription_id"
tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c" # Matches variable "tenant_id"
resource_group_name     = "RG-MYSQLDB"                           # Matches variable "resource_group_name"
resource_group_location = "eastus2"                              # Matches variable "resource_group_location"

# MySQL Server Configuration
sku_name          = "GP_Standard_D2ds_v4" # Matches variable "sku_name"
server_name       = "mysql-server-dev"    # Matches variable "server_name"
mysql_server_name = "mysql-server-dev"    # Matches variable "mysql_server_name"
mysql_version     = "8.0"                 # Matches variable "mysql_version"
mysql_server      = "mysql-server-dev"    # Matches variable "mysql_server"
admin_username    = "adminuser"           # Matches variable "admin_username"
admin_password    = "xQ3@mP4z!Bk8*wHy"    # Matches variable "admin_password" (replace with a secure password)

# MySQL Database Configuration
mysql_database_name = "mydatabase"      # Matches variable "mysql_database_name"
mysql_collation     = "utf8_general_ci" # Matches variable "mysql_collation"
mysql_charset       = "utf8"            # Matches variable "mysql_charset"

# CosmosDB Configuration
cosmosdb_sql_container_name = "mycontainer"       # Matches variable "cosmosdb_sql_container_name"
cosmosdb_account_name       = "mycosmosdbaccount" # Matches variable "cosmosdb_account_name"
cosmosdb_sql_database_name  = "mycosmosdb"        # Matches variable "cosmosdb_sql_database_name"
cosmosdb_partition_key_path = "/mypartitionkey"   # Matches variable "cosmosdb_partition_key_path"

# Networking Configuration
vnet_name                 = "vnet-dev-eastus" # Matches variable "vnet_name"
subnet_id                 = ""                # Matches variable "subnet_id"
virtual_network_id        = ""                # Matches variable "virtual_network_id"
network_security_group_id = ""                # Matches variable "network_security_group_id"

# Firewall Rules
start_ip_address = "0.0.0.0"         # Matches variable "start_ip_address"
end_ip_address   = "255.255.255.255" # Matches variable "end_ip_address"

# Storage Configuration
storage_account_name   = "mystorageaccount" # Matches variable "storage_account_name"
storage_container_name = "sql-va-container" # Matches variable "storage_container_name"

# Tagging Information
owner = "team@example.com" # Matches variable "owner"
# Availability zone for the MySQL Flexible Server
availability_zone = "1"

# Standby availability zone for the MySQL Flexible Server
standby_availability_zone = "2"

vnet_subnets = {
  subnet-mysqldb = {
    id                        = ""
    network_security_group_id = ""
  }
  subnet-app = {
    id                        = ""
    network_security_group_id = ""
  }
}