output "enabled_apis" {
  description = "List of APIs that have been enabled"
  value       = [for api in google_project_service.required_apis : api.service]
}

# Commented out as the data source is no longer used
# output "project_number" {
#   description = "The project number, useful for service account references"
#   value       = data.google_project.project.number
# }

output "dataform_role_id" {
  description = "The ID of the custom Dataform role (empty if not created)"
  value       = var.create_dataform_role ? google_project_iam_custom_role.dataform_minimal[0].id : null
}

output "project_validation" {
  description = "Indicates if project validation passed"
  value       = "Project validation completed successfully"
  depends_on  = [null_resource.project_validation]
} 