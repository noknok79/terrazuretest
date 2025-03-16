
# Variables
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
  default     = {
    environment = "dev"
    owner       = "team"
  }
}

variable "admin_username" {
  description = "Admin username for the SQL Server"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "start_ip_address" {
  description = "Start IP address for the SQL Server firewall rule"
  type        = string
  default     = "0.0.0.0"
}

variable "end_ip_address" {
  description = "End IP address for the SQL Server firewall rule"
  type        = string
  default     = "255.255.255.255"
}