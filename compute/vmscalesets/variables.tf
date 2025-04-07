variable "subscription_id" {
  description = "Azure Subscription ID"
}

# variable "client_id" {
#   description = "Azure Client ID"
# }

# variable "client_secret" {
#   description = "Azure Client Secret"
#   sensitive   = true
# }

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "rg_vmss" {
  description = "The resource group name for the VM Scale Set"
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

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key file"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "nsg_rule_name" {
  description = "The name of the NSG rule"
  type        = string
}

variable "nsg_rule_priority" {
  description = "The priority of the NSG rule"
  type        = number
}

variable "nsg_rule_direction" {
  description = "The direction of the NSG rule"
  type        = string
}

variable "nsg_rule_access" {
  description = "The access type of the NSG rule"
  type        = string
}

variable "nsg_rule_protocol" {
  description = "The protocol for the NSG rule"
  type        = string
}

variable "nsg_rule_source_port_range" {
  description = "The source port range for the NSG rule"
  type        = string
}

variable "nsg_rule_destination_port_range" {
  description = "The destination port range for the NSG rule"
  type        = string
}

variable "nsg_rule_source_address_prefix" {
  description = "The source address prefix for the NSG rule"
  type        = string
}

variable "nsg_rule_destination_address_prefix" {
  description = "The destination address prefix for the NSG rule"
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

variable "nic_ip_config_name" {
  description = "The name of the NIC IP configuration"
  type        = string
}

variable "nic_ip_allocation" {
  description = "The IP allocation method for the NIC"
  type        = string
}

variable "vmss_name" {
  description = "The name of the virtual machine scale set"
  type        = string
}

variable "vmss_sku" {
  description = "The SKU for the virtual machine scale set"
  type        = string
}

variable "vmss_instances" {
  description = "The number of instances in the virtual machine scale set"
  type        = number
}

variable "vmss_image_publisher" {
  description = "The publisher of the VMSS image"
  type        = string
}

variable "vmss_image_offer" {
  description = "The offer of the VMSS image"
  type        = string
}

variable "vmss_image_sku" {
  description = "The SKU of the VMSS image"
  type        = string
}

variable "vmss_image_version" {
  description = "The version of the VMSS image"
  type        = string
}

variable "vmss_os_disk_caching" {
  description = "The caching type for the VMSS OS disk"
  type        = string
}

variable "vmss_os_disk_storage_account_type" {
  description = "The storage account type for the VMSS OS disk"
  type        = string
}

variable "vmss_ip_config_name" {
  description = "The name of the IP configuration for the VMSS network interface"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "public_ip_enabled" {
  description = "Enable public IP for the VM Scale Set"
  type        = bool
}

variable "load_balancer_id" {
  description = "The ID of the load balancer"
  type        = string
}

variable "backend_pool_id" {
  description = "The ID of the backend pool"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  type        = string
}

# Add your variable declarations here

variable "vmss_nic_name" {
  description = "The name of the network interface for the VM scale set"
  type        = string
  default     = "vmss-nic"
}