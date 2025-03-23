#================================================================================================
# Used by for Backend Configuration 
#================================================================================================
variable "backend_resource_group_name" {
  description = "The name of the resource group for the Terraform backend."
  type        = string
  default     = "tfstate-rg"
}

variable "backend_storage_account_name" {
  description = "The name of the storage account for the Terraform backend."
  type        = string
  default     = "tfstatestrg1001"
}

variable "backend_container_name" {
  description = "The name of the container for the Terraform backend."
  type        = string
  default     = "tfstatecntnr1001"
}

variable "backend_key" {
  description = "The key for the Terraform state file in the backend."
  type        = string
  default     = "terraform.tfstate"
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for the provider."
  type        = string
  default     = "096534ab-9b99-4153-8505-90d030aa4f08"
}

#================================================================================================
# General Configuration
#================================================================================================
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US" # Replace with your desired default location
}

variable "project" {
  description = "Project name"
  type        = string
}

#================================================================================================
# AKS Cluster Configuration
#================================================================================================
variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
}

variable "vm_size" {
  description = "VM size for the default node pool"
  type        = string
}

#================================================================================================
# Linux Node Pool Configuration
#================================================================================================
variable "linux_node_count" {
  description = "The number of Linux nodes"
  type        = number
}

variable "linux_vm_size" {
  description = "The size of the Linux VM nodes"
  type        = string
}

#================================================================================================
# Windows Node Pool Configuration
#================================================================================================
variable "windows_node_count" {
  description = "The number of Windows nodes"
  type        = number
}

variable "windows_vm_size" {
  description = "The size of the Windows VM nodes"
  type        = string
}

#================================================================================================
# Networking Configuration
#================================================================================================
variable "api_server_authorized_ip_ranges" {
  description = "List of IP ranges allowed to access the AKS API server"
  type        = list(string)
}

variable "authorized_ip_ranges" {
  description = "The authorized IP ranges for the API server"
  type        = list(string)
}

#================================================================================================
# Azure AD Configuration
#================================================================================================
variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs that will have admin access to the AKS cluster"
  type        = list(string)
}

#================================================================================================
# Tags
#================================================================================================
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

#================================================================================================
# Monitoring Configuration
#================================================================================================
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for OMS Agent"
  type        = string
}
#================================================================================================
