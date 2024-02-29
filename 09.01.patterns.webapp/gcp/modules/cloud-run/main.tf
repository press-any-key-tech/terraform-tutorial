################################################################################
# Cloud Run configuration
################################################################################

resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.service_location

  template {
    spec {
      container_concurrency = var.container_concurrency

      containers {
        image = var.image
        resources {
          limits = {
            cpu    = var.limits_cpu
            memory = var.limits_memory
          }
        }
      }
    }
  }

  traffic {
    percent         = var.traffic_percent
    latest_revision = true
  }

}

data "google_iam_policy" "no_auth" {
  binding {
    role = "roles/run.invoker"

    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "public" {
  location    = google_cloud_run_service.service.location
  project     = google_cloud_run_service.service.project
  service     = google_cloud_run_service.service.name
  policy_data = data.google_iam_policy.no_auth.policy_data
}
