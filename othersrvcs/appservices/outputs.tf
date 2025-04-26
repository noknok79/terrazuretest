output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name # Updated to match the correct resource name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name # Updated to match the correct resource name
}

output "webapp_docker_default_hostname" {
  value = azurerm_linux_web_app.webapp_docker.default_hostname
}

output "webapp_nodejs_default_hostname" {
  value = azurerm_linux_web_app.webapp_nodejs.default_hostname
}