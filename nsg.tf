variable "nsg_config" {
  description = "Configuration for the resources"
  type = object({
    environment         = string
    location            = string
    owner               = string
    allowed_ssh_source  = string
    resource_group_name = string
    nsg_name            = string
    tags                = map(string)
  })
  default = {
    environment         = "dev"                # Default to 'dev' environment
    location            = "eastus"            # Default Azure region
    owner               = "admin@example.com" # Replace with the actual owner email or name
    allowed_ssh_source  = "136.158.57.0/32"   # Replace with your actual IP or range
    resource_group_name = "RG-VNET-EASTUS"    # Default resource group name
    nsg_name            = "nsg-standard"      # Default NSG name
    tags                = {}                  # Default empty tags
  }
}

output "nsg_id" {
  value = module.nsg_standard.nsg_id
}