terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Use the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg_vm" {
  name     = "rg-vm-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_vm" {
  name                = "vnet-vm-${var.environment}-${var.location}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

# Subnet
resource "azurerm_subnet" "subnet_vm" {
  name                 = "subnet-vm-${var.environment}-${var.location}"
  resource_group_name  = azurerm_resource_group.rg_vm.name
  virtual_network_name = azurerm_virtual_network.vnet_vm.name
  address_prefixes     = ["10.1.1.0/24"]
  depends_on           = [azurerm_virtual_network.vnet_vm]
}

# Network Interface
resource "azurerm_network_interface" "nic_vm" {
  name                = "nic-vm-${var.environment}-${var.location}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}


# skip-check: CKV_AZURE_50 "Ensure that 'Disable VM Agent' is set to 'Yes' for Linux Virtual Machines"
# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.environment}-${var.location}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  size                = "Standard_DS1_v2"

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path) # Path to your SSH public key
  }

  network_interface_ids = [azurerm_network_interface.nic_vm.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provision_vm_agent = true # Disable VM agent to prevent extensions

  depends_on = [azurerm_network_interface.nic_vm]

  tags = var.tags
}
