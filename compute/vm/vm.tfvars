computevm_config = {
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
