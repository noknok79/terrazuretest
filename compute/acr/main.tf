# Specify the required Terraform version
terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

# Define the provider
provider "azurerm" {
  features {}
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
}

# Resource group for the ACR
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = var.acr_sku
  admin_enabled       = false # Disable admin user for better security

  tags = var.tags

  dynamic "georeplications" {
    for_each = var.geo_replication_locations
    content {
      location = georeplications.value
    }
  }

  depends_on = [
    azurerm_resource_group.acr_rg
  ]
}


# Virtual Network for Private Endpoint
resource "azurerm_virtual_network" "acr_vnet" {
  name                = var.vnet_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = merge(var.tags, { Purpose = "ACRPrivateEndpoint" })

  depends_on = [
    azurerm_resource_group.acr_rg
  ]
}

# Subnet for Private Endpoint
resource "azurerm_subnet" "acr_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefix

  depends_on = [
    azurerm_virtual_network.acr_vnet
  ]
}


resource "azurerm_container_registry_agent_pool" "acr_agentpool" {
  name                    = "acragentpool" # Updated name
  resource_group_name     = azurerm_resource_group.acr_rg.name
  location                = azurerm_resource_group.acr_rg.location
  container_registry_name = azurerm_container_registry.acr.name
}


resource "azurerm_container_registry_cache_rule" "cache_rule" {
  name                  = "cacherule"
  container_registry_id = azurerm_container_registry.acr.id
  target_repo           = "target"
  source_repo           = "docker.io/hello-world"
  credential_set_id     = azurerm_container_registry_credential_set.acr_credential_set.id # Added credential set
}


resource "azurerm_container_registry_credential_set" "acr_credential_set" {
  name                  = "acr-credentialset"
  container_registry_id = azurerm_container_registry.acr.id
  login_server          = "docker.io"
  identity {
    type = "SystemAssigned"
  }
  authentication_credentials {
    username_secret_id = "https://example-keyvault.vault.azure.net/secrets/example-user-name"
    password_secret_id = "https://example-keyvault.vault.azure.net/secrets/example-user-password"
  }
}

resource "azurerm_container_registry_scope_map" "azurerm_container_registry_scope_map" {
  name                    = "acr-scope-map"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.acr_rg.name
  actions = [
    "repositories/repo1/content/read",
    "repositories/repo1/content/write"
  ]

  depends_on = [
    azurerm_container_registry.acr
  ]
}

resource "azurerm_container_registry_task" "acr_task" {
  name                  = "acr-task1"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/username/repository#branch:folder" # Replace with valid URL
    context_access_token = "<github personal access token>"
    image_names          = ["helloworld:{{.Run.ID}}"]
  }
}

resource "azurerm_container_registry_task" "azurerm_container_registry_task" {
  name                  = "acr-task2"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/<user name>/acr-build-helloworld-node#main"
    context_access_token = "<github personal access token>"
    image_names          = ["helloworld:{{.Run.ID}}"]
  }
}
resource "azurerm_container_registry_task_schedule_run_now" "azurerm_container_registry_token" {
  container_registry_task_id = azurerm_container_registry_task.azurerm_container_registry_task.id
}

resource "azurerm_container_registry_token" "azurerm_container_registry_token_password" {
  name                    = "acrtoken"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.acr_rg.name
  scope_map_id            = azurerm_container_registry_scope_map.azurerm_container_registry_scope_map.id

  depends_on = [
    azurerm_container_registry_scope_map.azurerm_container_registry_scope_map
  ]
}

resource "azurerm_container_registry_token_password" "acr_token_password" {
  container_registry_token_id = azurerm_container_registry_token.azurerm_container_registry_token_password.id

  password1 {
    expiry = "2024-03-22T17:57:36+08:00" # Updated to a future date
  }

  depends_on = [
    azurerm_container_registry_token.azurerm_container_registry_token_password
  ]
}

resource "azurerm_container_registry_webhook" "acr_webhook" {
  name                = "mywebhook"
  resource_group_name = azurerm_resource_group.acr_rg.name
  registry_name       = azurerm_container_registry.acr.name
  location            = azurerm_resource_group.acr_rg.location

  service_uri = "https://mywebhookreceiver.example/mytag"
  status      = "enabled"
  scope       = "mytag:*"
  actions     = ["push"]
  custom_headers = {
    "Content-Type" = "application/json"
  }

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_resource_group.acr_rg
  ]
}