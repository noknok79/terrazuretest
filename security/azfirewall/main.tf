terraform {
  required_version = ">= 1.5.0" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
  tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
  skip_provider_registration = true
}

resource "azurerm_firewall_policy" "azfw_policy" {
  name                = var.azfirewall_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name


  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.azfirewall_rg
  ]
}

# skip-check CKV_AZURE_216 #Ensure DenyIntelMode is set to Deny for Azure Firewalls
resource "azurerm_firewall" "azfw" {
  name                = var.azfirewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  zones               = var.zones

  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = var.use_public_ip ? azurerm_public_ip.azfw_pip[0].id : null
  }

  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  threat_intel_mode  = "Deny"

  depends_on = [
    azurerm_resource_group.azfirewall_rg,
    azurerm_subnet.firewall_subnet,
    azurerm_public_ip.azfw_pip,
    azurerm_firewall_policy.azfw_policy
  ]

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "azurerm_resource_group" "azfirewall_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.azfirewall_rg
  ]
}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet" # Updated to the required name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name # Corrected reference
  address_prefixes     = [var.firewall_subnet_prefix]

  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_resource_group.azfirewall_rg
  ]
}

resource "azurerm_public_ip" "azfw_pip" {
  count               = var.use_public_ip ? 1 : 0
  name                = var.azfirewall_pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku
  zones               = var.zones # Ensure zones match the Azure Firewall

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.azfirewall_rg
  ]
}

resource "azurerm_network_security_group" "azfirewall_nsg" {
  count               = var.insert_nsg ? 1 : 0
  name                = "${var.azfirewall_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowAzureFirewall"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each = { for subnet in azurerm_virtual_network.vnet.subnet : subnet.name => subnet.id if lower(subnet.name) != "azurefirewallsubnet" }

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.azfirewall_nsg[0].id
}