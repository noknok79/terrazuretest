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

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "team"
  }
}

variable "vm_count" {
  description = "Number of virtual machines to deploy"
  type        = number
  default     = 1
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "/root/.ssh/id_rsa.pub"
}

# Newly added variables to fix the errors
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

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for OMS Agent"
  type        = string
}

variable "api_server_authorized_ip_ranges" {
  description = "List of IP ranges allowed to access the AKS API server"
  type        = list(string)
  # Replace with your specific IP ranges
}

variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs that will have admin access to the AKS cluster"
  type        = list(string) # Replace with actual group object IDs
}
