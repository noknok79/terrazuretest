# Variables
variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "East US" # Default from tfvars
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev" # Default from tfvars
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "aks-cluster-testing" # Default from tfvars
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1 # Default from tfvars
}

variable "vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D2s_v3" # Default from tfvars
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for the AKS API server"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default from tfvars
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for monitoring"
  type        = string
  default     = "test-log-analytics-workspace-id" # Default from tfvars
}

variable "api_server_authorized_ip_ranges" {
  description = "The authorized IP ranges for the AKS API server."
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default from tfvars
}

variable "admin_group_object_ids" {
  description = "Admin group object IDs for Azure AD RBAC"
  type        = list(string)
  default     = [
    "743472b6-0f67-4f53-bd45-a3b34a2e9fe2",
    "cecfb3fd-7113-401a-b3d2-216522cb3202"
  ] # Default from tfvars
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "aks-cluster-testing"
  } # Default from tfvars
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.30.10" # Default from tfvars
}

variable "linux_vm_size" {
  description = "The VM size for the Linux node pool."
  type        = string
  default     = "Standard_D2_v2" # Default from tfvars
}

variable "linux_node_count" {
  description = "The number of nodes in the Linux node pool."
  type        = number
  default     = 3 # Default from tfvars
}

variable "windows_vm_size" {
  description = "The VM size for the Windows node pool."
  type        = string
  default     = "Standard_D2_v2" # Default from tfvars
}

variable "windows_node_count" {
  description = "The number of nodes in the Windows node pool."
  type        = number
  default     = 2 # Default from tfvars
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "096534ab-9b99-4153-8505-90d030aa4f08" # Default from tfvars
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = "0e4b57cd-89d9-4dac-853b-200a412f9d3c" # Default from tfvars
}
