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

# Tags
tags = {
  environment = "dev"
  owner       = "team"
}