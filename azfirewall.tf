variable "azfirewall_config" {
  type = object({
    resource_group_name    = string
    location               = string
    environment            = string
    owner                  = string
    azfirewall_name        = string
    azfirewall_policy_name = string
    sku_name               = string
    sku_tier               = string
    azfirewall_pip_name    = string
    pip_allocation_method  = string
    pip_sku                = string
    use_public_ip          = bool
    ip_configuration_name  = string
    public_ip_enabled      = bool
    zones                  = list(string)
    vnet_name              = string
    address_space          = list(string)
    subnet_name            = string
    subnet_address_prefix  = string
    subnets = list(object({
      name           = string
      id             = string
      address_prefix = string
    }))
    tenant_id              = string
    subscription_id        = string
    firewall_subnet_prefix = string
  })
  default = {
    subscription_id        = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id              = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    environment            = "dev"
    location               = "eastus"
    zones                  = ["1", "2", "3"]
    owner                  = "team-security"
    address_space          = ["10.0.0.0/16"]
    azfirewall_policy_name = "azfirewall-policy"
    azfirewall_name        = "azfirewall-eastus"
    azfirewall_pip_name    = "azfirewall-pip"
    vnet_name              = "azfwvnet-dev-eastus"
    sku_tier               = "Standard"
    sku_name               = "AZFW_VNet"
    firewall_subnet_prefix = "10.0.3.0/24"
    pip_allocation_method  = "Static"
    pip_sku                = "Standard"
    resource_group_name    = "RG-AZFIREWALL"
    use_public_ip          = true
    ip_configuration_name  = "azfw-ipconfig"
    public_ip_enabled      = true
    subnet_name            = "AzureFirewallSubnet"
    subnet_address_prefix  = "10.0.3.0/24"
    subnets = [
      {
        name           = "AzureFirewallSubnet"
        id             = ""
        address_prefix = "10.0.3.0/24"
      }
    ]
  }
}