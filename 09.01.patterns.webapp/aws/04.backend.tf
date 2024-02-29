# ################################################################
# Base Infrastructure
# ################################################################

# ECS cluster (EC2)
module "ecs-cluster" {
  source       = "./modules/ecs-cluster"
  environment  = var.environment
  cluster_name = format("%s-%s", var.environment, var.cluster_name)

  vpc_id = module.vpc.vpc_id
  # "values" is a function that returns a list of values from a map
  vpc_subnets_ids = values(module.vpc.public_subnet_ids)

  lt_ec2_image_id      = var.lt_ec2_image_id
  lt_ec2_instance_type = var.lt_ec2_instance_type
  lt_ec2_key_name      = var.lt_ec2_key_name

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  tags = var.tags

  depends_on = [
    module.vpc
  ]

}


# ################################################################
# Certificate (if any)
# ################################################################

# module "acm-certificate" {
#   source            = "../../modules/acm"
#   environment       = var.environment
#   name              = format("%s-%s-certificate", var.environment, var.project)
#   private_key       = file("${path.cwd}/../../src/tls_certs/certificate.key")
#   certificate_chain = file("${path.cwd}/../../src/tls_certs/certificate.ca.crt")
#   certificate_body  = file("${path.cwd}/../../src/tls_certs/certificate.crt")

# }



# ################################################################
# Application Load Balancer
# ################################################################

module "alb" {
  source      = "./modules/alb"
  environment = var.environment
  project     = var.project
  lb_name     = format("%s-%s-alb", var.environment, var.cluster_name)
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = values(module.vpc.public_subnet_ids)

  listener_port     = var.alb_listener_port
  listener_protocol = var.alb_listener_protocol

  tags = var.tags
}






# module "backend-secret" {
#   source      = "../../modules/secret"
#   environment = var.environment
#   name        = var.backend_configuration_name
#   value       = file("${path.cwd}/../../src/env")
#   # value       = var.backend_configuration_value

# }





# ################################################################
# Backend deploy
# ################################################################

# Namespace for the services
module "service_discovery" {
  source      = "./modules/service-discovery"
  environment = var.environment
  name        = var.namespace_name
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
}


# Bucket for files
module "s3_backend" {
  source                 = "./modules/s3"
  environment            = var.environment
  project                = var.project
  bucket_name            = format("%s-%s-%s", var.environment, var.project, var.backend_bucket_name)
  block_public_access    = true
  enable_website_hosting = false

}


# Log group for the services
module "service_logs_group" {
  source           = "./modules/cloudwatch"
  project          = var.project
  environment      = var.environment
  log_group_prefix = format("ecs/%s", var.cluster_name)
  log_group_name   = "services"
  tags             = var.tags
}


# ECS Service and task
module "tcp_dummy_service_http" {
  source       = "./modules/ecs-service"
  environment  = var.environment
  project      = var.project
  service_name = "http-dummy-services"
  namespace_id = module.service_discovery.namespace_id

  cluster_name = module.ecs-cluster.ecs_cluster_name
  # certificate_arn    = module.acm-certificate.arn
  # load_balancer_port = 443

  alb_arn        = module.alb.alb_arn
  logs_group_arn = module.service_logs_group.logs_group_arn

  vpc_id          = module.vpc.vpc_id
  vpc_subnets_ids = values(module.vpc.private_subnet_ids)

  lb_listener_arn = module.alb.alb_listener_arn

  listener_rule_priority_base = 100

  tasks = [
    {
      container_definition = templatefile("./src/task_tcp_dummy_services_http_container_definition.json", {
        logs-region    = var.region,
        logs-group     = module.service_logs_group.logs_group_name,
        stream_prefix  = "http-dummy-services",
        image          = "670089840758.dkr.ecr.eu-west-1.amazonaws.com/tcp-dummy-services-public:latest",
        container_name = "http-api"
      })
      name                     = "http-dummy-services"
      cpu                      = "512"
      memory                   = "512"
      family                   = "tcp-dummy-http-task"
      container_name           = "http-api"
      port                     = 8000
      min_capacity             = 1
      max_capacity             = 1
      logs_group_arn           = module.service_logs_group.logs_group_arn
      health_check_path        = "/docs"
      health_check_status_code = "200"
      health_check_protocol    = "HTTP"
      path                     = "/http/*"
      # subdomain = "api.example.com"

    }
  ]

  depends_on = [
    module.ecs-cluster,
    module.service_logs_group
  ]

}

# module "tcp_dummy_service_ws" {
#   source       = "./modules/ecs-service"
#   environment  = var.environment
#   project      = var.project
#   service_name = "ws-dummy-services"

#   cluster_name = module.ecs-cluster.ecs_cluster_name
#   # certificate_arn    = module.acm-certificate.arn
#   # load_balancer_port = 443

#   alb_arn        = module.alb.alb_arn
#   logs_group_arn = module.service_logs_group.logs_group_arn

#   vpc_id          = module.vpc.vpc_id
#   vpc_subnets_ids = values(module.vpc.private_subnet_ids)

#   lb_listener_arn = module.alb.alb_listener_arn

#   listener_rule_priority_base = 200

#   tasks = [
#     {
#       container_definition = templatefile("./src/task_tcp_dummy_services_ws_container_definition.json", {
#         logs-region    = var.region,
#         logs-group     = module.service_logs_group.logs_group_name,
#         stream_prefix  = "ws-dummy-services",
#         image          = "670089840758.dkr.ecr.eu-west-1.amazonaws.com/tcp-dummy-services-public:latest",
#         container_name = "ws-api"
#       })
#       name                     = "ws-dummy-services"
#       cpu                      = "512"
#       memory                   = "512"
#       family                   = "tcp-dummy-ws-task"
#       container_name           = "ws-api"
#       port                     = 8000
#       min_capacity             = 1
#       max_capacity             = 1
#       logs_group_arn           = module.service_logs_group.logs_group_arn
#       health_check_path        = "/docs"
#       health_check_status_code = "200"
#       health_check_protocol    = "HTTP"
#       path                     = "/ws/*"
#       # subdomain = "api.example.com"

#     }
#   ]

#   depends_on = [
#     module.ecs-cluster,
#     module.service_logs_group
#   ]

# }



