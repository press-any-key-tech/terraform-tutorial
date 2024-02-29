################################################################################
# App engine with container
################################################################################


resource "google_storage_bucket" "bucket" {
  location = var.service_location
  name     = format("%s-bucket", var.service_name)
}

resource "google_storage_bucket_object" "object" {
  name    = "app.yaml"
  bucket  = google_storage_bucket.bucket.name
  content = <<EOF
runtime: custom
env: flex

automatic_scaling:
  target_cpu_utilization: 0.65
  min_instances: 1
  max_instances: 10

resources:
  cpu: 1
  memory_gb: 0.5
  disk_size_gb: 10

beta_settings:
  cloud_sql_instances: "my-project:us-central1:my-sql-instance"

deployment:
  container:
    image: europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:gcr
EOF
}


# resource "google_app_engine_application" "app" {
#   project     = var.project_id
#   location_id = var.service_location
# }


resource "google_app_engine_flexible_app_version" "myapp" {
  version_id = "v1"
  service    = "default"

  runtime = "custom"

  deployment {
    container {
      image = "europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:gcr"
    }
  }

  # deployment {
  #   zip {
  #     source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
  #   }
  # }


  liveness_check {
    path = "/docs"
  }

  readiness_check {
    path = "/docs"
  }

  env_variables = {
    port = "8080"
  }

  automatic_scaling {
    cool_down_period = "120s"
    cpu_utilization {
      target_utilization = "0.5"
    }
  }

  network {
    instance_tag = "my-tag"
    name         = "default"
    subnetwork   = "default"
  }

  # depends_on = [google_app_engine_application.app]

}
