terraform {
  # Specify minimum Terraform version required
  required_version = ">= 1.0"

  required_providers {
    # Standard Google Cloud provider for stable GCP resources
    # Used for:
    # - API enablement (google_project_service)
    # - Project data source (google_project)
    # - IAM roles (google_project_iam_custom_role)
    # - Organization policies (google_project_organization_policy)
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }

    # Beta Google Cloud provider for preview/beta features
    # Required for Dataform resources which are currently in beta:
    # - google_dataform_repository
    # - google_dataform_repository_release_config
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0"
    }

    # Null provider for utility resources that don't create actual infrastructure
    # Used in this module for:
    # - Project validation (null_resource with local-exec provisioner)
    # - Dependency management
    # - Running validation scripts
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
} 