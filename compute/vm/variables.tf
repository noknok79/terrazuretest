# Variables
variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}


variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
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

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "/root/.ssh/id_rsa.pub"
}

# Add a variable for VM count
variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 1
}

# # Unused variables set to null or placeholder
# variable "project" {
#   description = "Project name"
#   type        = string
#   default     = "placeholder"
# }

# variable "node_count" {
#   description = "Number of nodes in the cluster"
#   type        = number
#   default     = 1
# }

# variable "vm_size" {
#   description = "Size of the virtual machine"
#   type        = string
#   default     = "Standard_DS1_v2"
# }

# variable "log_analytics_workspace_id" {
#   description = "Log Analytics Workspace ID"
#   type        = string
#   default     = null
# }

# variable "api_server_authorized_ip_ranges" {
#   description = "Authorized IP ranges for the API server"
#   type        = list(string)
#   default     = []
# }

# variable "admin_group_object_ids" {
#   description = "Admin group object IDs for Azure AD RBAC"
#   type        = list(string)
#   default     = []
# }
