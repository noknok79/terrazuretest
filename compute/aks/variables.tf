# Variables
variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)."
  type        = string
}

variable "project" {
  description = "The project name for tagging purposes."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
}

variable "vm_size" {
  description = "The size of the virtual machines in the default node pool."
  type        = string
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for the AKS API server"
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for monitoring"
  type        = string
}



variable "admin_group_object_ids" {
  description = "Admin group object IDs for Azure AD RBAC"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
}

variable "linux_vm_size" {
  description = "The size of the virtual machines in the Linux node pool."
  type        = string
}

variable "linux_node_count" {
  description = "The number of nodes in the Linux node pool."
  type        = number
}

variable "windows_vm_size" {
  description = "The size of the virtual machines in the Windows node pool."
  type        = string
}

variable "windows_node_count" {
  description = "The number of nodes in the Windows node pool."
  type        = number
}

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network for the AKS cluster"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the default node pool."
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "api_server_authorized_ip_ranges" {
  description = "A list of authorized IP ranges for the Kubernetes API server."
  type        = list(string)
    default     = ["203.0.113.0/24", "198.51.100.0/24"] # Replace with your IP ranges

}

variable "windows_admin_password" {
  description = "Admin password for Windows nodes"
  type        = string
  sensitive   = true
}

