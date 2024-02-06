output "vpc_id" {
  value = module.vpc.aws_vpc_id
}

output "vpc_private_subnets_ids" {
  value = module.vpc.private_subnet_ids
}

output "vpc_private_subnets_azs" {
  value = module.vpc.private_subnet_azs
}


output "vpc_public_subnets_ids" {
  value = module.vpc.public_subnet_ids
}

output "vpc_public_subnets_azs" {
  value = module.vpc.public_subnet_azs
}


output "bastion_ip" {
  value = module.bastion.public_ip
}

output "bastion_endpoint" {
  value = module.bastion.public_dns_name
}

