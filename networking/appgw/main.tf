terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
}

# Add random string for resource group uniqueness
# resource "random_string" "rg_suffix" {
#   length  = 6
#   upper   = false
#   special = false
# }

# Updated Resource Group
resource "azurerm_resource_group" "app_gateway_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Updated Virtual Network
resource "azurerm_virtual_network" "app_gateway_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.app_gateway_rg
  ]
}

# Network Security Group for the subnet
resource "azurerm_network_security_group" "app_gateway_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTP traffic
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
  }

  # Allow Application Gateway V2 SKU traffic
  security_rule {
    name                       = "Allow-AppGW-V2-Traffic"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.app_gateway_rg
  ]
}

# Updated Subnets
resource "azurerm_subnet" "app_gateway_frontend_subnet" {
  name                 = var.frontend_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.app_gateway_vnet
  ]
}

resource "azurerm_subnet" "app_gateway_backend_subnet" {
  name                 = var.backend_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [
    azurerm_virtual_network.app_gateway_vnet
  ]
}

resource "azurerm_subnet" "backend_subnet" {
  name                 = var.backend_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.3.0/24"] # Additional backend subnet

  lifecycle {
    prevent_destroy = false              # Prevent accidental deletion of the subnet
    ignore_changes  = [address_prefixes] # Ignore changes to address prefixes
  }

  depends_on = [
    azurerm_resource_group.app_gateway_rg,
    azurerm_virtual_network.app_gateway_vnet
  ]
}

# Associate NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "app_gateway_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app_gateway_frontend_subnet.id
  network_security_group_id = azurerm_network_security_group.app_gateway_nsg.id

  depends_on = [
    azurerm_network_security_group.app_gateway_nsg,
    azurerm_subnet.app_gateway_frontend_subnet
  ]
}

# Updated Public IP
resource "azurerm_public_ip" "app_gateway_pip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_resource_group.app_gateway_rg
  ]
}

# Updated Application Gateway
resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "app-gateway-ip-config"
    subnet_id = azurerm_subnet.app_gateway_frontend_subnet.id
  }
  frontend_ip_configuration {
    name                 = "app-gateway-frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway_pip.id
  }
  frontend_port {
    name = "http-port"
    port = 80
  }
  backend_address_pool {
    name = "app-gateway-backend-pool"
  }
  http_listener {
    name                           = "app-gateway-http-listener"
    frontend_ip_configuration_name = "app-gateway-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }
  backend_http_settings {
    name                  = "app-gateway-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
  request_routing_rule {
    name                       = "app-gateway-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "app-gateway-http-listener"
    backend_address_pool_name  = "app-gateway-backend-pool"
    backend_http_settings_name = "app-gateway-http-settings"
    priority                   = 1
  }

  depends_on = [
    azurerm_subnet.app_gateway_frontend_subnet,
    azurerm_public_ip.app_gateway_pip
  ]
}

# New Virtual Machines
resource "azurerm_network_interface" "backend_nic" {
  count               = 2
  name                = "backend-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    prevent_destroy = false # Allow deletion of VMs
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.backend_subnet
  ]
}

resource "azurerm_virtual_machine" "backend_vm" {
  count                 = 2 # Adjust the count as needed
  name                  = "backend-vm-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.backend_nic[count.index].id]
  vm_size               = var.vm_size

  lifecycle {
    prevent_destroy = false # Allow deletion of VMs
  }

  storage_os_disk {
    name              = "backend-os-disk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "backend-vm-${count.index}"
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password # Ensure this is securely managed
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "production"
  }
  depends_on = [
    azurerm_network_interface.backend_nic
  ]

}