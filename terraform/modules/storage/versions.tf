# ---------------------------------------------------------------------------------------------------------------------
# Terraform Configuration
# This block specifies the required provider versions and configurations
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Require Terraform version 1.0 or higher
  required_version = ">= 1.0"

  required_providers {
    # Google Cloud provider for storage resources
    # We use this provider for:
    # - Creating and managing GCS buckets
    # - Setting up IAM policies
    # - Configuring logging and monitoring
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
} 