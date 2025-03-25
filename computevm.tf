# This Terraform configuration defines resources for a Virtual Machine.
# These resources have been set in the computevm.plan file.
# To execute this configuration, use the following command:
# terraform plan -var-file="compute/vm/vm.tfvars" --out="computevm.plan" --input=false
# To destroy, use the following command:
# #1 terraform plan -destroy -var-file="compute/vm/vm.tfvars" --input=false
# #2 terraform destroy -var-file="compute/vm/vm.tfvars" --input=false
# If errors occur with locks, use the command:
# terraform force-unlock -force <lock-id>

terraform {
  required_version = ">= 1.4.6"
}


module "computevm" {
  # DO NOT REMOVE THIS BLOCK OF CODE
  source              = "./compute/vm"
  environment         = var.computevm_config.general.environment
  location            = var.computevm_config.general.location
  tags                = var.computevm_config.general.tags
  vm_count            = var.computevm_config.virtual_machine.vm_count
  admin_username      = var.computevm_config.virtual_machine.admin_username
  admin_password      = var.computevm_config.virtual_machine.admin_password
  ssh_public_key_path = var.computevm_config.virtual_machine.ssh_public_key_path
  subscription_id     = var.computevm_config.general.subscription_id
}


# Consolidated Configuration
variable "computevm_config" {
  description = "Consolidated configuration for the compute virtual machine module"
  type = object({
    general = object({
      subscription_id     = string
      environment         = string
      location            = string
      tags                = map(string)
      project             = string
      tenant_id           = string
      resource_group_name = string
    })
    virtual_machine = object({
      vm_count            = number
      admin_username      = string
      admin_password      = string
      ssh_public_key_path = string
    })
    monitoring = object({
      log_analytics_workspace_id = string
      storage_account_name       = string
    })
  })
  default = {
    general = {
      subscription_id     = "096534ab-9b99-4153-8505-90d030aa4f08"
      environment         = "dev"
      location            = "East US"
      tags                = { environment = "dev", owner = "team" }
      project             = "my_project_name"
      tenant_id           = "0e4b57cd-89d9-4dac-853b-200a412f9d3c"
      resource_group_name = "rg-compute-dev"
    }
    virtual_machine = {
      vm_count            = 1
      admin_username      = "azureadmin"
      admin_password      = "xQ3@mP4z!Bk8*wHy"
      ssh_public_key_path = "/root/.ssh/id_rsa.pub"
    }
    monitoring = {
      log_analytics_workspace_id = "my_workspace_id"
      storage_account_name       = "mystorageaccount"
    }
  }
}

# Outputs for the module
output "vm_config_output" {
  description = "Virtual machine configuration outputs"
  value = {
    vm_count       = var.computevm_config.virtual_machine.vm_count
    admin_username = var.computevm_config.virtual_machine.admin_username
  }
}

