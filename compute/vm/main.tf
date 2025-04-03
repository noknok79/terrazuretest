terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  alias = "compute"
  features        {}
  subscription_id = var.subscription_id
}



resource "azurerm_resource_group" "vm_rg" {
  name =  var.resource_group_name
  #name     = "rg-vm-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}


# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnet_address_prefix]
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  depends_on = [
    azurerm_resource_group.vm_rg
  ]
}

# Virtual Machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name  
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  # OS Profile
  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  # OS Profile for Linux
  os_profile_linux_config {
    disable_password_authentication = false # Enable password authentication
  }

  # OS Disk
  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_storage_account_type
  }

  # Image Reference
  storage_image_reference {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.sku
    version   = var.image_reference.version
  }

  tags = var.tags
}

# Custom Script Extension for Linux
resource "azurerm_virtual_machine_extension" "linux_custom_script" {
  count                = var.os_type == "Linux" ? 1 : 0
  name                 = "${var.prefix}-linux-script"
  virtual_machine_id   = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "commandToExecute": "${var.linux_custom_script_command}"
    }
  SETTINGS

  tags = var.tags
}

# Custom Script Extension for Windows
resource "azurerm_virtual_machine_extension" "windows_custom_script" {
  count                = var.os_type == "Windows" ? 1 : 0
  name                 = "${var.prefix}-windows-script"
  virtual_machine_id   = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "${var.windows_custom_script_command}"
    }
  SETTINGS
}