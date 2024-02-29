
# module "s3_frontend" {
#   source      = "./modules/s3"
#   environment = var.environment
#   project     = var.project
#   bucket_name = format("%s-%s-%s", var.environment, var.project, var.frontend_bucket_name)

# }


# module "cdn_frontend" {
#   source      = "./modules/cdn"
#   environment = var.environment
#   project     = var.project
#   origin_id   = format("%s.%s", module.s3_frontend.s3_bucket_name, module.s3_frontend.s3_bucket_website_domain)
#   s3_endpoint = format("%s.%s", module.s3_frontend.s3_bucket_name, module.s3_frontend.s3_bucket_website_domain)
#   # certificate_arn = var.cdn_certificate_arn
#   # domains         = var.cdn_frontend_domains

#   depends_on = [
#     module.s3_frontend
#   ]

# }
