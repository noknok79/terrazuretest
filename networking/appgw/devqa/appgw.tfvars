# General Variables

location                   = "eastus"              # Default value
resource_group_name        = "RG-APPGATEWAY-DEVQA" # Default value
vnet_name                  = "vnet-devqa-eastus"   # Updated to include DEVQA
vnet_address_space         = ["10.3.0.0/16"]       # Default value
appgw_subnet_address_space = ["10.3.2.0/24"]
# Subnet Variables
frontend_subnet_name               = "frontend-subnet-devqa"   # Updated to include DEVQA
backend_subnet_name                = "backend-subnet-devqa"    # Updated to include DEVQA
subnet_name                        = "subnet-appgateway-devqa" # Updated to include DEVQA
app_gateway_frontend_subnet_prefix = ["10.3.3.0/24"]
app_gateway_backend_subnet_prefix  = ["10.3.4.0/24"]

# Network Security Group
nsg_name = "nsg-app-gateway-devqa" # Updated to include DEVQA

# Public IP Configuration
public_ip_name              = "pip-app-gateway-devqa" # Updated to include DEVQA
use_public_ip               = true                    # Default value
public_ip_allocation_method = "Static"
public_ip_sku               = "Standard"

# Application Gateway Configuration
app_gateway_name               = "app-gateway-devqa"               # Updated to include DEVQA
sku_name                       = "WAF_v2"                          # Default value
tier                           = "WAF_v2"                          # Default value
capacity                       = 2                                 # Default value
frontend_port_name             = "http-port-devqa"                 # Updated to include DEVQA
frontend_ip_configuration_name = "app-gateway-frontend-ip-devqa"   # Updated to include DEVQA
http_setting_name              = "app-gateway-http-settings-devqa" # Updated to include DEVQA
listener_name                  = "app-gateway-http-listener-devqa" # Updated to include DEVQA
request_routing_rule_name      = "app-gateway-routing-rule-devqa"  # Updated to include DEVQA

# Backend Configuration
backend_address_pool_name = "app-gateway-backend-pool-devqa" # Updated to include DEVQA
backend_addresses = [
  {
    ip_address = "10.3.2.4"
  },
  {
    ip_address = "10.3.2.5"
  }
]

# Virtual Machine Configuration
vm_admin_username = "azureuser"               # Default value
vm_admin_password = "A1b@C#d$E5f^G&h*J2k!L3m" # Replace with a secure password
vm_size           = "Standard_DS1_v2"         # Default value

# SSL Certificate Configuration
ssl_certificate_name     = "default-ssl-cert-devqa"                  # Updated to include DEVQA
ssl_certificate_password = "your-ssl-password"                       # Replace with actual value
ssl_certificate_content  = "your-base64-encoded-certificate-content" # Replace with the Base64-encoded content of your SSL certificate

# Tags
tags = {
  environment = "devqa"                     # Updated to include DEVQA
  project     = "app-gateway-project-devqa" # Updated to include DEVQA
}

# Health Probe Configuration
health_probe_name                = "app-gateway-health-probe-devqa" # Updated to include DEVQA
health_probe_protocol            = "Http"
health_probe_path                = "/health"
health_probe_interval            = 30
health_probe_timeout             = 30
health_probe_unhealthy_threshold = 3

# Key Vault Configuration
key_vault_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY-DEVQA/providers/Microsoft.KeyVault/vaults/kv-app-gateway-devqa" # Updated to include DEVQA

# Access Policies
access_policies = {
  policy1 = {
    tenant_id = "your-tenant-id"
    object_id = "your-object-id"
    permissions = {
      keys         = ["get", "list"]
      secrets      = ["get", "list"]
      certificates = ["get", "list"]
    }
  }
}

# Managed Identity
app_gateway_object_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY-DEVQA/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-gateway-identity-devqa" # Updated to include DEVQA
