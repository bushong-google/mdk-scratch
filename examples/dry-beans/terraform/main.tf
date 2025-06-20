# GCP APIs
resource "google_project_service" "gcp_services" {
  for_each           = toset(var.gcp_service_list)
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
  depends_on                  = [google_project_service.gcp_services]
}
