resource "google_service_account" "svc-acct" {
  account_id   = "dry-beans"
  display_name = "Service account for dry beans example"
  project      = var.project_id
}


# GCS roles for the service account:

variable "sa_role_list" {
  description = "GCP roles to add to the service account"
  type        = list(string)
  default = [
    "roles/bigquery.user",
    "roles/storage.objectUser"
  ]
}

resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.sa_role_list)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.svc-acct.email}"
}