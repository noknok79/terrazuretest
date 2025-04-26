variable "appgw_config" {
  description = "Configuration for the Application Gateway and related resources."
  type = object({
    location                       = string
    resource_group_name            = string
    tags                           = map(string)
    app_gateway_name               = string
    sku                            = string
    capacity                       = number
    tier                           = string
    vnet_name                      = string
    frontend_subnet_name           = string
    backend_subnet_name            = string
    public_ip_name                 = string
    nsg_name                       = string
    backend_address_pool_name      = string
    frontend_port_name             = string
    frontend_ip_configuration_name = string
    http_setting_name              = string
    listener_name                  = string
    request_routing_rule_name      = string
    ssl_certificate_name           = string
    vm_admin_username              = string
    vm_admin_password              = string
    vm_size                        = string
  })
  sensitive = true
  default = {
    location                       = "eastus"
    resource_group_name            = "RG-APPGATEWAY"
    tags                           = { environment = "production", owner = "team" }
    app_gateway_name               = "app-gateway"
    sku                            = "Standard_v2"
    capacity                       = 2
    tier                           = "Standard"
    vnet_name                      = "vnet-app-gateway"
    frontend_subnet_name           = "frontend-subnet"
    backend_subnet_name            = "backend-subnet"
    public_ip_name                 = "pip-app-gateway"
    nsg_name                       = "nsg-app-gateway"
    backend_address_pool_name      = "app-gateway-backend-pool"
    frontend_port_name             = "http-port"
    frontend_ip_configuration_name = "app-gateway-frontend-ip"
    http_setting_name              = "app-gateway-http-settings"
    listener_name                  = "app-gateway-http-listener"
    request_routing_rule_name      = "app-gateway-routing-rule"
    ssl_certificate_name           = "app-gateway-ssl-cert"
    vm_admin_username              = "azureuser"
    vm_admin_password              = "A1b@C#d$E5f^G&h*J2k!L3m" # Replace with a secure password
    vm_size                        = "Standard_DS1_v2"
  }
}