variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "pso-hca-mlops"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_service_list" {
  description = "GCP APIs to enable on the project"
  type        = list(string)
  default = [
    "storage-api.googleapis.com",
  ]
}
