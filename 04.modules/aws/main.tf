# Main VPC
module "vpc" {
  source                = "./modules/vpc"
  cidr                  = var.vpc_cidr
  vpc_name              = var.vpc_name
  enable_dns_hostnames  = var.enable_dns_hostnames
  subnets_configuration = var.subnets_configuration

}

# Bastion host for connecting from the outside
module "bastion" {
  source = "./modules/ec2"

  ec2_key_name = var.ec2_key_name

  instance_name = var.instance_name
  instance_type = var.instance_type
  instance_ami  = var.instance_image

  user_data = file("./data/user_data.sh")

  vpc_id           = module.vpc.aws_vpc_id
  az               = module.vpc.public_subnet_azs[2]
  subnet_id        = module.vpc.public_subnet_ids[2]
  instance_ingress = var.instance_ingress

  depends_on = [
    module.vpc
  ]


}

