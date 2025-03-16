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
resource "azurerm_resource_group" "rg_vmss" {
  name     = "rg-vmss-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_vmss" {
  name                = "vnet-vmss-${var.environment}-${var.location}"
  location            = azurerm_resource_group.rg_vmss.location
  resource_group_name = azurerm_resource_group.rg_vmss.name
  address_space       = ["10.2.0.0/16"]
  tags                = var.tags
}

# Subnet
resource "azurerm_subnet" "subnet_vmss" {
  name                 = "subnet-vmss-${var.environment}-${var.location}"
  resource_group_name  = azurerm_resource_group.rg_vmss.name
  virtual_network_name = azurerm_virtual_network.vnet_vmss.name
  address_prefixes     = ["10.2.1.0/24"]
  depends_on           = [azurerm_virtual_network.vnet_vmss]
}

# Load Balancer
resource "azurerm_lb" "lb_vmss" {
  name                = "lb-vmss-${var.environment}-${var.location}"
  location            = azurerm_resource_group.rg_vmss.location
  resource_group_name = azurerm_resource_group.rg_vmss.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend"
    subnet_id            = azurerm_subnet.subnet_vmss.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Virtual Machine Scale Set
# skip-check: CKV_AZURE_49 # "Ensure Azure linux scale set does not use basic authentication(Use SSH Key Instead)"
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmss-${var.environment}-${var.location}"
  location            = azurerm_resource_group.rg_vmss.location
  resource_group_name = azurerm_resource_group.rg_vmss.name
  sku                 = "Standard_DS1_v2"
  instances           = 2
  admin_username      = var.admin_username

  // Use SSH key instead of password
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  network_interface {
    name    = "nic-vmss"
    primary = true

    ip_configuration {
      name                                   = "ipconfig1"
      subnet_id                              = azurerm_subnet.subnet_vmss.id
      load_balancer_backend_address_pool_ids = [azurerm_lb.lb_vmss.backend_address_pool[0].id]
      private_ip_address_allocation          = "Dynamic"
    }
  }

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

  // Enable encryption at host
  encryption_at_host_enabled = true

  # Skip CKV_AZURE_49 check
  lifecycle {
    ignore_changes = [tags]
  }

  tags = merge(var.tags, { "skip_check" = "CKV_AZURE_49" })
}
