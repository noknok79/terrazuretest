vmss_config = {
  # Subscription ID
  subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"

  # Environment name
  environment = "dev"

  # Azure region
  location = "East US"

  # Tags to apply to resources
  tags = {
    environment = "dev"
    owner       = "team"
  }

  # Admin username for the virtual machine
  admin_username = "azureadmin"

  # Admin password for the virtual machine
  admin_password = "xQ3@mP4z!Bk8*wHy"

  # Path to the SSH public key file
  ssh_public_key_path = "/root/.ssh/id_rsa.pub"

  # Resource group name
  resource_group_name = "rg-vmss-dev"

  # VM Scale Set name
  vmss_name = "vmss-dev"

  # Number of instances in the VM Scale Set
  instance_count = 2

  # VM size
  vm_size = "Standard_DS1_v2"

  # Subnet ID
  subnet_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/subnet-dev"

  # Enable public IP for the VM Scale Set
  public_ip_enabled = true

  # Load Balancer ID
  load_balancer_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.Network/loadBalancers/lb-dev"

  # Backend Pool ID
  backend_pool_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.Network/loadBalancers/lb-dev/backendAddressPools/backendpool-dev"

  # Log Analytics Workspace ID
  log_analytics_workspace_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.OperationalInsights/workspaces/loganalytics-dev"
}
