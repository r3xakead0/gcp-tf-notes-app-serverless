locals {
  frontend_dir   = abspath(var.frontend_dir)
  frontend_files = fileset(local.frontend_dir, "*")
  content_types = {
    css  = "text/css"
    html = "text/html"
    js   = "application/javascript"
    json = "application/json"
  }
}

resource "google_storage_bucket" "site" {
  name     = var.bucket_name
  project  = var.project_id
  location = var.location

  uniform_bucket_level_access = true
  force_destroy               = true
  storage_class               = "STANDARD"
  public_access_prevention    = "inherited"

  website {
    main_page_suffix = var.index_document
    not_found_page   = var.error_document
  }
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "frontend_assets" {
  for_each = { for file in local.frontend_files : file => file }

  name          = each.value
  bucket        = google_storage_bucket.site.name
  source        = "${local.frontend_dir}/${each.value}"
  content_type  = lookup(local.content_types, element(split(each.value, "."), length(split(each.value, ".")) - 1), "application/octet-stream")
  cache_control = "no-cache"
}
