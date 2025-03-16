
# Variables
variable "location" {
  description = "Azure region where resources will be created"
  default     = "East US"
}

variable "ssl_certificate_password" {
  description = "Password for the SSL certificate"
  type        = string
  sensitive   = true
}