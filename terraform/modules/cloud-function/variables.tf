variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region for the Cloud Function."
  type        = string
}

variable "function_name" {
  description = "Name of the Cloud Function."
  type        = string
}

variable "runtime" {
  description = "Runtime for the Cloud Function."
  type        = string
}

variable "entry_point" {
  description = "Entry point for the Cloud Function."
  type        = string
}

variable "source_dir" {
  description = "Directory with the Cloud Function source."
  type        = string
}

variable "max_instance_count" {
  description = "Maximum number of function instances."
  type        = number
  default     = 3
}

variable "min_instance_count" {
  description = "Minimum number of function instances."
  type        = number
  default     = 0
}

variable "memory" {
  description = "Memory allocation for the function (e.g., 256M, 512M)."
  type        = string
  default     = "512M"
}

variable "timeout_seconds" {
  description = "Timeout in seconds for the function."
  type        = number
  default     = 60
}

variable "service_account_name" {
  description = "Account ID for the service account used by the function."
  type        = string
  default     = "notes-api-sa"
}

variable "source_bucket_name" {
  description = "Optional override for the bucket that stores the function source archive."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables for the Cloud Run service backing the function."
  type        = map(string)
  default     = {}
}
