# General Configuration
environment             = "dev"                    # Matches variable "environment"
location                = "centralus"                # Matches variable "location"
project_name            = "myproject"             # Matches variable "project_name"

# Subscription and Resource Group
subscription_id         = "096534ab-9b99-4153-8505-90d030aa4f08" # Matches variable "subscription_id"
tenant_id               = "0e4b57cd-89d9-4dac-853b-200a412f9d3c" # Matches variable "tenant_id"
resource_group_name     = "RG-PSQLDB"              # Matches variable "resource_group_name"
resource_group_location = "eastus"                # Matches variable "resource_group_location"

# PostgreSQL Server Configuration
sku_name                = "GP_Standard_D2ds_v4"    # Matches variable "sku_name"
psql_server_name        = "psql-server-dev"        # Matches variable "psql_server_name"
psql_version            = "14"                    # Matches variable "psql_version"
admin_username          = "adminuser"              # Matches variable "admin_username"
admin_password          = "xQ3@mP4z!Bk8*wHy"       # Matches variable "admin_password" (replace with a secure password)

# PostgreSQL Database Configuration
psql_database_name      = "mydatabase"             # Matches variable "psql_database_name"
psql_collation          = "en_US.UTF-8"            # Matches variable "psql_collation"
psql_charset            = "UTF8"                   # Matches variable "psql_charset"

# Networking Configuration
vnet_name               = "vnet-dev-eastus"        # Matches variable "vnet_name"
subnet_id               = ""                       # Matches variable "subnet_id"
virtual_network_id      = ""                       # Matches variable "virtual_network_id"
network_security_group_id = ""                     # Matches variable "network_security_group_id"

vnet_subnets = [
  {
    name           = "subnet1"
    id             = ""
    address_prefix = "10.1.0.0/24"
  }
]

# Firewall Rules
start_ip_address        = "0.0.0.0"                # Matches variable "start_ip_address"
end_ip_address          = "255.255.255.255"        # Matches variable "end_ip_address"

# Storage Configuration
storage_account_name    = "mystorageaccount"       # Matches variable "storage_account_name"
storage_container_name  = "psql-va-container"      # Matches variable "storage_container_name"

# Tagging Information
owner                   = "team@example.com"       # Matches variable "owner"

# Availability zone for the PostgreSQL Flexible Server
availability_zone       = "1"

# Standby availability zone for the PostgreSQL Flexible Server
standby_availability_zone = "2"