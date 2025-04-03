environment       = "dev"
location          = "eastus"
project           = "myproject"
subscription_id   = "096534ab-9b99-4153-8505-90d030aa4f08"
tenant_id         = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
cluster_name      = "my-aks-cluster"
resource_group_name = "rg-aks-dev"
dns_prefix        = "myaks"
vm_size           = "Standard_DS2_v2"
node_count        = 3
subnet_id         = ""
linux_vm_size     = "Standard_DS2_v2"
linux_node_count  = 2
windows_vm_size   = "Standard_DS2_v2"
windows_node_count = 1
kubernetes_version = "1.30.10"
tags = {
  Environment = "dev"
  Project     = "myproject"
}

# New variables added to resolve errors
authorized_ip_ranges = ["0.0.0.0/0"] # Replace with specific IP ranges if needed
log_analytics_workspace_id = "your-log-analytics-workspace-id"
api_server_authorized_ip_ranges = ["0.0.0.0/0"] # Replace with specific IP ranges if needed
admin_group_object_ids = [
      "743472b6-0f67-4f53-bd45-a3b34a2e9fe2",
      "cecfb3fd-7113-401a-b3d2-216522cb3202"
    ] # Replace with actual Azure AD group object IDs
vnet_name = "vnet-aks-dev"