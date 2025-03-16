# Output for the Resource Group name
output "resource_group_name" {
  description = "The name of the resource group where the managed disk is created."
  value       = azurerm_resource_group.rg_managed_disks.name
}

# Output for the Managed Disk name
output "managed_disk_name" {
  description = "The name of the managed disk."
  value       = azurerm_managed_disk.managed_disk.name
}

# Output for the Managed Disk ID
output "managed_disk_id" {
  description = "The ID of the managed disk."
  value       = azurerm_managed_disk.managed_disk.id
}

# Output for the Managed Disk size
output "managed_disk_size_gb" {
  description = "The size of the managed disk in GB."
  value       = azurerm_managed_disk.managed_disk.disk_size_gb
}

# Output for the Managed Disk location
output "managed_disk_location" {
  description = "The location of the managed disk."
  value       = azurerm_managed_disk.managed_disk.location
}