variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "location" {
  description = "Region for the storage bucket."
  type        = string
}

variable "bucket_name" {
  description = "Name for the static site bucket."
  type        = string
}

variable "frontend_dir" {
  description = "Directory containing frontend assets to upload."
  type        = string
}

variable "index_document" {
  description = "Index document for the static site."
  type        = string
}

variable "error_document" {
  description = "Error document for the static site."
  type        = string
}
