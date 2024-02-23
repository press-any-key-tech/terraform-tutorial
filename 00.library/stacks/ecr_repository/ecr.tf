# ECR public repository
module "ecr_public_repo" {
  source      = "../../providers.aws/modules/ecr"
  environment = var.environment

  name   = "tcp-dummy-services-public"
  public = true

}

# ECR private repository
module "ecr_private_repo" {
  source      = "../../providers.aws/modules/ecr"
  environment = var.environment

  name   = "tcp-dummy-services-private"
  public = false

}
