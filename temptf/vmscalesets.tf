# Simplified Variable Group: Azure Configuration
variable "vmss_azure" {
  description = "Azure configuration including subscription, tenant, and environment details"
  type = object({
    subscription_id = string
    tenant_id       = string
    environment     = string
    location        = string
    resource_group  = string
    tags            = map(string)
  })
  default = {
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    tenant_id       = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
    environment     = "dev"
    location        = "eastus"
    resource_group  = "RG-VMSS"
    tags = {
      environment = "dev"
      owner       = "team"
    }
  }
}

# Simplified Variable Group: VM and Networking Configuration
variable "vmss_network" {
  description = "Virtual machine and networking configuration"
  type = object({
    admin_username          = string
    admin_password          = string
    ssh_public_key_path     = string
    vnet_name               = string
    vnet_address_space      = list(string)
    subnet_name             = string
    subnet_address_prefixes = list(string)
    subnet_id               = string
    nsg_name                = string
    nsg_rule                = object({
      name                  = string
      priority              = number
      direction             = string
      access                = string
      protocol              = string
      source_port_range     = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string
    })
    nic_name                = string
    nic_ip_config_name      = string
    nic_ip_allocation       = string
    public_ip_enabled       = bool
  })
  default = {
    admin_username          = "adminuser"
    admin_password          = "A*m0]pEB,m#F]h#~<^S-4/Bc,Zp;Qa"
    ssh_public_key_path     = "/root/.ssh/id_rsa.pub"
    vnet_name               = "vnet-dev-eastus"
    vnet_address_space      = ["10.0.0.0/16"]
    subnet_name             = "subnet-vmscaleset"
    subnet_address_prefixes = ["10.0.1.0/24"]
    subnet_id               = "place-holder-for-subnet-id"
    nsg_name                = "nsg-vmss-dev"
    nsg_rule = {
      name                  = "Allow-SSH"
      priority              = 1001
      direction             = "Inbound"
      access                = "Allow"
      protocol              = "Tcp"
      source_port_range     = "*"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
    nic_name                = "nic-vmss-dev"
    nic_ip_config_name      = "ipconfig-vmss-dev"
    nic_ip_allocation       = "Dynamic"
    public_ip_enabled       = true
  }
  sensitive = true
}

# Simplified Variable Group: VM Scale Set Configuration
variable "vmss_config" {
  description = "VM Scale Set configuration including VM and load balancer details"
  type = object({
    name                        = string
    sku                         = string
    instances                   = number
    image                       = object({
      publisher                 = string
      offer                     = string
      sku                       = string
      version                   = string
    })
    os_disk                     = object({
      caching                   = string
      storage_account_type      = string
    })
    ip_config_name              = string
    nic_name                    = string
    load_balancer_id            = string
    backend_pool_id             = string
    log_analytics_workspace_id  = string
  })
  default = {
    name                        = "vmss-dev"
    sku                         = "Standard_DS1_v2"
    instances                   = 2
    image = {
      publisher                 = "Canonical"
      offer                     = "UbuntuServer"
      sku                       = "18.04-LTS"
      version                   = "latest"
    }
    os_disk = {
      caching                   = "ReadWrite"
      storage_account_type      = "Standard_LRS"
    }
    ip_config_name              = "vmss-ip-config"
    nic_name                    = "nic-vmss-dev"
    load_balancer_id            = "place-holder-for-load-balancer-id"
    backend_pool_id             = "place-holder-for-backend-pool-id"
    log_analytics_workspace_id  = "place-holder-for-log-analytics-workspace-id"
  }
}


# Outputs for VMSS
output "vmss_id" {
  description = "The ID of the Virtual Machine Scale Set"
  value       = module.vmss.vmss_id
}

output "vmss_name" {
  description = "The name of the Virtual Machine Scale Set"
  value       = module.vmss.vmss_name
}

output "vmss_instance_count" {
  description = "The current instance count of the Virtual Machine Scale Set"
  value       = module.vmss.instance_count
}
