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
  address_space       = var.vnet_address_space

  depends_on = [
    azurerm_resource_group.app_gateway_rg
  ]
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.appgw_subnet_address_space # Additional backend subnet

  lifecycle {
    prevent_destroy = false              # Prevent accidental deletion of the subnet
    ignore_changes  = [address_prefixes] # Ignore changes to address prefixes
  }

  depends_on = [
    azurerm_resource_group.app_gateway_rg,
    azurerm_virtual_network.app_gateway_vnet
  ]
}


# Updated Application Gateway with depends_on
resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_v2" # Updated SKU to support WAF policies
    tier     = "WAF_v2" # Updated tier to WAF_v2
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "app-gateway-ip-config"
    subnet_id = azurerm_subnet.app_gateway_frontend_subnet.id
  }
  frontend_ip_configuration {
    name                 = "app-gateway-frontend-ip"
    public_ip_address_id = var.use_public_ip ? azurerm_public_ip.app_gateway_pip[0].id : null
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

  # Attach WAF Policy
  firewall_policy_id = azurerm_web_application_firewall_policy.app_gateway_waf_policy.id

  depends_on = [
    azurerm_subnet.app_gateway_frontend_subnet,
    azurerm_public_ip.app_gateway_pip,
    azurerm_web_application_firewall_policy.app_gateway_waf_policy
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
  address_prefixes     = var.app_gateway_frontend_subnet_prefix

  lifecycle {
    prevent_destroy = false              # Allow deletion of the subnet
    ignore_changes  = [address_prefixes] # Ignore changes to address prefixes
  }

  depends_on = [
    azurerm_virtual_network.app_gateway_vnet
  ]
}

resource "azurerm_subnet" "app_gateway_backend_subnet" {
  name                 = var.backend_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.app_gateway_backend_subnet_prefix

  lifecycle {
    prevent_destroy = false              # Allow deletion of the subnet
    ignore_changes  = [address_prefixes] # Ignore changes to address prefixes
  }


  depends_on = [
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

# Add a new variable to control public IP usage

# Updated Public IP with depends_on
resource "azurerm_public_ip" "app_gateway_pip" {
  count               = var.use_public_ip ? 1 : 0
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_resource_group.app_gateway_rg,
    azurerm_virtual_network.app_gateway_vnet
  ]
}

# Updated WAF Policy with depends_on
resource "azurerm_web_application_firewall_policy" "app_gateway_waf_policy" {
  name                = "${var.app_gateway_name}-waf-policy"
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_resource_group.app_gateway_rg
  ]

  custom_rules {
    action    = "Allow"
    enabled   = false
    name      = "SpecialCharatersException"
    priority  = 10
    rule_type = "MatchRule"
    match_conditions {
      match_values = [">=", "<=", "https://", "or ", "and", "&", "|", "{", "}", "#"]
      operator     = "Contains"
      match_variables {
        variable_name = "RequestBody"
      }
    }
  }
  managed_rules {
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "values.operator"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["942120", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "comment"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["920230", "920271"]
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        }
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["941100", "941150", "941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942430", "942440", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "values.comment"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["920230", "920271"]
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        }
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["941100", "941150", "941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942430", "942440", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "labAssistantAdditionalInformation"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["920230", "920271"]
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        }
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["941100", "941150", "941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942430", "942440", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "probeCollectorAdditionalInformation"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["920230", "920271"]
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        }
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["941100", "941150", "941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942430", "942440", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "password"
      selector_match_operator = "Contains"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["920230", "920271"]
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        }
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["941100", "941150", "941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942430", "942440", "942100", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "labAssistant"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942390", "942400", "942440"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "probeCollector"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["941180"]
          rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        }
        rule_group {
          excluded_rules  = ["942120", "942130", "942390", "942400", "942440"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "name"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "street"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "customer_group"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["942130", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "invoice_receiver"
      selector_match_operator = "Equals"
      excluded_rule_set {
        rule_group {
          excluded_rules  = ["931130"]
          rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        }
        rule_group {
          excluded_rules  = ["942130", "942390", "942400"]
          rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        }
      }
    }
    managed_rule_set {
      version = "3.2"
    }
  }
  policy_settings {
    max_request_body_size_in_kb      = 1024
    request_body_inspect_limit_in_kb = 1024
    mode                             = "Prevention" # Updated to Prevention mode
  }
}


# Updated Network Interface with depends_on
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
    subnet_id                     = azurerm_subnet.app_gateway_backend_subnet.id # Corrected reference
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_subnet.app_gateway_backend_subnet, # Corrected reference
    azurerm_network_security_group.app_gateway_nsg
  ]
}

# Updated Virtual Machine with depends_on
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
    azurerm_network_interface.backend_nic,
    azurerm_subnet.app_gateway_backend_subnet
  ]
}