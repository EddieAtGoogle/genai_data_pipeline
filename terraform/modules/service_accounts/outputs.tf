# ---------------------------------------------------------------------------------------------------------------------
# Service Account Identifiers
# These outputs provide the email addresses and full names of the service accounts
# Other modules will use these to grant appropriate permissions
# ---------------------------------------------------------------------------------------------------------------------

output "dataform_service_account_email" {
  description = "The email address of the Dataform service account"
  value       = google_service_account.dataform.email
}

output "dataform_service_account_name" {
  description = "The fully-qualified name of the Dataform service account"
  value       = google_service_account.dataform.name
}

output "bigquery_service_account_email" {
  description = "The email address of the BigQuery service account"
  value       = google_service_account.bigquery.email
}

output "bigquery_service_account_name" {
  description = "The fully-qualified name of the BigQuery service account"
  value       = google_service_account.bigquery.name
}

# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager References
# These outputs provide the names of the secrets where service account keys are stored
# Use these to retrieve the keys when needed by other services
# ---------------------------------------------------------------------------------------------------------------------

output "dataform_key_secret_id" {
  description = "The ID of the Secret Manager secret containing the Dataform service account key"
  value       = google_secret_manager_secret.dataform_key.secret_id
}

output "bigquery_key_secret_id" {
  description = "The ID of the Secret Manager secret containing the BigQuery service account key"
  value       = google_secret_manager_secret.bigquery_key.secret_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Key Management Information
# These outputs provide information about key rotation status and timing
# Useful for monitoring and maintenance
# ---------------------------------------------------------------------------------------------------------------------

output "key_rotation_enabled" {
  description = "Whether key rotation is enabled for the service accounts"
  value       = var.enable_key_rotation
}

output "last_rotation_time" {
  description = "Timestamp of the last key rotation (if enabled)"
  value       = var.enable_key_rotation ? null_resource.key_rotation_trigger[0].triggers.rotation_time : "Key rotation not enabled"
} 