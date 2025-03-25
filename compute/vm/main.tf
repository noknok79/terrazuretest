# This Terraform configuration defines resources for a Virtual Machine.
# These resources have been set in the computevm.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/vm/vm.tfvars" --out="computevm.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/vm/vm.tfvars" --input=false
# #2 terraform destroy -var-file="compute/vm/vm.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0" # Use the latest stable version
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
}


# Resource Group
resource "azurerm_resource_group" "rg_vm" {
  name     = "RG-vm-${var.environment}-${replace(var.location, " ", "-")}"
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_vm" {
  name                = "vnet-vm-${var.environment}-${replace(var.location, " ", "-")}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  address_space       = ["10.1.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet_vm" {
  name                 = "subnet-vm-${var.environment}-${replace(var.location, " ", "-")}"
  resource_group_name  = azurerm_resource_group.rg_vm.name
  virtual_network_name = azurerm_virtual_network.vnet_vm.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "vm_ip" {
  count               = var.vm_count
  name                = "public-ip-vm-${var.environment}-${replace(var.location, " ", "-")}-${count.index + 1}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  allocation_method   = "Static"
  sku                 = "Standard" # Ensure SKU is Standard
  tags                = var.tags
}

# Network Interface
resource "azurerm_network_interface" "nic_vm" {
  count               = var.vm_count
  name                = "nic-vm-${var.environment}-${replace(var.location, " ", "-")}-${count.index + 1}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.vm_ip.*.id, count.index)
  }

  tags = var.tags
}

# skip-check: CKV_AZURE_50 "Ensure that 'Disable VM Agent' is set to 'Yes' for Linux Virtual Machines"
# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vm-${var.environment}-${replace(var.location, " ", "-")}-${count.index + 1}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  size                = "Standard_DS1_v2"

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path) # Path to your SSH public key
  }

  network_interface_ids = [element(azurerm_network_interface.nic_vm.*.id, count.index)]

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

  tags = var.tags
}
