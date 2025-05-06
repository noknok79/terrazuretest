

# output "gateway_frontend_ip" {
#   value = "http://${azurerm_public_ip.pip.ip_address}"
# }
# # # Outputs
# # output "application_gateway_id" {
# #   value = azurerm_application_gateway.app_gateway.id
# # }

# # output "application_gateway_frontend_ip" {
# #   value = azurerm_public_ip.app_gateway_pip.ip_address
# # }

# # # Use the principal_id (UUID) for app_gateway_object_id
# # output "app_gateway_object_id" {
# #   value = azurerm_user_assigned_identity.appgw_identity.principal_id
# # }

# # # Use the id for user_assigned_identity_id
# # output "user_assigned_identity_id" {
# #   value = azurerm_user_assigned_identity.appgw_identity.id
# # }