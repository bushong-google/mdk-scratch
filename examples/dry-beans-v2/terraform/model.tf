# This file describes infrastructure that is required for our (toy) model.


# GCP APIs:

variable "model_gcp_service_list" {
  description = "GCP APIs to enable in order to run the model"
  type        = list(string)
  default = [
    "storage-api.googleapis.com",
  ]
}

resource "google_project_service" "model_gcp_services" {
  for_each           = toset(var.model_gcp_service_list)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = true
}


# GCS bucket for data
resource "google_storage_bucket" "data_bucket" {
  name                        = "${var.project_id}-data"
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}
