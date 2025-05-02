terraform {
  required_version = ">= 1.5.6" # Ensure compatibility with the latest stable Terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0" # Use the latest stable version of the AzureRM provider
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
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

resource "azurerm_firewall_policy_rule_collection_group" "app_rule_collection" {
  name                = "AppRuleCollectionGroup"
  firewall_policy_id  = azurerm_firewall_policy.azfw_policy.id
  priority            = 100

  application_rule_collection {
    name     = "AppRuleCollection"
    priority = 100
    action   = "Allow"

    rule {
      name               = "AllowWebTraffic"
      source_addresses   = ["10.0.0.0/24"]
      destination_fqdns  = ["www.microsoft.com", "www.github.com"]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "nat_rule_collection" {
  name                = "NatRuleCollectionGroup"
  firewall_policy_id  = azurerm_firewall_policy.azfw_policy.id
  priority            = 200

  nat_rule_collection {
    name     = "NatRuleCollection"
    priority = 200
    action   = "Dnat"

    rule {
      name                   = "DNATRule"
      source_addresses       = ["*"]
      destination_address    = var.use_public_ip ? azurerm_public_ip.azfw_pip[0].ip_address : null
      destination_ports      = ["3389"]
      translated_address     = "10.0.0.4"
      translated_port        = "3389"
      protocols              = ["TCP"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "network_rule_collection" {
  name                = "NetworkRuleCollectionGroup"
  firewall_policy_id  = azurerm_firewall_policy.azfw_policy.id
  priority            = 300

  network_rule_collection {
    name     = "NetworkRuleCollection"
    priority = 300
    action   = "Allow"

    rule {
      name                   = "AllowSQLTraffic"
      source_addresses       = ["10.0.0.0/24"]
      destination_addresses  = ["20.30.40.50"]
      destination_ports      = ["1433"]
      protocols              = ["TCP"]
    }
  }
}

# skip-check CKV_AZURE_216 #Ensure DenyIntelMode is set to Deny for Azure Firewalls
resource "azurerm_firewall" "azfw" {
  name                = var.azfirewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  zones               = var.zones

  dynamic "ip_configuration" {
    for_each = var.use_public_ip ? [1] : [0]
    content {
      name                 = "azfw-ipconfig"
      subnet_id            = azurerm_subnet.firewall_subnet.id
      public_ip_address_id = var.use_public_ip ? azurerm_public_ip.azfw_pip[0].id : null
    }
  }

  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  threat_intel_mode  = "Deny" # Best practice to deny traffic by default

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
  name                 = "AzureFirewallSubnet" # Required name for Azure Firewall
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
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
  zones               = var.zones

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [
    azurerm_resource_group.azfirewall_rg
  ]
}
