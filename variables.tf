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