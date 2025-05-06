variable "load_balancer_config" {
  type = object({
    location            = string
    resource_group_name = string
    load_balancer_name  = string
    frontend_ip_configs = list(object({
      name                  = string
      public_ip_address_id  = string
      private_ip_address    = optional(string) # Optional if not required
      private_ip_allocation = string           # Required (e.g., "Dynamic" or "Static")
    }))
    vnet_name             = string
    vnet_address_space    = list(string)
    subnet_name           = string
    subnet_address_prefix = list(string)
    nsg_name              = string
    public_ip_name        = string
    backend_pool_name     = optional(string)
    health_probe_name     = optional(string)
    lb_rule_name          = optional(string)
    tags                  = map(string)
  })

  default = {
    location            = "eastus"
    resource_group_name = "RG-LOADBALANCER"
    load_balancer_name  = "load-balancer"
    frontend_ip_configs = [
      {
        name                  = "frontend-ip-1"
        public_ip_address_id  = "/subscriptions/<subscription-id>/resourceGroups/RG-LOADBALANCER/providers/Microsoft.Network/publicIPAddresses/public-ip-load-balancer"
        private_ip_address    = null      # Set to null or a valid IP if required
        private_ip_allocation = "Dynamic" # Use "Static" if a specific IP is required
      }
    ]
    vnet_name             = "vnet-dev-eastus"
    vnet_address_space    = ["10.0.1.0/16"]
    subnet_name           = "subnet-loadbalancer"
    subnet_address_prefix = ["10.0.14.0/24"]
    nsg_name              = "nsg-load-balancer"
    public_ip_name        = "public-ip-load-balancer"
    backend_pool_name     = "backend-pool"
    health_probe_name     = "health-probe"
    lb_rule_name          = "lb-rule"
    tags = {
      environment = "dev"
      project     = "load-balancer"
    }
  }
}
