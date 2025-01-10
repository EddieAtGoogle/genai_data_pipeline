# ---------------------------------------------------------------------------------------------------------------------
# Terraform Configuration
# This block specifies the required provider versions and configurations
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Require Terraform version 1.0 or higher
  required_version = ">= 1.0"

  required_providers {
    # Google Cloud provider for IAM resources
    # We use this provider for:
    # - Creating custom IAM roles
    # - Managing IAM bindings
    # - Setting up conditional access
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
} 