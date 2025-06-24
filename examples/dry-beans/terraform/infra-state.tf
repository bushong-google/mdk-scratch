# This file provides infrastructure for the TF state file (stored on GCS).

# Storage API
resource "google_project_service" "gcp_services" {
  project            = var.project_id
  service            = "storage-api.googleapis.com"
  disable_on_destroy = true
}

# # GCS bucket for data
# resource "google_storage_bucket" "tfstate_bucket" {
#   name                        = "${var.project_id}-tfstate"
#   location                    = var.region
#   project                     = var.project_id
#   uniform_bucket_level_access = true
#   public_access_prevention    = "enforced"
#   depends_on                  = [google_project_service.gcp_services]
# }

terraform {
  backend "gcs" {
    bucket = "bushong-exp-2025-tfstate"
    # Will store the default.state file in terraform/state/default.state directory
    # prefix      = "terraform/state"
    # credentials = "./keys.json"
  }
}

