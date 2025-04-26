variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group. If not provided, it will be generated using the prefix and a random suffix."
}

variable "location" {
  type        = string
  description = "Location of the resource group and resources."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network resource. The value will be randomly generated if blank."
}

variable "subnet_name" {
  type        = string
  description = "The name of the virtual network subnet. The value will be randomly generated if blank."
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
  description = "The SKU code for the App Service Plan."
  
}