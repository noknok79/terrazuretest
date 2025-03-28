variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-example"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-example"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}


variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
  default     = "096534ab-9b99-4153-8505-90d030aa4f08"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-dev-eastus"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-example"
}

variable "tags" {
  description = "Tags to associate with resources"
  type        = map(string)
  default     = {
    environment = "dev"
    owner       = "team"
  }
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "A map of subnets to create, with each subnet containing a name and address prefix"
  type = map(object({
    name           = string
    address_prefix = string
  }))
  default = {
    subnet3 = {
      name           = "subnet-akscluster"
      address_prefix = "10.0.2.0/23"
    }
    subnet4 = {
      name           = "subnet-azsqldbs"
      address_prefix = "10.0.7.0/24"
    }
    subnet5 = {
      name           = "ubnet-computevm"
      address_prefix = "10.0.8.0/23"
    }
    subnet6 = {
      name           = "subnet-vmscaleset"
      address_prefix = "10.0.9.0/2"
    }
  }
}
