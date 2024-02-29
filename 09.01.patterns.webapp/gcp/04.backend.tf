# ################################################################
# Base Infrastructure
# ################################################################

# Cloud run service
module "cloud-run-service" {
  source           = "./modules/cloud-run"
  environment      = var.environment
  service_name     = format("%s-tcp-dummy-services", var.environment)
  service_location = var.region

  image = "europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:gcr"

  tags = var.common_tags

  # depends_on = [
  #   module.vpc
  # ]

}


# # App Engine service
# module "app-engine-service" {
#   source           = "./modules/app-engine"
#   environment      = var.environment
#   project_id       = var.project_id
#   service_name     = format("%s-tcp-dummy-services", var.environment)
#   service_location = var.region

#   image = "europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:gcr"

#   tags = var.common_tags

#   # depends_on = [
#   #   module.vpc
#   # ]

# }



