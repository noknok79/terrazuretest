variable "mysqldb_config" {
  description = "Configuration for the MySQL database module"
  type = object({
    subscription_id             = string
    resource_group_name         = string
    resource_group_location     = string
    location                    = string
    environment                 = string
    project_name                = string
    server_name                 = string
    admin_username              = string
    admin_password              = string
    sku_name                    = string
    mysql_version               = string
    storage_mb                  = number
    backup_retention_days       = number
    geo_redundant_backup        = bool
    ssl_enforcement             = string
    subnet_name                 = string
    subnet_id                   = string
    virtual_network_id          = string
    network_security_group_id   = string
    firewall_rules              = map(object({
      start_ip = string
      end_ip   = string
    }))
    tags                        = map(string)
    vnet_name                   = string
    mysql_server                = string
    mysql_server_name           = string
    availability_zone           = string
    standby_availability_zone   = string
    storage_account_name        = string
    storage_container_name      = string
    tenant_id                   = string
    start_ip_address            = string
    end_ip_address              = string
    owner                       = string
   
  })

  default = {
    subscription_id             = "096534ab-9b99-4153-8505-90d030aa4f08"
    resource_group_name         = "RG-MYSQLDB"
    resource_group_location     = "eastus2"
    location                    = "eastus2"
    environment                 = "dev"
    project_name                = "myproject"
    server_name                 = "mysql-server-dev"
    admin_username              = "adminuser"
    admin_password              = "xQ3@mP4z!Bk8*wHy" # Replace with a secure password
    sku_name                    = "GP_Standard_D2ds_v4"
    mysql_version               = "8.0"
    storage_mb                  = 5120
    backup_retention_days       = 7
    geo_redundant_backup        = false
    ssl_enforcement             = "Enabled"
    subnet_name                 = "vnet-dev-eastus"
    subnet_id                   = ""
    virtual_network_id          = ""
    network_security_group_id   = ""
  
    firewall_rules = {
      default = {
        start_ip = "0.0.0.0"
        end_ip   = "255.255.255.255"
      }
    }
    tags = {
      owner = "team@example.com"
    }
    vnet_name                   = "vnet-dev-eastus"
    mysql_server                = "mysql-server-dev"
    mysql_server_name           = "mysql-server-dev"
    availability_zone           = "1"
    standby_availability_zone   = "2"
    storage_account_name        = "mystorageaccount"
    storage_container_name      = "sql-va-container"
    tenant_id                   = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    start_ip_address            = "0.0.0.0"
    end_ip_address              = "255.255.255.255"
    owner                       = "team@example.com"
  }
}