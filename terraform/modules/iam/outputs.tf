# ---------------------------------------------------------------------------------------------------------------------
# Custom Role Information
# These outputs provide information about the custom roles created
# ---------------------------------------------------------------------------------------------------------------------

output "dataform_executor_role" {
  description = "The ID of the custom Dataform executor role"
  value       = google_project_iam_custom_role.dataform_executor.id
}

output "bigquery_loader_role" {
  description = "The ID of the custom BigQuery loader role"
  value       = google_project_iam_custom_role.bigquery_loader.id
}

# ---------------------------------------------------------------------------------------------------------------------
# Role Assignments
# These outputs list all the role bindings created for each service account
# ---------------------------------------------------------------------------------------------------------------------

output "dataform_role_assignments" {
  description = "List of roles assigned to the Dataform service account"
  value = [
    google_project_iam_custom_role.dataform_executor.id,
    "roles/bigquery.jobUser",
    "roles/dataform.serviceAgent"
  ]
}

output "bigquery_role_assignments" {
  description = "List of roles assigned to the BigQuery service account"
  value = [
    google_project_iam_custom_role.bigquery_loader.id,
    "roles/bigquery.dataEditor",
    "roles/storage.objectViewer"
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Controls
# Information about additional security measures implemented
# ---------------------------------------------------------------------------------------------------------------------

output "time_based_access_enabled" {
  description = "Whether time-based access controls are enabled"
  value       = var.enable_time_based_access
}

output "custom_role_permissions" {
  description = "Map of custom roles and their permissions"
  value = {
    dataform_executor = google_project_iam_custom_role.dataform_executor.permissions
    bigquery_loader  = google_project_iam_custom_role.bigquery_loader.permissions
  }
} 