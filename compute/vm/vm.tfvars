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

# Number of virtual machines to create
vm_count = 1

#FOR AKS FIXING ERROR
project                         = "my_project_name"
node_count                      = 3
vm_size                         = "Standard_DS2_v2"
log_analytics_workspace_id      = "my_workspace_id"
api_server_authorized_ip_ranges = ["192.168.1.0/24"]
admin_group_object_ids          = ["group_object_id_1", "group_object_id_2"]
