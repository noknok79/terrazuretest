# General Variables

location            = "eastus"
resource_group_name = "RG-APPGATEWAY"
vnet_name           = "vnet-app-gateway"
subnet_name         = "subnet-frontend"
nsg_name            = "nsg-app-gateway"
public_ip_name      = "pip-app-gateway"
app_gateway_name    = "app-gateway" # Replace with your desired Application Gateway name
# SSL Certificate Variables
ssl_certificate_password = "your-ssl-password"                       # Replace with actual value
ssl_certificate_content  = "your-base64-encoded-certificate-content" # Replace with the Base64-encoded content of your SSL certificate
certificate_name         = "app-gateway-ssl-cert"
certificate_content_type = "application/x-pkcs12"

# Networking Variables
address_space = ["10.0.0.0/16"]
subnet_prefix = ["10.0.1.0/24"]

# Application Gateway Configuration Variables
waf_mode                = "Prevention"
sku_name                = "WAF_v2"
sku_capacity            = 2
ssl_policy_min_protocol = "TLSv1_2"
ssl_policy_cipher_suites = [
  "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
  "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
  "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
  "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
]

# Backend Configuration Variables
backend_pool_name                     = "app-gateway-backend-pool"
backend_http_settings_name            = "app-gateway-http-settings"
backend_http_settings_protocol        = "Http"
backend_http_settings_port            = 80
backend_http_settings_request_timeout = 20

# Health Probe Variables
health_probe_name                = "app-gateway-health-probe"
health_probe_protocol            = "Http"
health_probe_path                = "/health"
health_probe_interval            = 30
health_probe_timeout             = 30
health_probe_unhealthy_threshold = 3

# Key Vault ID
key_vault_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY/providers/Microsoft.KeyVault/vaults/kv-app-gateway"

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

# Required Variables
tenant_id                    = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
subscription_id              = "096534ab-9b99-4153-8505-90d030aa4f08" # Replace with your Azure tenant ID
environment                  = "dev"                                  # Replace with your environment (e.g., dev, staging, prod)
project                      = "app-gateway-project"                  # Replace with your project name
ssl_certificate_secret_value = "your-ssl-certificate-secret-value"    # Replace with the actual secret value

# Missing Variables
tags = {
  environment = "dev"
  project     = "app-gateway-project"
}

vnet_address_space          = ["10.0.0.0/16"]
subnet_address_prefixes     = ["10.0.1.0/24"]
public_ip_allocation_method = "Static"
public_ip_sku               = "Standard"
appgw_name                  = "app-gateway"
appgw_sku_name              = "WAF_v2"
appgw_sku_tier              = "WAF_v2"
appgw_capacity              = 2
backend_addresses = [
  {
    ip_address = "10.0.1.4"
  },
  {
    ip_address = "10.0.1.5"
  }
]
app_gateway_object_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-gateway-identity"

# Add the missing variable for the Application Gateway's managed identity object ID
# app_gateway_object_id = azurerm_user_assigned_identity.appgw_identity.principal_id

# Add the missing variable for the user-assigned managed identity
user_assigned_identity_id   = "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>"
user_assigned_identity_name = "app-gateway-identity"
user_assigned_identity_rg   = "RG-APPGATEWAY"

# New Variables
backend_address_pool_name      = "app-gateway-backend-pool"
frontend_port_name             = "http-port"
frontend_ip_configuration_name = "app-gateway-frontend-ip"
http_setting_name              = "app-gateway-http-settings"
listener_name                  = "app-gateway-http-listener"
request_routing_rule_name      = "app-gateway-routing-rule"

# Default Values for Missing Variables
frontend_subnet_name = "frontend-subnet"
backend_subnet_name  = "backend-subnet"
vm_admin_username    = "azureuser"
vm_size              = "Standard_DS1_v2"

# Add the missing variable for VM admin password
vm_admin_password = "A1b@C#d$E5f^G&h*J2k!L3m" # Replace with a secure password

# Output
