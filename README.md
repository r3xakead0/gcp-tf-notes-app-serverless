# GCP Serverless Notes App (Terraform)

Serverless notes application on Google Cloud:
- Static frontend served from a public Cloud Storage bucket
- Python 3.11 Cloud Functions (2nd gen) API
- Firestore (native mode) for persistence
- Terraform to provision APIs, storage, Firestore, IAM, and the function

## Repository layout
- `notes-frontend/` static site uploaded to GCS (update `API_BASE_URL` in `app.js` to point at your function).
- `notes-backend/` Cloud Function code (`notes_api` entry point) and `requirements.txt`.
- `terraform/` root config plus modules for storage, Firestore, and the function.
- `.github/workflows/` CI (plan) and CD (apply) Terraform pipelines.

## Prerequisites
- GCP project with billing enabled; Firestore available in your selected `region`.
- Terraform 1.5+.
- `gcloud auth application-default login` against the target project for local runs.
- Optional: Python 3.11 if you want to tweak/test the function locally.

## Configure
Edit `terraform/terraform.tfvars`:
```hcl
project_id = "your-project-id"
region     = "us-central1"
```
Other tunables (bucket name override, function memory/timeout, env vars, etc.) live in `terraform/variables.tf`.

If you change the function URL, update `notes-frontend/app.js` (`API_BASE_URL`) so the static site calls the correct endpoint.

## Deploy with Terraform
From `terraform/`:
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```
Outputs include:
- `frontend_site_url` public URL for the static site
- `function_url` Cloud Functions HTTPS endpoint

## GitHub Actions (optional)
- `.github/workflows/terraform.yml`: plan on PRs/pushes to main/master.
- `.github/workflows/terraform-apply.yml`: apply on push to main/master or manual dispatch.

Set a `GCP_CREDENTIALS` secret containing a JSON service account key with permissions to run Terraform (enough to enable APIs, create buckets, functions, and Firestore). You can swap to Workload Identity Federation if preferred.

## API
- `GET  /notes` list (newest first)
- `POST /notes` create with `{ "title": "...", "detail": "..." }`
- `GET  /notes/{id}` fetch one
- `PUT  /notes/{id}` update title/detail
- `DELETE /notes/{id}` delete

## Cleanup
From `terraform/` run `terraform destroy` to remove the bucket, function, Firestore database, service account, and enabled APIs.
