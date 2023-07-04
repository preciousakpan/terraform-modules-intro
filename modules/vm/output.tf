output "public_ip" {
  value = azurerm_public_ip.ppip[*].ip_address
}

output "private_ip" {
  value = azurerm_network_interface.pnic[*].private_ip_address
}

output "multiple_ip" {
  value = azurerm_linux_virtual_machine.pvm[*].public_ip_address
}

output "multiple_pip" {
  value = azurerm_linux_virtual_machine.pvm[*].private_ip_address
}
