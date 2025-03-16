
# Outputs
output "servicebus_namespace_id" {
  description = "The ID of the Service Bus Namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.id
}

output "servicebus_queue_id" {
  description = "The ID of the Service Bus Queue"
  value       = azurerm_servicebus_queue.sb_queue.id
}