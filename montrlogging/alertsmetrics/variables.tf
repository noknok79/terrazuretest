
# Variables
variable "location" {
  description = "Azure region where resources will be created"
  default     = "East US"
}

variable "admin_email" {
  description = "Email address for alert notifications"
  type        = string
}
