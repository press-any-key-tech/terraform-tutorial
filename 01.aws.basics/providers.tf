provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Environment = upper(var.environment)
      Deployment  = lower("Terraform")
      CostCenter  = var.cost_center
      Project     = var.project
    }
  }
  ignore_tags {
    keys = ["cloud", "entorno", "plataforma", "suscripcion"]
  }
}



