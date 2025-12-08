output "bucket_name" {
  description = "Static website bucket name."
  value       = google_storage_bucket.site.name
}

output "site_url" {
  description = "URL for the static website."
  value       = "https://storage.googleapis.com/${google_storage_bucket.site.name}/${var.index_document}"
}
