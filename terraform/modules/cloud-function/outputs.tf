output "url" {
  description = "Public URL of the Cloud Function."
  value       = google_cloudfunctions2_function.function.service_config[0].uri
}

output "service_account_email" {
  description = "Service account used by the Cloud Function."
  value       = google_service_account.function.email
}

output "source_bucket" {
  description = "Bucket storing the function source archive."
  value       = google_storage_bucket.function_source.name
}
