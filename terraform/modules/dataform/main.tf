# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager - Git Authentication Token
# This resource securely stores the Git authentication token
# ---------------------------------------------------------------------------------------------------------------------

resource "google_secret_manager_secret" "git_auth" {
  provider = google-beta
  count    = var.use_remote_git && var.git_auth_token != null ? 1 : 0

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
  count    = var.use_remote_git && var.git_auth_token != null ? 1 : 0

  secret      = google_secret_manager_secret.git_auth[0].id
  secret_data = var.git_auth_token
}

# ---------------------------------------------------------------------------------------------------------------------
# Dataform Repository
# This resource creates a Dataform repository that can optionally use a remote Git repository
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Configuration
  create_secret = var.use_remote_git && var.git_auth_token != null
  repository_name = "${var.repository_name}-${var.environment}"
  secret_id = var.secret_id != null ? var.secret_id : "dataform-git-token"
  
  # Safe reference to secret version
  secret_version = local.create_secret ? google_secret_manager_secret_version.git_token[0].name : null
}

# Create secret for Git token only if using remote Git
resource "google_secret_manager_secret" "git_token" {
  provider = google-beta
  count    = local.create_secret ? 1 : 0

  project   = var.project_id
  secret_id = local.secret_id

  replication {
    auto {}
  }

  labels = merge({
    purpose = "dataform-git-auth"
  }, var.labels)
}

# Store Git token in secret only if using remote Git
resource "google_secret_manager_secret_version" "git_token" {
  provider = google-beta
  count    = local.create_secret ? 1 : 0

  secret      = google_secret_manager_secret.git_token[0].id
  secret_data = var.git_auth_token
}

# Create Dataform repository
resource "google_dataform_repository" "repository" {
  provider = google-beta
  project  = var.project_id
  region   = var.region
  name     = local.repository_name

  # Only include Git configuration if using remote Git
  dynamic "git_remote_settings" {
    for_each = var.use_remote_git ? [1] : []
    content {
      url = var.git_remote_url
      default_branch = "main"
      authentication_token_secret_version = local.secret_version
    }
  }

  workspace_compilation_overrides {
    default_database = var.project_id
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Release Configuration
# Sets up automated releases of Dataform definitions
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dataform_repository_release_config" "weekly" {
  provider         = google-beta
  project          = var.project_id
  region           = var.region
  repository       = google_dataform_repository.repository.name
  name             = var.release_config_name
  
  # Git configuration
  git_commitish    = var.use_remote_git ? "main" : "HEAD"
  
  cron_schedule    = var.release_schedule
  
  code_compilation_config {
    default_database = var.project_id
  }
}