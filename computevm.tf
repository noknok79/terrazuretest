variable "vm_config" {
  description = "Configuration for the virtual machine and related resources"
  type = object({
    resource_group_name    = string
    location               = string
    prefix                 = string
    vm_size                = string
    admin_username         = string
    admin_password         = string
    windows_admin_password = string # Added Windows admin password variable

    os_disk_storage_account_type = string
    image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    linux_custom_script_command   = string
    windows_custom_script_command = string
    virtual_network_name          = string
    subnet_name                   = string
    address_space                 = list(string)
    subnet_address_prefix         = string
    subnet_id                     = string
    tags                          = map(string)
    environment                   = string
    project                       = string
    os_type                       = string
    ssh_public_key                = string # Added SSH public key variable
  })
  default = {
    resource_group_name    = "RG-COMPUTE"
    location               = "East US"
    prefix                 = "compute-dev"
    vm_size                = "Standard_DS1_v2"
    admin_username         = "azureadmin"
    admin_password         = "xQ3@mP4z!Bk8*wHy"
    windows_admin_password = "xQ3@mP4z!Bk8*wHy" # Default value for Windows admin password

    os_disk_storage_account_type = "Standard_LRS"
    image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    linux_custom_script_command   = "echo 'Hello, Linux VM!'"
    windows_custom_script_command = "echo 'Hello, Windows VM!'"
    virtual_network_name          = "vnet-dev-eastus"
    subnet_name                   = "subnet-computevm"
    address_space                 = ["10.0.0.0/16"]
    subnet_address_prefix         = "10.0.1.0/24"
    subnet_id                     = ""
    tags = {
      environment = "dev"
      owner       = "team"
    }
    environment    = "dev"
    project        = "compute-project-testing"
    os_type        = "Linux"
    ssh_public_key = "" # Leave this empty; it will be set dynamically
    # Reads the SSH public key from the file
  }
}


### DO NOT DELETE THIS COMMENT ###
output "vm_subnet_name" {
  description = "The name of a specific subnet (e.g., subnet5)"
  value       = module.vnet_eastus.vnet_subnets[2].name # Assuming subnet5 is the third element
}

### DO NOT DELETE THIS COMMENT ###
output "vm_subnet_address_prefix" {
  description = "The address prefix of a specific subnet (e.g., subnet5)"
  value       = module.vnet_eastus.vnet_subnets[2].address_prefix # Assuming subnet5 is the third element
}


output "vm_id" {
  description = "The ID of the created virtual machine"
  value       = module.compute_vm.vm_id
}

output "vm_name" {
  description = "The name of the created virtual machine"
  value       = module.compute_vm.vm_name
}

output "vm_private_ip" {
  description = "The private IP address of the virtual machine"
  value       = module.compute_vm.private_ip
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine (if applicable)"
  value       = module.compute_vm.public_ip
}

output "vm_subnet_address_prefixes" {
  description = "A map of subnet names to their address prefixes"
  value = {
    for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.address_prefix
  }
}

output "vm_subnet_names" {
  description = "A map of subnet names to their names"
  value = {
    for subnet in module.vnet_eastus.vnet_subnets : subnet.name => subnet.name
  }
}

