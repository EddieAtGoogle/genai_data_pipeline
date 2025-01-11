# ---------------------------------------------------------------------------------------------------------------------
# Terraform Backend Configuration
# ---------------------------------------------------------------------------------------------------------------------
#
# This file configures how Terraform stores its state. By default, it uses local state storage,
# which is suitable for learning and development. For team environments or production use,
# you can enable remote state storage in Google Cloud Storage (GCS) by uncommenting and 
# configuring the backend block below.
#
# Local State (Default):
# - State is stored in a local file (terraform.tfstate)
# - Suitable for individual learning and development
# - No additional setup required
# - NOTE: Local state should not be used for team or production environments
#
# GCS Remote State (Optional):
# - State is stored in a Google Cloud Storage bucket
# - Enables team collaboration
# - Provides state locking to prevent concurrent modifications
# - Offers better security and backup capabilities
# - Required for production environments
#
# To use GCS backend:
# 1. Create a GCS bucket: 
#    gsutil mb -l us-central1 gs://YOUR_PROJECT_ID-terraform-state
#
# 2. Enable versioning:
#    gsutil versioning set on gs://YOUR_PROJECT_ID-terraform-state
#
# 3. Uncomment and configure the backend block below
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Uncomment and configure this block to use GCS for state storage
  /*
  backend "gcs" {
    bucket = "YOUR_PROJECT_ID-terraform-state"
    prefix = "genai-pipeline"
  }
  */
}
