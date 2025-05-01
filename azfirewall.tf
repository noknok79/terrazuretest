variable "azfirewall_config" {
  description = "Configuration for the Azure Firewall deployment"
  type = object({
    environment             = string
    location                = string
    zones                   = list(string)
    owner                   = string
    address_space           = list(string)
    address_prefixes = list(string)
    azfirewall_policy_name  = string
    azfirewall_name         = string
    azfirewall_pip_name     = string
    vnet_name               = string
    sku_tier                = string
    sku_name                = string
    subnet_name             = string
    firewall_subnet_prefix  = string
    pip_allocation_method   = string
    pip_sku                 = string
    resource_group_name     = string
    use_public_ip           = bool
    ip_configuration_name   = string
    public_ip_enabled       = bool
    insert_nsg              = bool # New boolean variable

  })
  default = {
    environment             = "dev"
    location                = "eastus"
    zones                   = ["1", "2", "3"]
    owner                   = "team-security"
    address_space           = ["10.0.0.0/16"]
    address_prefixes = ["10.0.13.0/24"]
    azfirewall_policy_name  = "azfirewall-policy"
    azfirewall_name         = "azfirewall-eastus"
    azfirewall_pip_name     = "azfirewall-pip"
    vnet_name               = "vnet-dev-eastus"
    sku_tier                = "Premium" # Updated to Premium to support advanced features
    sku_name                = "AZFW_VNet"
    subnet_name             = "AzureFirewallSubnet"
    firewall_subnet_prefix  = "10.0.13.0/24"
    pip_allocation_method   = "Static"
    pip_sku                 = "Standard"
    resource_group_name     = "RG-AZFIREWALL"
    use_public_ip           = true
    ip_configuration_name   = "azfw-ipconfig"
    public_ip_enabled       = true
    insert_nsg              = false # New boolean variable

  }
}