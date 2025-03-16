# Output the resource group name
output "resource_group_name" {
  description = "The name of the resource group where the policies and initiatives are deployed"
  value       = azurerm_resource_group.rg.name
}

# Output the Policy Definition name
output "policy_definition_name" {
  description = "The name of the custom policy definition"
  value       = azurerm_policy_definition.policy.name
}

# Output the Policy Definition ID
output "policy_definition_id" {
  description = "The ID of the custom policy definition"
  value       = azurerm_policy_definition.policy.id
}

# Output the Policy Initiative name
output "policy_initiative_name" {
  description = "The name of the custom policy initiative"
  value       = azurerm_policy_set_definition.initiative.name
}

# Output the Policy Initiative ID
output "policy_initiative_id" {
  description = "The ID of the custom policy initiative"
  value       = azurerm_policy_set_definition.initiative.id
}

# Output the Policy Assignment name
output "policy_assignment_name" {
  description = "The name of the policy assignment"
  value       = azurerm_policy_assignment.assignment.name
}

# Output the Policy Assignment ID
output "policy_assignment_id" {
  description = "The ID of the policy assignment"
  value       = azurerm_policy_assignment.assignment.id
}