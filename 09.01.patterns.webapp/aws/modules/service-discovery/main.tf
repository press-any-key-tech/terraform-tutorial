################################################################################
# Service discovery configuration
################################################################################

resource "aws_service_discovery_private_dns_namespace" "discovery" {
  name = var.name
  vpc  = var.vpc_id

  description = var.description
}
