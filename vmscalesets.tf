# This Terraform configuration defines resources for a Virtual Machine Scale Set.
# To execute this configuration, use:
# terraform plan -var-file="compute/vmscalesets/vmscalesets.tfvars" --out="vmscalesets.plan" --input=false
# To destroy, use:
# terraform destroy -var-file="compute/vmscalesets/vmscalesets.tfvars" --input=false

terraform {
  required_version = ">= 1.4.6"
}

provider "azurerm" {
  features {}
  alias = "vmssazure"
}

# Grouped variable configuration for the VM Scale Set module
module "vmscalesets" {
  source = "./compute/vmscalesets"
  # Removed as it is not expected by the module

  # General configuration
  subscription_id = var.vmss_config.subscription_id
  environment     = var.vmss_config.environment
  location        = var.vmss_config.location
  tags            = var.vmss_config.tags
  rg_vmss         = var.vmss_config.rg_vmss

  # VM Scale Set configuration

  admin_username      = var.vmss_config.admin_username
  admin_password      = var.vmss_config.admin_password
  ssh_public_key_path = var.vmss_config.ssh_public_key_path
}

variable "vmss_config" {
  description = "Configuration for the VM Scale Set"
  type = object({
    vmss_name                  = string
    instance_count             = number
    vm_size                    = string
    admin_username             = string
    admin_password             = string
    ssh_public_key_path        = string
    subnet_id                  = string
    public_ip_enabled          = bool
    load_balancer_id           = string
    backend_pool_id            = string
    log_analytics_workspace_id = string
    subscription_id            = string
    environment                = string
    location                   = string
    tags                       = map(string)
    rg_vmss                    = string
  })
  default = {
    subscription_id = "096534ab-9b99-4153-8505-90d030aa4f08"
    environment     = "dev"
    location        = "East US"
    tags = {
      environment = "dev"
      owner       = "team"
    }
    admin_username             = "azureadmin"
    admin_password             = "xQ3@mP4z!Bk8*wHy"
    ssh_public_key_path        = "/root/.ssh/id_rsa.pub"
    rg_vmss                    = "rg-vmss-dev"
    vmss_name                  = "vmss-dev"
    instance_count             = 2
    vm_size                    = "Standard_DS1_v2"
    subnet_id                  = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.Network/virtualNetworks/vnet-dev/subnets/subnet-dev"
    public_ip_enabled          = true
    load_balancer_id           = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.Network/loadBalancers/lb-dev"
    backend_pool_id            = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.Network/loadBalancers/lb-dev/backendAddressPools/backendpool-dev"
    log_analytics_workspace_id = "/subscriptions/096534ab-9b99-4153-8505-90d030aa4f08/resourceGroups/rg-vmss-dev/providers/Microsoft.OperationalInsights/workspaces/loganalytics-dev"
  }
}

# Consolidated Outputs
output "vmss_outputs" {
  description = "Consolidated outputs for the VM Scale Set"
  value = {
    resource_group_name  = module.vmscalesets.resource_group_name
    virtual_network_name = module.vmscalesets.virtual_network_name
    subnet_name          = module.vmscalesets.subnet_name
    load_balancer_name   = module.vmscalesets.load_balancer_name
    vmss_name            = module.vmscalesets.vmss_name
    vmss_instances       = module.vmscalesets.vmss_instances
    vmss_sku             = module.vmscalesets.vmss_sku
  }
  sensitive = true # Mark outputs as sensitive if they contain sensitive data
}
