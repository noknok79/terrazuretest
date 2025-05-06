# General Variables

location                   = "eastus"             # Default value
resource_group_name        = "RG-APPGATEWAY-PROD" # Updated value
vnet_name                  = "vnet-prod-eastus"   # Updated value
vnet_address_space         = ["10.2.0.0/16"]      # Default value
appgw_subnet_address_space = ["10.2.1.0/24"]      # Updated to belong to 10.2.0.0/16
# Subnet Variables
frontend_subnet_name               = "frontend-subnet-PROD"   # Updated value
backend_subnet_name                = "backend-subnet-PROD"    # Updated value
subnet_name                        = "subnet-appgateway-PROD" # Updated value
app_gateway_frontend_subnet_prefix = ["10.2.2.0/24"]          # Updated to belong to 10.2.0.0/16
app_gateway_backend_subnet_prefix  = ["10.2.3.0/24"]          # Updated to belong to 10.2.0.0/16

# Network Security Group
nsg_name = "nsg-app-gateway-PROD" # Updated value

# Public IP Configuration
public_ip_name              = "pip-app-gateway-PROD" # Updated value
use_public_ip               = true                   # Default value
public_ip_allocation_method = "Static"
public_ip_sku               = "Standard"

# Application Gateway Configuration
app_gateway_name               = "app-gateway-PROD"               # Updated value
sku_name                       = "WAF_v2"                         # Default value
tier                           = "WAF_v2"                         # Default value
capacity                       = 2                                # Default value
frontend_port_name             = "http-port-PROD"                 # Updated value
frontend_ip_configuration_name = "app-gateway-frontend-ip-PROD"   # Updated value
http_setting_name              = "app-gateway-http-settings-PROD" # Updated value
listener_name                  = "app-gateway-http-listener-PROD" # Updated value
request_routing_rule_name      = "app-gateway-routing-rule-PROD"  # Updated value

# Backend Configuration
backend_address_pool_name = "app-gateway-backend-pool-PROD" # Updated value
backend_addresses = [
  {
    ip_address = "10.2.1.4" # Updated to belong to 10.2.0.0/16
  },
  {
    ip_address = "10.2.1.5" # Updated to belong to 10.2.0.0/16
  }
]

# Virtual Machine Configuration
vm_admin_username = "azureuser"               # Default value
vm_admin_password = "A1b@C#d$E5f^G&h*J2k!L3m" # Replace with a secure password
vm_size           = "Standard_DS1_v2"         # Default value

# SSL Certificate Configuration
ssl_certificate_name     = "default-ssl-cert-PROD"                   # Updated value
ssl_certificate_password = "your-ssl-password"                       # Replace with actual value
ssl_certificate_content  = "your-base64-encoded-certificate-content" # Replace with the Base64-encoded content of your SSL certificate

# Tags
tags = {
  environment = "prod"                     # Updated value
  project     = "app-gateway-project-PROD" # Updated value
}

# Health Probe Configuration
health_probe_name                = "app-gateway-health-probe-PROD" # Updated value
health_probe_protocol            = "Http"
health_probe_path                = "/health"
health_probe_interval            = 30
health_probe_timeout             = 30
health_probe_unhealthy_threshold = 3

# Key Vault Configuration
key_vault_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY-PROD/providers/Microsoft.KeyVault/vaults/kv-app-gateway-PROD" # Updated value

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
app_gateway_object_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY-PROD/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-gateway-identity-PROD" # Updated value
