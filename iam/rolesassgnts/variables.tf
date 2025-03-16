
# Define variables for reusability and best practices
variable "role_assignment_name" {
  description = "The name of the Role Assignment"
  type        = string
}

variable "principal_id" {
  description = "The Object ID of the principal (user, group, or service principal)"
  type        = string
}

variable "role_definition_name" {
  description = "The name of the Role Definition (e.g., Contributor, Reader)"
  type        = string
}

variable "scope" {
  description = "The scope at which the Role Assignment applies (e.g., subscription, resource group)"
  type        = string
}