# This file provides infrastructure for the TF state file (stored on GCS).

# Storage API
resource "google_project_service" "storage_api" {
  project            = var.project_id
  service            = "storage-api.googleapis.com"
  disable_on_destroy = true
}

# Note: The TF state bucket itself is not referenced in this file because the
#   TF state bucket will not be managed by Terraform.

terraform {
  backend "gcs" {
    bucket     = "bushong-exp-2025-tfstate"
    depends_on = "google_project_service.storage_api"
    # prefix      = "terraform/state"
    # credentials = "./keys.json"
  }
}
