
output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}


output "public_dns_name" {
  value = aws_instance.ec2_instance.public_dns
}

