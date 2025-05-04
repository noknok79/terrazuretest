subscription_id        = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id              = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
environment            = "dev"
location               = "eastus"
vnet_name              = "azfwvnet-dev-eastus"
resource_group_name    = "RG-AZFIREWALL"
zones                  = ["1", "2", "3"]
owner                  = "team-security"
address_space          = ["10.0.0.0/16"]
azfirewall_policy_name = "azfirewall-policy"
azfirewall_name        = "azfirewall-eastus"
azfirewall_pip_name    = "azfirewall-pip"
sku_name               = "AZFW_VNet"
sku_tier               = "Standard" # Updated to support advanced features
firewall_subnet_prefix = "10.0.3.0/24"
pip_allocation_method  = "Static"
pip_sku                = "Standard"
use_public_ip          = true

subnets = [
  {
    name = "AzureFirewallSubnet"
    id   = "subnet-id-placeholder"
  }
]
