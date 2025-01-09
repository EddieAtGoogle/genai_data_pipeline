output "repository_name" {
  description = "The name of the created Dataform repository"
  value       = google_dataform_repository.genai_pipeline.name
}

output "release_config_name" {
  description = "The name of the created release configuration"
  value       = google_dataform_repository_release_config.weekly_release.name
}