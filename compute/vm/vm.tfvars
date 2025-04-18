subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
# Resource Group and Location
resource_group_name = "rg-vm-dev"
location            = "East US"

# Virtual Machine Configuration
prefix              = "compute-vm-dev"
vm_size             = "Standard_DS1_v2"
admin_username      = "azureadmin"
admin_password      = "xQ3@mP4z!Bk8*wHy"

# OS Disk Configuration
os_disk_storage_account_type = "Standard_LRS"

# Image Reference
image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "latest"
}

# Custom Script Commands
linux_custom_script_command   = "echo 'Hello, Linux VM!'"
windows_custom_script_command = "echo 'Hello, Windows VM!'"

# Networking Configuration
virtual_network_name = "vnet-dev-eastus"
subnet_name          = "subnet-computevm"
address_space        = ["10.0.0.0/16"]
subnet_address_prefix = "10.0.1.0/24"

# Required Variables
os_type        = "Linux" # Set to "Linux" or "Windows"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr..." # Replace with your SSH public key
subnet_id      = ""
environment    = "dev"
project        = "my-project"

# Tags
tags = {
  environment = "dev"
  owner       = "team"
}