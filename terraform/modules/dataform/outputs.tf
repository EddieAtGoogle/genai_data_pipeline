# ---------------------------------------------------------------------------------------------------------------------
# Repository Information
# Basic details about the created Dataform repository
# ---------------------------------------------------------------------------------------------------------------------

output "repository_name" {
  description = "The name of the created Dataform repository"
  value       = google_dataform_repository.genai_pipeline.name
}

output "repository_id" {
  description = "The fully qualified identifier of the Dataform repository"
  value       = google_dataform_repository.genai_pipeline.id
}

output "repository_location" {
  description = "The location where the repository is created"
  value       = google_dataform_repository.genai_pipeline.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Release Configuration
# Details about the release configuration
# ---------------------------------------------------------------------------------------------------------------------

output "release_config_name" {
  description = "The name of the created release configuration"
  value       = google_dataform_repository_release_config.weekly_release.name
}

output "release_schedule" {
  description = "The configured release schedule (cron expression)"
  value       = google_dataform_repository_release_config.weekly_release.cron_schedule
}

output "release_branch" {
  description = "The Git branch used for releases"
  value       = google_dataform_repository_release_config.weekly_release.git_commitish
}

# ---------------------------------------------------------------------------------------------------------------------
# Compilation Settings
# Information about how compilations are configured
# ---------------------------------------------------------------------------------------------------------------------

output "compilation_database" {
  description = "The default database (project) used for compilations"
  value       = google_dataform_repository_release_config.weekly_release.code_compilation_config[0].default_database
}

output "compilation_schema" {
  description = "The default schema (dataset) used for compilations"
  value       = google_dataform_repository_release_config.weekly_release.code_compilation_config[0].default_schema
}

output "compilation_location" {
  description = "The location used for BigQuery operations"
  value       = google_dataform_repository_release_config.weekly_release.code_compilation_config[0].default_location
}