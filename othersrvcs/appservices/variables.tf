variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for the resources"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "app_service_environment_v3_name" {
  type        = string
  description = "The name of the App Service Environment v3 resource. The value will be randomly generated if blank."
}

variable "appserviceplan_name" {
  type        = string
  description = "The name of the App Service Plan."
}

variable "webapp_name" {
  type        = string
  description = "The name of the Linux Web App."
}

variable "repo_url" {
  type        = string
  description = "The URL of the GitHub repository to deploy code from."
}

variable "branch" {
  type        = string
  description = "The branch of the GitHub repository to deploy code from."
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID where resources will be deployed."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Tenant ID where resources will be deployed."
}

variable "sku_code" {
  type        = string
  description = "SKU code for the App Service Plan"
}

variable "docker_registry_password" {
  description = "Password for the Docker registry"
  type        = string
}

variable "hosting_plan_name" {
  description = "Name of the hosting plan"
  type        = string
}

variable "docker_registry_username" {
  description = "Username for the Docker registry"
  type        = string
}

variable "docker_registry_url" {
  description = "URL for the Docker registry"
  type        = string
}

# Add your variable declarations here

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
# Replace with your desired default value
}

variable "owner" {
  description = "The owner of the resource"
  type        = string
  
}