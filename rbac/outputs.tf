
# Output
output "role_assignment_id" {
  description = "The ID of the role assignment."
  value       = azurerm_role_assignment.example.id
}