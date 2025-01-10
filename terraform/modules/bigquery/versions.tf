# ---------------------------------------------------------------------------------------------------------------------
# Terraform Configuration
# This block specifies the required provider versions and configurations
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Require Terraform version 1.0 or higher
  required_version = ">= 1.0"

  required_providers {
    # Google Cloud provider for BigQuery resources
    # We use this provider for:
    # - Creating and managing datasets
    # - Creating and managing tables
    # - Setting up access controls
    # - Implementing security features
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
} 