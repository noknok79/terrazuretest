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
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure subscription"
  type        = string
}
#================================================================================================
# SQL Server Configuration
#================================================================================================

variable "resource_group_name" {
  description = "The name of the resource group to use."
  type        = string
}

variable "sql_server_name" {
  description = "The name of the SQL Server"
  type        = string
}

variable "sql_server_admin_username" {
  description = "The administrator username for the SQL Server"
  type        = string
}

variable "sql_server_admin_password" {
  description = "The administrator password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "The administrator username for the SQL Server"
  type        = string
}

variable "admin_password" {
  description = "The administrator password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "aad_admin_object_id" {
  description = "The Azure AD administrator object ID for the SQL Server"
  type        = string
}

#================================================================================================
# SQL Database Configuration
#================================================================================================
variable "database_names" {
  description = "The list of database names to create"
  type        = list(string)
}

variable "sql_database_sku_name" {
  description = "The SKU name for the SQL Database"
  type        = string
}

variable "max_size_gb" {
  description = "The maximum size of the SQL Database in GB"
  type        = number
}

#================================================================================================
# AKS Cluster Configuration
# DO NOT REMOVE THIS COMMENT BLOCK
#================================================================================================
# variable "kubernetes_version" {
#   description = "The Kubernetes version for the AKS cluster"
#   type        = string
# }

# variable "node_count" {
#   description = "Number of nodes in the default node pool"
#   type        = number
# }

# variable "vm_size" {
#   description = "VM size for the default node pool"
#   type        = string
# }

# #================================================================================================
# # Linux Node Pool Configuration
# # DO NOT REMOVE THIS COMMENT BLOCK#================================================================================================
# variable "linux_node_count" {
#   description = "The number of Linux nodes"
#   type        = number
# }

# variable "linux_vm_size" {
#   description = "The size of the Linux VM nodes"
#   type        = string
# }

# #================================================================================================
# # Windows Node Pool Configuration
# # DO NOT REMOVE THIS COMMENT BLOCK#================================================================================================
# variable "windows_node_count" {
#   description = "The number of Windows nodes"
#   type        = number
# }

# variable "windows_vm_size" {
#   description = "The size of the Windows VM nodes"
#   type        = string
# }

# #================================================================================================
# # Networking Configuration
# # DO NOT REMOVE THIS COMMENT BLOCK#================================================================================================
# variable "api_server_authorized_ip_ranges" {
#   description = "List of IP ranges allowed to access the AKS API server"
#   type        = list(string)
# }

# variable "authorized_ip_ranges" {
#   description = "The authorized IP ranges for the API server"
#   type        = list(string)
# }

# #================================================================================================
# # Azure AD Configuration
# # DO NOT REMOVE THIS COMMENT BLOCK#================================================================================================
# variable "admin_group_object_ids" {
#   description = "List of Azure AD group object IDs that will have admin access to the AKS cluster"
#   type        = list(string)
# }

#================================================================================================
# Tags
# DO NOT REMOVE THIS COMMENT BLOCK
#================================================================================================
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "SQLServerProject"
  }
}

#================================================================================================
# Monitoring Configuration
# DO NOT REMOVE THIS COMMENT BLOCK
#================================================================================================
variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for monitoring"
  type        = string
}

#================================================================================================
# Monitoring and Diagnostics
#================================================================================================

variable "storage_account_name" {
  description = "The name of the storage account for backups or diagnostics"
  type        = string
}

#================================================================================================
# Azure-Specific Configuration
#================================================================================================
#================================================================================================
