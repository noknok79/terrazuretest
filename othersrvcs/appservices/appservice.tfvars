# Default values for variables

environment = "production" # Matches the tags default value
location    = "westus"     # The Azure region for the resources
tags = {
  environment = "demo"
  project     = "appservice"
}
owner                      = "team@example.com" # The owner of the resource
resource_group_name_prefix = "rg"
resource_group_name        = "RG-APPSERVICE-WESTUS" # The name of the resource group
ase_resource_group_name    = "rg-ase"
subscription_id            = "096534ab-9b99-4153-8505-90d030aa4f08" # The Azure Subscription ID where resources will be deployed
tenant_id                  = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"

# Virtual Network Variables
vnet_name            = "vnet-dev-westus"
virtual_network_name = "vnet-dev-westus"
address_space        = ["10.2.0.0/16"]
address_prefix        = ["10.2.10.0/24"]
subnet_name          = "subnet-appservice-westus"
subnet_address       = ["10.2.10.0/24"]
ase_subnet_id        = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-ase/providers/Microsoft.Network/virtualNetworks/vnet-ase/subnets/subnet-ase"

# App Service Plan configuration
hosting_plan_name          = "appsrvplan"
appserviceplan_name        = "appserviceplan"
server_farm_resource_group = "rg-app-service"
sku_code                   = "B1"
sku_tier                   = "Basic"
app_service_plan_id        = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-app-service/providers/Microsoft.Web/serverfarms/asp-appservice-demo"

# App Service Environment Variables
ase_name                        = "ase-v3"
app_service_environment_v3_name = "ase-v3"
delegation_name                 = "Microsoft.Web/hostingEnvironments"
ilb_mode                        = "None"

# App Service (Web App) configuration
name                     = "appservice-demo"
webapp_name              = "webapp"
docker_registry_password = "markv109"
docker_registry_username = "noknok79"
docker_registry_url      = "https://hub.docker.com/u/noknok79"
repo_url                 = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
branch                   = "main"
