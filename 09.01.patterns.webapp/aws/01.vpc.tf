# Main VPC
module "vpc" {
  source                = "./modules/vpc"
  cidr                  = var.vpc_cidr
  vpc_name              = var.vpc_name
  enable_dns_hostnames  = var.enable_dns_hostnames
  subnets_configuration = var.subnets_configuration

}

