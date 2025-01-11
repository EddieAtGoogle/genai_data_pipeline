# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager - Git Authentication Token
# This resource securely stores the Git authentication token
# ---------------------------------------------------------------------------------------------------------------------

resource "google_secret_manager_secret" "git_auth" {
  provider = google-beta

  secret_id = var.secret_id != "" ? var.secret_id : "dataform-git-token"
  project   = var.project_id

  replication {
    auto {}
  }

  labels = {
    purpose = "dataform-git-auth"
  }
}

resource "google_secret_manager_secret_version" "git_auth" {
  provider = google-beta

  secret      = google_secret_manager_secret.git_auth.id
  secret_data = var.git_auth_token
}

# ---------------------------------------------------------------------------------------------------------------------
# Dataform Repository
# This resource creates and manages a Dataform repository in your GCP project.
#
# Key Features:
# - Git integration for version control
# - Automated releases
# - Scheduled transformations
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dataform_repository" "genai_pipeline" {
  provider = google-beta  # Dataform requires the beta provider

  name     = var.repository_name != "" ? var.repository_name : "genai-pipeline"
  region   = var.region
  project  = var.project_id

  # Git remote settings for version control
  # This connects your Dataform repository to a Git repository
  git_remote_settings {
    url                                 = var.git_remote_url
    default_branch                      = var.default_branch
    authentication_token_secret_version = google_secret_manager_secret_version.git_auth.name
  }

  depends_on = [google_secret_manager_secret_version.git_auth]
}

# ---------------------------------------------------------------------------------------------------------------------
# Release Configuration
# This resource configures automated releases for your Dataform repository.
#
# Features:
# - Scheduled releases (default: weekly on Monday at 4am)
# - Compilation settings
# - Database configuration
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dataform_repository_release_config" "weekly_release" {
  provider = google-beta

  project    = var.project_id
  region     = var.region
  repository = google_dataform_repository.genai_pipeline.name
  name       = var.release_config_name != "" ? var.release_config_name : "weekly-release"

  # Git branch or commit to release from
  git_commitish = var.default_branch
  
  # Schedule releases using cron syntax
  # Default: Every Monday at 4am
  # Override using var.release_schedule if needed
  cron_schedule = var.release_schedule

  # Compilation configuration for the release
  code_compilation_config {
    default_database = var.project_id
    default_schema   = var.dataset_id
    default_location = var.compilation_location
  }
}