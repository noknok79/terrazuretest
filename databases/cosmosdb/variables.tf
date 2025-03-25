# General configuration variables
variable "subscription_id" {
  description = "The subscription ID for the CosmosDB module"
  type        = string
  default     = "096534ab-9b99-4153-8505-90d030aa4f08"
}

variable "environment" {
  description = "The environment for the CosmosDB module (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The location for the CosmosDB module"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Tags for the CosmosDB module"
  type        = map(string)
  default = {
    environment = "dev",
    owner       = "team",
    project     = "cosmosdb-project"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group for the CosmosDB module"
  type        = string
  default     = "rg-database-dev"
}

# Database-specific configuration variables
variable "account_name" {
  description = "The name of the CosmosDB account"
  type        = string
  default     = "cosmosdbaccount"
}

variable "throughput" {
  description = "The throughput for the CosmosDB account (RU/s)"
  type        = number
  default     = 400
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault key for CosmosDB encryption"
  type        = string
  default     = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-keyvault-dev/providers/Microsoft.KeyVault/vaults/my-keyvault/keys/my-key"
}

variable "subnet_id" {
  description = "The ID of the subnet for CosmosDB VNet integration"
  type        = string
  default     = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/subnet-dev"
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for CosmosDB access"
  type        = list(string)
  default     = ["192.168.1.0/24", "10.0.0.0/16"] # Example CIDR blocks

  validation {
    condition     = alltrue([for ip in var.allowed_ip_ranges : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", ip))])
    error_message = "Each IP range must be a valid CIDR block (e.g., 192.168.1.0/24)."
  }
}

variable "consistency_level" {
  description = "The consistency level for the CosmosDB account"
  type        = string
  default     = "Session"
  validation {
    condition     = contains(["Eventual", "Session", "Strong", "BoundedStaleness", "ConsistentPrefix"], var.consistency_level)
    error_message = "Consistency level must be one of: Eventual, Session, Strong, BoundedStaleness, ConsistentPrefix."
  }
}

# New variables based on best practices
variable "enable_multiple_write_locations" {
  description = "Enable multiple write locations for high availability"
  type        = bool
  default     = false
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover for CosmosDB account"
  type        = bool
  default     = true
}

variable "geo_locations" {
  description = "List of geo-locations for CosmosDB account"
  type = list(object({
    location          = string
    failover_priority = number
  }))
  default = [
    { location = "East US", failover_priority = 0 },
    { location = "West US", failover_priority = 1 }
  ]
}

variable "enable_public_network" {
  description = "Enable public network access for CosmosDB account"
  type        = bool
  default     = false
}

variable "enable_serverless" {
  description = "Enable serverless mode for CosmosDB account"
  type        = bool
  default     = false
}
