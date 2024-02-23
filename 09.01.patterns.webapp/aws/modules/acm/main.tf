
# Module      : ACM CERTIFICATE
# Description : This terraform module is used for importing SSL/TLS
#               certificate with validation.
resource "aws_acm_certificate" "import-cert" {

  private_key       = var.private_key
  certificate_body  = var.certificate_body
  certificate_chain = var.certificate_chain
  tags              = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

