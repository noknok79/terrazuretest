subscription_id                        = "096534ab-9b99-4153-8505-90d030aa4f08" // Azure subscription ID // Azure service principal client secret
tenant_id                              = "0e4b57cd-89d9-4dac-853b-200a412f9d3c" // Azure Active Directory tenant ID
environment                            = "dev"                                  // Environment name
location                               = "eastus"                               // Azure region

tags = {                                                                        // Tags to apply to resources
  environment = "dev"
  owner       = "team"
}

admin_username                         = "adminuser"                            // Admin username for the virtual machine
admin_password                         = "A*m0]pEB,m#F]h#~<^S-4/Bc,Zp;Qa"       // Admin password for the virtual machine
ssh_public_key_path                    = "/root/.ssh/id_rsa.pub"     // Path to the SSH public key file

rg_vmss                                = "rg-vmss-dev"                          // Resource group name
vnet_name                              = "vnet-vmss-dev"                        // Virtual network name
vnet_address_space                     = ["10.0.0.0/16"]                        // Virtual network address space

subnet_name                            = "subnet-vmss-dev"                      // Subnet name
subnet_address_prefixes                = ["10.0.1.0/24"]                        // Subnet address prefixes
subnet_id                              = "place-holder-for-subnet-id"           // Subnet ID (replace with actual value)

nsg_name                               = "nsg-vmss-dev"                         // Network Security Group name
nsg_rule_name                          = "Allow-SSH"                            // NSG rule name
nsg_rule_priority                      = 1001                                   // NSG rule priority
nsg_rule_direction                     = "Inbound"                              // NSG rule direction
nsg_rule_access                        = "Allow"                                // NSG rule access
nsg_rule_protocol                      = "Tcp"                                  // NSG rule protocol
nsg_rule_source_port_range             = "*"                                    // NSG rule source port range
nsg_rule_destination_port_range        = "22"                                   // NSG rule destination port range
nsg_rule_source_address_prefix         = "*"                                    // NSG rule source address prefix
nsg_rule_destination_address_prefix    = "*"                                    // NSG rule destination address prefix

nic_name                               = "nic-vmss-dev"                         // Network interface name
nic_ip_config_name                     = "ipconfig-vmss-dev"                    // NIC IP configuration name
nic_ip_allocation                      = "Dynamic"                              // NIC IP allocation method

vmss_name                              = "vmss-dev"                             // VM Scale Set name
vmss_sku                               = "Standard_DS1_v2"                      // VM Scale Set SKU
vmss_instances                         = 2                                      // Number of instances in the VM Scale Set
vmss_image_publisher                   = "Canonical"                            // VMSS image publisher
vmss_image_offer                       = "UbuntuServer"                         // VMSS image offer
vmss_image_sku                         = "18.04-LTS"                            // VMSS image SKU
vmss_image_version                     = "latest"                               // VMSS image version
vmss_os_disk_caching                   = "ReadWrite"                            // VMSS OS disk caching
vmss_os_disk_storage_account_type      = "Standard_LRS"                         // VMSS OS disk storage account type
vmss_ip_config_name                    = "vmss-ip-config"                       // VMSS IP configuration name

public_ip_enabled                      = true                                   // Enable public IP for the VM Scale Set
load_balancer_id                       = "place-holder-for-load-balancer-id"    // Load Balancer ID (replace with actual value)
backend_pool_id                        = "place-holder-for-backend-pool-id"     // Backend Pool ID (replace with actual value)
log_analytics_workspace_id             = "place-holder-for-log-analytics-workspace-id" // Log Analytics Workspace ID (replace with actual value)