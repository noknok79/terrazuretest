variable "appgw_config" {
  description = "Configuration for the Application Gateway and related resources."
  type = object({
    location                       = string
    resource_group_name            = string
    tags                           = map(string)
    vnet_name                      = string
    vnet_address_space             = list(string) # Ensure this matches the actual VNet range
    appgw_subnet_address_space     = list(string) # Ensure this is within the VNet range
    frontend_subnet_name           = string
    backend_subnet_name            = string
    app_gateway_frontend_subnet_prefix = list(string) # Ensure this is within the VNet range
    app_gateway_backend_subnet_prefix  = list(string) # Ensure this is within the VNet range
    nsg_name                       = string
    public_ip_name                 = string
    public_ip                      = optional(bool, false)
    use_public_ip                  = bool
    public_ip_allocation_method    = string
    public_ip_sku                  = string
    app_gateway_name               = string
    sku_name                       = string
    tier                           = string
    capacity                       = number
    frontend_port_name             = string
    frontend_ip_configuration_name = string
    http_setting_name              = string
    listener_name                  = string
    request_routing_rule_name      = string
    backend_address_pool_name      = string
    backend_addresses              = list(object({
      ip_address = string
    }))
    vm_admin_username              = string
    vm_admin_password              = string
    vm_size                        = string
    ssl_certificate_name           = string
    ssl_certificate_password       = string
    ssl_certificate_content        = string
    health_probe_name              = string
    health_probe_protocol          = string
    health_probe_path              = string
    health_probe_interval          = number
    health_probe_timeout           = number
    health_probe_unhealthy_threshold = number
    key_vault_id                   = string
    access_policies                = map(object({
      tenant_id    = string
      object_id    = string
      permissions  = object({
        keys         = list(string)
        secrets      = list(string)
        certificates = list(string)
      })
    }))
    app_gateway_object_id          = string
  })
  sensitive = true
  default = {
    location                       = "eastus"
    resource_group_name            = "RG-APPGATEWAY"
    tags                           = { environment = "dev", project = "app-gateway-project" }
    vnet_name                      = "vnet-dev-eastus"
    vnet_address_space             = ["10.0.0.0/16"] # Updated to match the actual VNet range
    appgw_subnet_address_space     = ["10.0.1.0/24"] # Updated to fit within the VNet range
    frontend_subnet_name           = "frontend-subnet"
    backend_subnet_name            = "backend-subnet"
    app_gateway_frontend_subnet_prefix = ["10.0.2.0/24"] # Updated to fit within the VNet range
    app_gateway_backend_subnet_prefix  = ["10.0.3.0/24"] # Updated to fit within the VNet range
    nsg_name                       = "nsg-app-gateway"
    public_ip_name                 = "pip-app-gateway"
    public_ip                      = true
    use_public_ip                  = true
    public_ip_allocation_method    = "Static"
    public_ip_sku                  = "Standard"
    app_gateway_name               = "app-gateway"
    sku_name                       = "WAF_v2"
    tier                           = "WAF_v2"
    capacity                       = 2
    frontend_port_name             = "http-port"
    frontend_ip_configuration_name = "app-gateway-frontend-ip"
    http_setting_name              = "app-gateway-http-settings"
    listener_name                  = "app-gateway-http-listener"
    request_routing_rule_name      = "app-gateway-routing-rule"
    backend_address_pool_name      = "app-gateway-backend-pool"
    backend_addresses              = [
      { ip_address = "10.0.4.4" },
      { ip_address = "10.0.4.5" }
    ]
    vm_admin_username              = "azureuser"
    vm_admin_password              = "A1b@C#d$E5f^G&h*J2k!L3m"
    vm_size                        = "Standard_DS1_v2"
    ssl_certificate_name           = "default-ssl-cert"
    ssl_certificate_password       = "your-ssl-password"
    ssl_certificate_content        = "your-base64-encoded-certificate-content"
    health_probe_name              = "app-gateway-health-probe"
    health_probe_protocol          = "Http"
    health_probe_path              = "/health"
    health_probe_interval          = 30
    health_probe_timeout           = 30
    health_probe_unhealthy_threshold = 3
    key_vault_id                   = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY/providers/Microsoft.KeyVault/vaults/kv-app-gateway"
    access_policies                = {
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
    app_gateway_object_id          = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/RG-APPGATEWAY/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-gateway-identity"
  }
}