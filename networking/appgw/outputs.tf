# Output the public IP address of the VM
output "vm_private_ip" {
  description = "The private IP address of the virtual machine"
  value       = azurerm_network_interface.nic.private_ip_address
}