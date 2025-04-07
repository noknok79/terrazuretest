# Variables
variable "project" {
  description = "The project name"
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

# Add your variable declarations here

variable "resource_group_name" {
  description = "The name of the resource group for the SQL server."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region for the resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
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

variable "database_names" {
  description = "The list of database names to create"
  type        = list(string)
}

variable "sql_database_sku_name" {
  description = "The SKU name for the Azure SQL Database"
  type        = string

  validation {
    condition = contains(
      ["Basic", "S0", "S1", "S2", "P1", "P2", "P3", "GP_S_Gen5_1",
      "GP_S_Gen5", "BC_Gen5_2", "ElasticPool"],
      var.sql_database_sku_name
    )
    error_message = "Invalid SKU name. Valid values are 'Basic', 'S0', 'S1', 'S2', 'P1', 'P2', 'P3', 'GP_S_Gen5_1', 'BC_Gen5_2', or 'ElasticPool'."
  }
}

variable "max_size_gb" {
  description = "The maximum size of the SQL Database in GB"
  type        = number
}

variable "storage_account_name" {
  description = "The name of the storage account for backups or diagnostics"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID for monitoring"
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID"
  type        = string
}

variable "aad_admin_object_id" {
  description = "The Azure AD administrator object ID for the SQL Server"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the SQL Server"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

