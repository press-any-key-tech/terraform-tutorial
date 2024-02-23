# Module      : ACM CERTIFICATE
# Description : Terraform ACM Certificate module outputs.

output "id" {
  value       = aws_acm_certificate.import-cert.id
  description = "The ID of the Certificate."
}

output "arn" {
  value       = aws_acm_certificate.import-cert.arn
  description = "The ARN of the Certificate."
}

