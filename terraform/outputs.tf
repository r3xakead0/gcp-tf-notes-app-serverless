output "function_url" {
  description = "Public URL for the deployed Cloud Function."
  value       = module.cloud_function.url
}

output "function_service_account" {
  description = "Service account used by the Cloud Function."
  value       = module.cloud_function.service_account_email
}

output "frontend_bucket_name" {
  description = "Name of the bucket hosting the static frontend."
  value       = module.storage.bucket_name
}

output "frontend_site_url" {
  description = "URL to access the static frontend."
  value       = module.storage.site_url
}
