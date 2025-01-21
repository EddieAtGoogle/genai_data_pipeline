# ---------------------------------------------------------------------------------------------------------------------
# Repository Information
# Basic details about the created Dataform repository
# ---------------------------------------------------------------------------------------------------------------------

output "repository_name" {
  description = "The name of the created Dataform repository"
  value       = google_dataform_repository.repository.name
}

output "repository_id" {
  description = "The full resource identifier of the Dataform repository"
  value       = google_dataform_repository.repository.id
}

output "repository_location" {
  description = "The location where the repository is created"
  value       = google_dataform_repository.repository.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Release Configuration
# Details about the release configuration
# ---------------------------------------------------------------------------------------------------------------------

output "release_config_name" {
  description = "The name of the release configuration"
  value       = google_dataform_repository_release_config.weekly.name
}

output "release_schedule" {
  description = "The configured release schedule"
  value       = google_dataform_repository_release_config.weekly.cron_schedule
}

output "release_branch" {
  description = "The Git branch used for releases"
  value       = google_dataform_repository_release_config.weekly.git_commitish
}

output "git_enabled" {
  description = "Whether remote Git integration is enabled"
  value       = var.use_remote_git
}

output "git_remote_url" {
  description = "The configured Git remote URL (if using remote Git)"
  value       = var.use_remote_git ? var.git_remote_url : null
}

# ---------------------------------------------------------------------------------------------------------------------
# Compilation Settings
# Information about how compilations are configured
# ---------------------------------------------------------------------------------------------------------------------

output "compilation_database" {
  description = "The default database (project) used for compilations"
  value       = var.project_id
}

output "compilation_schema" {
  description = "The default schema (dataset) used for compilations"
  value       = google_dataform_repository_release_config.weekly.code_compilation_config[0].default_schema
}

output "compilation_location" {
  description = "The location used for BigQuery operations"
  value       = google_dataform_repository_release_config.weekly.code_compilation_config[0].default_location
}