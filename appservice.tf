# App Service Group Configuration Block

variable "appservice_config" {
  type = object({
    resource_group_name_prefix       = string
    resource_group_name              = string
    location                         = string
    virtual_network_name             = string
    subnet_name                      = string
    app_service_environment_v3_name  = string
    appserviceplan_name              = string
    webapp_name                      = string
    repo_url                         = string
    branch                           = string
    subscription_id                  = string
    tenant_id                        = string
    sku_code                         = string
    docker_registry_password         = string
    hosting_plan_name                = string
    docker_registry_username         = string
    docker_registry_url              = string
    environment                      = string
    owner                            = string
  })
  description = "Configuration block for App Service group settings."

  default = {
    resource_group_name_prefix       = "rg"
    resource_group_name              = "RG-APPSERVICE-WESTUS"
    location                         = "westus"
    virtual_network_name             = "vnet-dev-eastus"
    subnet_name                      = "subnet-appservice"
    app_service_environment_v3_name  = "ase-v3"
    appserviceplan_name              = "appserviceplan"
    webapp_name                      = "webapp"
    repo_url                         = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
    branch                           = "main"
    subscription_id                  = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id                        = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    sku_code                         = "B1"
    docker_registry_password         = "markv109"
    hosting_plan_name                = "appsrvplan"
    docker_registry_username         = "noknok79"
    docker_registry_url              = "https://hub.docker.com/u/noknok79"
    environment                      = "production"
    owner                            = "team@example.com"
  }
}



output "resource_group_name" {
  value = module.appservice.resource_group_name
}

output "virtual_network_name" {
  value = module.appservice.virtual_network_name
}

output "subnet_name" {
  value = module.appservice.subnet_name
}

output "webapp_docker_default_hostname" {
  value = module.appservice.webapp_docker_default_hostname
}

output "webapp_nodejs_default_hostname" {
  value = module.appservice.webapp_nodejs_default_hostname
}