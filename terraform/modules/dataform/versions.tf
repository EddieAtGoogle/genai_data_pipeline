# ---------------------------------------------------------------------------------------------------------------------
# Terraform Configuration
# This block specifies the required provider versions and configurations
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Require Terraform version 1.0 or higher
  required_version = ">= 1.0"

  required_providers {
    # Google Cloud Beta provider for Dataform resources
    # Required because Dataform is still in beta
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0"
    }

    # Standard Google Cloud provider for IAM and other stable resources
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
} 