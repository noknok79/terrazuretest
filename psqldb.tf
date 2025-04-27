# General Configuration
variable "psqldb_config" {
  description = "Configuration for the deployment."
  type = object({
    subscription_id     = string
    tenant_id           = string
    resource_group_name = string
    location            = string
    environment         = string
    project_name        = string
    owner               = string
    psql_server_name    = string
    sku_name            = string
    admin_username      = string
    admin_password      = string
    vnet_name           = string
    vnet_subnets = list(object({
      name = string
      #id             = string
      address_prefix = string
    }))
    storage_account_name   = string
    storage_container_name = string
    subnet_id              = string
  })
  sensitive = true
  default = {
    subscription_id        = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id              = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    resource_group_name    = "RG-PSQLDB-CENTRALUS"
    location               = "centralus" # Ensure this matches the PostgreSQL server location
    environment            = "dev"
    project_name           = "myproject"
    owner                  = "team@example.com"
    psql_server_name       = "psql-server-dev"
    sku_name               = "GP_Standard_D2ds_v4"
    admin_username         = "adminuser"
    admin_password         = "xQ3@mP4z!Bk8*wHy"   # Replace with a secure password
    vnet_name              = "vnet-dev-centralus" # Update to a VNet in the correct region
    storage_account_name   = "mystorageaccount"
    storage_container_name = "psql-va-container"
    subnet_id              = ""
    vnet_subnets = [{
      name = "subnet-psqldb-centralus"
      #id             = "" 
      address_prefix = "10.1.1.0/24"
    }]
  }
}


#FOR PSQDB 
#DO NOT DELETE THIS
output "centralus_subnets_for_psqldb" {
  description = "A list of all subnets in Central US with their names and address prefixes"
  value = [
    for subnet_key, subnet in var.vnetcentralus_config.subnets : {
      name           = subnet.name
      address_prefix = subnet.address_prefix
    }
  ]
}