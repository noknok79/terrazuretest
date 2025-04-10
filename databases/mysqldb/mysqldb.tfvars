# General Configuration
environment             = "dev"                    # Matches variable "environment"
location                = "eastus2"                # Matches variable "location"
project_name            = "myproject"             # Matches variable "project_name"

# Subscription and Resource Group
subscription_id         = "096534ab-9b99-4153-8505-90d030aa4f08"
resource_group_name     = "RG-MYSQLDB"             # Matches variable "resource_group_name"
resource_group_location = "eastus2"                # Matches variable "resource_group_location"

# MySQL Server Configuration
sku_name                = "GP_Standard_D2ds_v4"        # Matches variable "sku_name"
server_name             = "mysql-server-dev"       # Matches variable "server_name"
admin_username          = "adminuser"              # Matches variable "admin_username"
admin_password          = "xQ3@mP4z!Bk8*wHy"       # Matches variable "admin_password" (replace with a secure password)

# MySQL Database Configuration
mysql_database_name     = "mydatabase"             # Matches variable "mysql_database_name"
mysql_collation         = "utf8_general_ci"        # Matches variable "mysql_collation"
mysql_charset           = "utf8"                   # Matches variable "mysql_charset"

# Networking Configuration
vnet_name               = "vnet-dev-eastus"        # Matches variable "vnet_name"
subnet_id               = ""                       # Matches variable "subnet_id"
virtual_network_id      = ""                       # Matches variable "virtual_network_id"
network_security_group_id = ""                     # Matches variable "network_security_group_id"

# Firewall Rules
start_ip_address        = "0.0.0.0"                # Matches variable "start_ip_address"
end_ip_address          = "255.255.255.255"        # Matches variable "end_ip_address"

# Tagging Information
owner                   = "team@example.com"       # Matches variable "owner"