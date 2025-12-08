provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  required_apis = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "eventarc.googleapis.com",
    "firestore.googleapis.com",
    "run.googleapis.com",
    "storage.googleapis.com"
  ]

  frontend_bucket = var.frontend_bucket_name != "" ? var.frontend_bucket_name : "${var.project_id}-notes-web"
}

resource "google_project_service" "services" {
  for_each = toset(local.required_apis)

  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
}

module "firebase" {
  source = "./modules/firebase"

  project_id = var.project_id
  location   = var.region

  depends_on = [google_project_service.services]
}

module "cloud_function" {
  source = "./modules/cloud-function"

  project_id            = var.project_id
  region                = var.region
  function_name         = var.function_name
  entry_point           = var.function_entry_point
  runtime               = var.function_runtime
  source_dir            = var.backend_dir
  max_instance_count    = var.function_max_instances
  min_instance_count    = var.function_min_instances
  memory                = var.function_memory
  timeout_seconds       = var.function_timeout_seconds
  source_bucket_name    = var.function_source_bucket_name
  environment_variables = var.function_environment_variables

  depends_on = [google_project_service.services, module.firebase]
}

module "storage" {
  source = "./modules/storage"

  project_id     = var.project_id
  location       = var.region
  bucket_name    = local.frontend_bucket
  frontend_dir   = var.frontend_dir
  index_document = var.frontend_index_document
  error_document = var.frontend_error_document

  depends_on = [google_project_service.services]
}
