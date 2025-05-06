location              = "eastus"                  # Default Azure region
resource_group_name   = "RG-LOADBALANCER"         # Resource group for the load balancer
vnet_name             = "vnet-dev-eastus"         # Virtual network name
vnet_address_space    = ["10.0.0.0/16"]           # Address space for the virtual network
subnet_name           = "subnet-loadbalancer"     # Subnet name for the load balancer
subnet_address_prefix = ["10.1.1.0/24"]           # Address prefix for the subnet
nsg_name              = "nsg-load-balancer"       # Network security group name
public_ip_name        = "public-ip-load-balancer" # Public IP name for the load balancer
load_balancer_name    = "load-balancer"           # Load balancer name
backend_pool_name     = "backend-pool"            # Backend address pool name
health_probe_name     = "health-probe"            # Health probe name
lb_rule_name          = "lb-rule"                 # Load balancer rule name
tags = {
  environment = "dev"           # Environment tag
  project     = "load-balancer" # Project tag
}