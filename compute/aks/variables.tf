# Variables
variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
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

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for the AKS API server"
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for monitoring"
  type        = string
}

variable "api_server_authorized_ip_ranges" {
  description = "The authorized IP ranges for the AKS API server."
  type        = list(string)
}

variable "admin_group_object_ids" {
  description = "Admin group object IDs for Azure AD RBAC"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

# Add your variable declarations here

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
}

variable "linux_vm_size" {
  description = "The VM size for the Linux node pool."
  type        = string
}

variable "linux_node_count" {
  description = "The number of nodes in the Linux node pool."
  type        = number
}

variable "windows_vm_size" {
  description = "The VM size for the Windows node pool."
  type        = string
}

variable "windows_node_count" {
  description = "The number of nodes in the Windows node pool."
  type        = number
}
