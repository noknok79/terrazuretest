aks_config = {
  # General configuration
  location    = "East US"             # Azure region where resources will be deployed
  environment = "dev"                 # Environment name (e.g., dev, staging, prod)
  project     = "aks-cluster-testing" # Project name

  # AKS cluster configuration
  kubernetes_version = "1.30.10"         # Kubernetes version for the AKS cluster and node pools
  node_count         = 1                 # Number of nodes in the default node pool
  vm_size            = "Standard_D2s_v3" # VM size for the default node pool

  # Linux node pool configuration
  linux_node_count = 3                # Number of Linux nodes in the AKS cluster
  linux_vm_size    = "Standard_D2_v2" # Size of the Linux VM for the AKS node pool

  # Windows node pool configuration
  windows_node_count = 2                # Number of nodes for the Windows node pool
  windows_vm_size    = "Standard_D2_v2" # Size of the Windows VM for the AKS node pool

  # Networking configuration
  api_server_authorized_ip_ranges = ["0.0.0.0/0"] # List of authorized IP ranges for the AKS API server (replace for security)
  authorized_ip_ranges            = ["0.0.0.0/0"] # Add this variable to resolve the error

  # Azure AD and monitoring configuration
  admin_group_object_ids = [ # List of Azure AD group object IDs for AKS admin access
    "743472b6-0f67-4f53-bd45-a3b34a2e9fe2",
    "cecfb3fd-7113-401a-b3d2-216522cb3202"
  ] # Replace with actual IDs

  log_analytics_workspace_id = "test-log-analytics-workspace-id" # The ID of the Log Analytics Workspace for OMS Agent

  # Azure subscription and tenant
  subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08" # Replace with your subscription ID
  tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c" # Replace with your tenant ID

  # Tags
  tags = {
    Environment = "dev"
    Project     = "aks-cluster-testing"
  }

  # Admin credentials
  admin_password = "xQ3@mP4z!Bk8*wHy" # Admin password for Windows nodes (replace with secure value)
}


