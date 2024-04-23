output "private_key_pem" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

# output "public_key_openssh" {
#   value = tls_private_key.ssh.public_key_openssh
# }

output "public_ip_address" {
  description = "The public IP address of the VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "public_dns" {
  description = "The public DNS of the VM"
  value       = azurerm_public_ip.public_ip.fqdn
}

