# ---------------------------------------------------------------------
# Author: Afu Tse
# GitHub Repo: https://github.com/r3xakead0/gcp-tf-notes-app-serverless
# Description: Workload Identity Federation (OIDC) Setup Script
# ---------------------------------------------------------------------

#!/bin/bash
set -e

export PROJECT_ID="bootcamp-478214"
export ORG_REPO="r3xakead0/gcp-tf-notes-app-serverless"
export SERVICE_ACCOUNT="github-tf-notes-app-serverless"

# Get PROJECT NUMBER
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='get(projectNumber)')

# 1. Create Service Account
echo "Creating Service Account..."
gcloud iam service-accounts create $SERVICE_ACCOUNT \
  --project=$PROJECT_ID \
  --display-name="GitHub Terraform SA"


# 2. Minimum permissions (adjust later)
echo
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"

# 3. Create Workload Identity Pool
echo "Creating Workload Identity Pool..."
gcloud iam workload-identity-pools create github-pool \
  --project=$PROJECT_ID \
  --location="global" \
  --display-name="GitHub Actions Pool"

# 4. Create OIDC Provider
echo "Creating OIDC Provider..."
gcloud iam workload-identity-pools providers create-oidc github-provider \
  --project=$PROJECT_ID \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub Provider" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref,attribute.actor=assertion.actor" \
  --attribute-condition="attribute.repository=='$ORG_REPO'"


# 5. Allow ONLY your repo to use the Service Account
echo "Binding Service Account to Workload Identity Pool..."
gcloud iam service-accounts add-iam-policy-binding \
  $SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/$ORG_REPO"

# 6. Show Pool Info
echo "GCP_PROJECT_ID=$PROJECT_ID"
echo "GCP_SA_EMAIL=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com"
echo "GCP_WIF_PROVIDER=projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider"

