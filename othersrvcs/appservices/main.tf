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
  subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  skip_provider_registration = true

}

resource "random_string" "random_suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

# Create a resource group for organizing the App Service Environment resources
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
}

# Define the virtual network for the App Service Environment
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Define a subnet within the virtual network for the App Service Environment
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
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

# # Define the App Service Environment v3 resource
# resource "azurerm_app_service_environment_v3" "asev3" {
#   name                = "asev3-${random_string.random_suffix.result}"
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.subnet.id

#   internal_load_balancing_mode = "Web, Publishing"

#   cluster_setting {
#     name  = "DisableTls1.0"
#     value = "1"
#   }

#   cluster_setting {
#     name  = "InternalEncryption"
#     value = "true"
#   }

#   cluster_setting {
#     name  = "FrontEndSSLCipherSuiteOrder"
#     value = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
#   }

#   tags = {
#     env         = "production"
#     terraformed = "true"
#   }

#   depends_on = [
#     azurerm_subnet.subnet
#   ]
# }

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "appsrvplan-${random_string.random_suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.sku_code
  lifecycle {
    prevent_destroy = false
  }
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-${random_string.random_suffix.result}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true

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
  app_id                = azurerm_linux_web_app.webapp.id
  repo_url              = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch                = "main"
  use_manual_integration = true
  use_mercurial         = false

  depends_on = [
    azurerm_linux_web_app.webapp
  ]
}