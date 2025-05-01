environment = "dev"
location = "eastus"
vnet_name = "vnet-dev-eastus"
subnet_name = "AzureFirewallSubnet"
resource_group_name = "RG-AZFIREWALL"
zones = ["1", "2", "3"]
owner = "team-security"
address_space = ["10.0.0.0/16"]
subnet_address_prefixes = ["10.0.13.0/24"]
azfirewall_policy_name = "azfirewall-policy"
azfirewall_name = "azfirewall-eastus"
azfirewall_pip_name = "azfirewall-pip"

// Additional variables based on the resource
sku_name = "AZFW_VNet"
sku_tier = "Premium" # Updated to Premium to support advanced features
ip_configuration_name = "azfw-ipconfig"
public_ip_enabled = false