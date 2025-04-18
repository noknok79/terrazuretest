terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74" 
    }
  }
}

provider "azurerm" {
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Provider alias for VM Scale Sets
provider "azurerm" {
  alias                      = "vmss"
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_vmss
  location = var.location

  tags = {
    environment = "production"
    owner       = "team-name"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-vmscaleset"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "production"
    owner       = "team-name"
  }
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-vmscaleset"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-vmscaleset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
    owner       = "team-name"
  }
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-vmscaleset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-vmscaleset"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "production"
    owner       = "team-name"
  }
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = "lb-vmscaleset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "lb-frontend"
    subnet_id            = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "production"
    owner       = "team-name"
  }
}

# Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "lb-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

# Load Balancer Probe
resource "azurerm_lb_probe" "lb_probe" {
  name            = "lb-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

# Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.rg_vmss

  sku = var.vmss_sku
  instances = var.vmss_instances

  upgrade_mode = "Manual"

  admin_username = var.admin_username
  admin_password = var.admin_password

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  network_interface {
    name    = var.nic_ip_config_name
    primary = true

    ip_configuration {
      name                                   = "ipconfig-vmscaleset"
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
    }
  }

  os_disk {
    caching           = var.vmss_os_disk_caching
    storage_account_type = var.vmss_os_disk_storage_account_type
    disk_size_gb      = var.vmss_os_disk_size_gb
  }

  source_image_reference {
    publisher = var.vmss_image_publisher
    offer     = var.vmss_image_offer
    sku       = var.vmss_image_sku
    version   = var.vmss_image_version
  }

  tags = {
    environment = "production"
    owner       = "team-name"
  }
}


