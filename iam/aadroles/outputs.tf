
# Output for debugging or reference
output "aad_role_group_id" {
  value = azuread_group.aad_role_group.object_id
}

output "aad_role_assignment_id" {
  value = azuread_directory_role_assignment.aad_role_assignment.id
}