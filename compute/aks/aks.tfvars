# Azure region where resources will be deployed
location = "East US"

# Environment name (e.g., dev, staging, prod)
environment = "dev"

# Project name
project = "aks-cluster-testing"

# Number of nodes in the default node pool
node_count = 3

# VM size for the default node pool
vm_size = "Standard_DS2_v2"

# List of authorized IP ranges for the AKS API server
api_server_authorized_ip_ranges = ["203.0.113.0/24", "198.51.100.0/24"]

# The ID of the Log Analytics Workspace for OMS Agent
log_analytics_workspace_id = "test-log-analytics-workspace-id"

# List of Azure AD group object IDs for AKS admin access
admin_group_object_ids = [
  "743472b6-0f67-4f53-bd45-a3b34a2e9fe2",
  "cecfb3fd-7113-401a-b3d2-216522cb3202"
] # Replace with actual IDs

# Tags to add to all resources
tags = {
  Environment = "dev"
  Project     = "aks-cluster-testing"
}




