terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id            = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id                  = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  skip_provider_registration = true

}

resource "random_string" "unique_suffix" {
  length  = 6
  special = false
  upper   = false
}
# Create a resource group for organizing the App Service Environment resources
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
}

# Define the virtual network for the App Service Environment
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Define a subnet within the virtual network for the App Service Environment
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/hostingEnvironments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "appsrvplan-${random_string.unique_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_code
  lifecycle {
    prevent_destroy = false
  }
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp_nodejs" {
  name                = "webapp-${random_string.unique_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "16-lts"
    }
  }

  depends_on = [
    azurerm_service_plan.appserviceplan
  ]
}

# Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id                 = azurerm_linux_web_app.webapp_nodejs.id
  repo_url               = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch                 = "main"
  use_manual_integration = true
  use_mercurial          = false

  depends_on = [
    azurerm_linux_web_app.webapp_nodejs
  ]
}

# App Service (Web App) with Docker
resource "azurerm_linux_web_app" "webapp_docker" {
  name                = "webapp-docker-${random_string.unique_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  https_only          = true
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  app_settings = {
    WEBSITES_PORT                       = "80"                                # Specify the port your container listens on
    DOCKER_CUSTOM_IMAGE_NAME            = "noknok79/eshopwebmvc:latest"       # Replace with your Docker image and tag
    DOCKER_REGISTRY_SERVER_URL          = "https://hub.docker.com/u/noknok79" # Replace with your registry URL
    DOCKER_REGISTRY_SERVER_USERNAME     = "noknok79"                          # Replace with your registry username
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.docker_registry_password        # Use a secure variable for the password
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"                             # Disable persistent storage for Docker containers
  }

  site_config {
    minimum_tls_version = "1.2" # Ensure secure TLS version
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_service_plan.appserviceplan
  ]
}