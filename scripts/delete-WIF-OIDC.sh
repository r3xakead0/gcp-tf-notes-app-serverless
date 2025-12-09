#!/bin/bash
# ---------------------------------------------------------------------
# Author: Afu Tse
# GitHub Repo: https://github.com/r3xakead0/gcp-tf-notes-app-serverless
# Description: Cleanup script for Workload Identity Federation (OIDC)
# ---------------------------------------------------------------------

set -e

export PROJECT_ID="bootcamp-478214"
export ORG_REPO="r3xakead0/gcp-tf-notes-app-serverless"
export SERVICE_ACCOUNT="github-tf-notes-app-serverless"
export POOL_ID="github-pool"
export PROVIDER_ID="github-provider"

# Get PROJECT NUMBER
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID \
  --format="value(projectNumber)")

SA_EMAIL="$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com"

echo "Starting WIF / OIDC cleanup..."

# 1. Remove IAM binding from Service Account
echo "Removing Workload Identity binding from Service Account..."
gcloud iam service-accounts remove-iam-policy-binding \
  $SA_EMAIL \
  --project=$PROJECT_ID \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$POOL_ID/attribute.repository/$ORG_REPO" \
  || echo "Binding already removed"

# 2. Delete OIDC Provider
echo "Deleting OIDC Provider..."
gcloud iam workload-identity-pools providers delete $PROVIDER_ID \
  --project=$PROJECT_ID \
  --location="global" \
  --workload-identity-pool=$POOL_ID \
  --quiet || echo "Provider already deleted"

# 3. Delete Workload Identity Pool
echo "Deleting Workload Identity Pool..."
gcloud iam workload-identity-pools delete $POOL_ID \
  --project=$PROJECT_ID \
  --location="global" \
  --quiet || echo "Pool already deleted"

# 4. Remove project IAM roles from Service Account
echo "Removing project IAM roles from Service Account..."

for ROLE in \
  roles/storage.admin \
  roles/iam.serviceAccountUser \
  roles/iam.securityAdmin \
  roles/cloudresourcemanager.projectIamAdmin \
  roles/editor
do
  gcloud projects remove-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="$ROLE" \
    || echo "Role $ROLE not found or already removed"
done

# 5. Delete Service Account
echo "Deleting Service Account..."
gcloud iam service-accounts delete $SA_EMAIL \
  --project=$PROJECT_ID \
  --quiet || echo "Service Account already deleted"

echo "✅ Cleanup completed successfully."
