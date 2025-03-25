# This Terraform configuration defines resources for a Virtual Machine Scale Set.
# These resources have been set in the vmscaleset.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/vmscalesets/vmscalesets.tfvars" --out="vmscaleset.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/vmscalesets/vmscalesets.tfvars" --input=false
# #2 terraform destroy -var-file="compute/vmscalesets/vmscalesets.tfvars" --input=false
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
  alias                           = "vmssazure"
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "rg_vmss" {
  name     = "RG-vmss-${var.environment}-${replace(var.location, " ", "-")}"
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_vmss" {
  name                = "vnet-vmss-${var.environment}-${replace(var.location, " ", "-")}"
  location            = azurerm_resource_group.rg_vmss.location
  resource_group_name = azurerm_resource_group.rg_vmss.name
  address_space       = ["10.2.0.0/16"]
  tags                = var.tags
}

# Subnet
resource "azurerm_subnet" "subnet_vmss" {
  name                 = "subnet-vmss-${var.environment}-${replace(var.location, " ", "-")}"
  resource_group_name  = azurerm_resource_group.rg_vmss.name
  virtual_network_name = azurerm_virtual_network.vnet_vmss.name
  address_prefixes     = ["10.2.1.0/24"]
  depends_on           = [azurerm_virtual_network.vnet_vmss] # Ensures the virtual network is created first
}

# Load Balancer
resource "azurerm_lb" "lb_vmss" {
  name                = "lb-vmss-${var.environment}-${replace(var.location, " ", "-")}"
  location            = azurerm_resource_group.rg_vmss.location
  resource_group_name = azurerm_resource_group.rg_vmss.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "frontend"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_vmss.id
  }

  tags = var.tags

  depends_on = [azurerm_subnet.subnet_vmss] # Ensures the subnet is created first
}

# Define the backend address pool for the load balancer
resource "azurerm_lb_backend_address_pool" "lb_backend_pool_vmss" {
  name            = "backend-pool-vmss"
  loadbalancer_id = azurerm_lb.lb_vmss.id
}

# Virtual Machine Scale Set
# skip-check: CKV_AZURE_49 # "Ensure Azure linux scale set does not use basic authentication(Use SSH Key Instead)"
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmss-${var.environment}-${replace(var.location, " ", "-")}"
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
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool_vmss.id]
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
  # encryption_at_host_enabled = true

  # Skip CKV_AZURE_49 check
  lifecycle {
    ignore_changes = [tags]
  }

  tags = merge(var.tags, { "skip_check" = "CKV_AZURE_49" })

  # depends_on = [azurerm_lb.lb_vmss, azurerm_subnet.subnet_vmss] # Ensures the load balancer and subnet are created first
}
