provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      Environment  = upper(var.environment)
      Deployment   = lower("Terraform")
      CostCenter   = var.cost_center
      Customer     = var.customer
      Project      = var.project
      Organization = var.organization
    }
  }
  ignore_tags {
    keys = ["cloud", "entorno", "plataforma", "suscripcion"]
  }
}


