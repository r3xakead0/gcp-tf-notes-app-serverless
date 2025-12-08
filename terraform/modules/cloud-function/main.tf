locals {
  source_dir         = abspath(var.source_dir)
  source_bucket_name = coalesce(var.source_bucket_name, "${var.project_id}-${var.function_name}-src")
  function_roles = [
    "roles/datastore.user",
    "roles/logging.logWriter",
    "roles/cloudtrace.agent"
  ]
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = local.source_dir
  output_path = "${path.module}/${var.function_name}.zip"
}

resource "google_storage_bucket" "function_source" {
  name     = local.source_bucket_name
  project  = var.project_id
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = true
  storage_class               = "STANDARD"
  public_access_prevention    = "enforced"
}

resource "google_storage_bucket_object" "source_archive" {
  name   = "sources/${var.function_name}-${data.archive_file.function.output_md5}.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.function.output_path
}

resource "google_service_account" "function" {
  account_id   = var.service_account_name
  display_name = "${var.function_name} service account"
}

resource "google_project_iam_member" "function_roles" {
  for_each = toset(local.function_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.function.email}"
}

resource "google_cloudfunctions2_function" "function" {
  name     = var.function_name
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = google_storage_bucket_object.source_archive.bucket
        object = google_storage_bucket_object.source_archive.name
      }
    }
  }

  service_config {
    available_memory   = var.memory
    timeout_seconds    = var.timeout_seconds
    min_instance_count = var.min_instance_count
    max_instance_count = var.max_instance_count
    ingress_settings   = "ALLOW_ALL"

    service_account_email = google_service_account.function.email
    environment_variables = var.environment_variables
  }

  depends_on = [google_project_iam_member.function_roles]
}

resource "google_cloud_run_service_iam_member" "invoker" {
  project  = var.project_id
  location = var.region
  service  = google_cloudfunctions2_function.function.service_config[0].service
  role     = "roles/run.invoker"
  member   = "allUsers"
}
