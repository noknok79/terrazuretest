# Provider Configuration
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_vmss
  location = var.location

  tags = {
    environment = var.environment
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

# Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.vmss_sku
  instances           = var.vmss_instances

  admin_username = var.admin_username

  # Configure SSH authentication
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = var.vmss_image_publisher
    offer     = var.vmss_image_offer
    sku       = var.vmss_image_sku
    version   = var.vmss_image_version
  }

  network_interface {
    name    = var.nic_name
    primary = true # Mark this network interface as primary
    ip_configuration {
      name      = var.nic_ip_config_name
      primary   = true # Mark this IP configuration as primary
      subnet_id = azurerm_subnet.subnet.id
    }
  }

  os_disk {
    caching              = var.vmss_os_disk_caching
    storage_account_type = var.vmss_os_disk_storage_account_type
  }

  tags = var.tags

  # Explicit dependencies
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnet,
    azurerm_network_security_group.nsg
  ]
}

# Output
output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}