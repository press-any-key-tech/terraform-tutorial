output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.example.public_dns
}

output "private_key" {
  description = "The private key"
  value       = tls_private_key.example.private_key_pem
  sensitive   = true
}
