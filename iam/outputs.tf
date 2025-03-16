# Output the Resource Group details
output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.iam_rg.name
}

output "resource_group_location" {
  description = "The location of the Resource Group"
  value       = azurerm_resource_group.iam_rg.location
}

# Output the Role Assignment details
output "role_assignment_id" {
  description = "The ID of the Role Assignment"
  value       = azurerm_role_assignment.iam_role_assignment.id
}

output "role_assignment_name" {
  description = "The name of the Role Assignment"
  value       = azurerm_role_assignment.iam_role_assignment.name
}

output "role_assignment_scope" {
  description = "The scope of the Role Assignment"
  value       = azurerm_role_assignment.iam_role_assignment.scope
}