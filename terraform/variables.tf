variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Default region for resources."
  type        = string
  default     = "us-central1"
}

variable "frontend_bucket_name" {
  description = "Optional override for the static website bucket name."
  type        = string
  default     = ""
}

variable "frontend_dir" {
  description = "Path to the frontend assets to upload to Cloud Storage."
  type        = string
  default     = "../notes-frontend"
}

variable "frontend_index_document" {
  description = "Index document for the static site."
  type        = string
  default     = "index.html"
}

variable "frontend_error_document" {
  description = "Error document for the static site."
  type        = string
  default     = "index.html"
}

variable "backend_dir" {
  description = "Path to the Cloud Function source code."
  type        = string
  default     = "../notes-backend"
}

variable "function_name" {
  description = "Name for the Cloud Function."
  type        = string
  default     = "notes-api"
}

variable "function_entry_point" {
  description = "Entry point for the Cloud Function."
  type        = string
  default     = "notes_api"
}

variable "function_runtime" {
  description = "Runtime for the Cloud Function."
  type        = string
  default     = "python311"
}

variable "function_memory" {
  description = "Memory allocation for the Cloud Function (e.g., 256M, 512M)."
  type        = string
  default     = "512M"
}

variable "function_timeout_seconds" {
  description = "Timeout in seconds for the Cloud Function."
  type        = number
  default     = 60
}

variable "function_max_instances" {
  description = "Maximum number of instances for the Cloud Function."
  type        = number
  default     = 3
}

variable "function_min_instances" {
  description = "Minimum number of instances for the Cloud Function (use 0 for scale-to-zero)."
  type        = number
  default     = 0
}

variable "function_source_bucket_name" {
  description = "Optional override for the bucket used to stage the Cloud Function source."
  type        = string
  default     = null
}

variable "function_environment_variables" {
  description = "Environment variables to pass to the Cloud Function service config."
  type        = map(string)
  default     = {}
}
