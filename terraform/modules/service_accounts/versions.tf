# ---------------------------------------------------------------------------------------------------------------------
# Terraform Configuration
# This block specifies the required provider versions and configurations
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Require Terraform version 1.0 or higher
  required_version = ">= 1.0"

  required_providers {
    # Google Cloud provider for creating service accounts and IAM resources
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }

    # Null provider for the key rotation trigger
    # Used to create a resource that can trigger key rotation on-demand
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
} 