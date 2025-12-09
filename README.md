# GCP Serverless Notes App (Terraform)

Simple notes application deployed on Google Cloud with a static frontend, a Cloud Functions (2nd gen) backend, and Firestore for storage. Terraform provisions everything: required APIs, storage bucket hosting the site, Firestore database, and the Cloud Function plus its service account.

## Repository layout
- `notes-frontend/` static site uploaded to a public Cloud Storage bucket.
- `notes-backend/` Python 3.11 Cloud Function handling CRUD for notes in Firestore.
- `terraform/` root Terraform configuration and modules for storage, Firestore, and the function.

## Prerequisites
- A GCP project with billing enabled and Firestore allowed in your chosen region.
- `gcloud` authenticated (`gcloud auth application-default login`) and pointing at the project.
- Terraform 1.5+ installed.
- Python 3.11 only if you want to modify or test the function locally.

## Quick deploy
1. Update `terraform/terraform.tfvars` with your `project_id` and `region` (defaults to `us-central1`). Optional overrides are in `terraform/variables.tf`.
2. From `terraform/` run:
   ```bash
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```
3. After apply, note the outputs for `function_url` and `frontend_site_url`. If the function URL differs from the default in `notes-frontend/app.js` (`API_BASE_URL`), update it and re-run `terraform apply` to sync the assets.

## API
- `GET /notes` list notes (sorted newest first)
- `POST /notes` create (`{ "title": "...", "detail": "..." }`)
- `GET /notes/{id}` fetch a note
- `PUT /notes/{id}` update title/detail
- `DELETE /notes/{id}` remove a note

## Cleaning up
Run `terraform destroy` from `terraform/` to remove all created resources (storage bucket, function, Firestore database, service account, and enabled APIs).
