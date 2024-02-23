output "vpc_id" {
  value = module.vpc.vpc_id
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

# TODO: implement on every module
# module "bastion" {
#   count = var.create_bastion ? 1 : 0
#   # other configuration...
# }

# output "bastion_ip" {
#   value = var.create_bastion ? module.bastion[0].public_ip : "No bastion module"
# }


# output "bastion_ip" {
#   value = try(module.bastion.public_ip, "No bastion module")
# }

# output "bastion_endpoint" {
#   value = try(module.bastion.public_dns_name, "No bastion module")
# }

# output "private_key" {
#   description = "The private key"
#   value       = try(module.bastion.private_key, "No bastion module")
#   sensitive   = true
# }


# # Frontend
# output "frontend_bucket_name" {
#   value = try(module.s3_frontend.s3_bucket_name, "No frontend module")
# }

# output "frontend_bucket_website_domain" {
#   value = try(module.s3_frontend.s3_bucket_website_domain, "No frontend module")
# }

# output "frontend_bucket_website_endpoint" {
#   value = try(module.s3_frontend.s3_bucket_website_endpoint, "No frontend module")
# }

# # Backend

# output "backend_bucket_name" {
#   value = try(module.s3_backend.s3_bucket_name, "No backend bucket module")
# }




