variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "RG-vnet-dev-eastus" # Default resource group name
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "East US" # Default Azure region
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "compute-vm-dev" # Default prefix for resource names
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2" # Default VM size
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureadmin" # Default admin username
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
  default     = "xQ3@mP4z!Bk8*wHy" # Default admin password (replace in production)
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS" # Default storage account type
}

variable "image_reference" {
  description = "The image reference for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  } # Default image reference for Ubuntu Server
}

variable "linux_custom_script_command" {
  description = "Custom script command for Linux VMs"
  type        = string
  default     = "echo 'Hello, Linux VM!'" # Default Linux custom script command
}

variable "windows_custom_script_command" {
  description = "Custom script command for Windows VMs"
  type        = string
  default     = "echo 'Hello, Windows VM!'" # Default Windows custom script command
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-dev-eastus" # Default virtual network name
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet-computevm" # Default subnet name
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"] # Default address space
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24" # Default subnet address prefix
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "team"
  } # Default tags
}

variable "os_type" {
  description = "The operating system type of the VM (Linux or Windows)"
  type        = string
  default     = "Linux" # Change to "Windows" for Windows VMs
}

variable "ssh_public_key" {
  description = "The SSH public key for the virtual machine"
  type        = string
}

