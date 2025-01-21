# ---------------------------------------------------------------------------------------------------------------------
# Bucket Information
# Basic bucket details needed by other modules and for reference
# ---------------------------------------------------------------------------------------------------------------------

output "bucket_name" {
  description = "The name of the created storage bucket"
  value       = google_storage_bucket.main.name
}

output "bucket_url" {
  description = "The base URL of the bucket, useful for gsutil and other tools"
  value       = "gs://${google_storage_bucket.main.name}"
}

output "bucket_self_link" {
  description = "The URI of the created bucket"
  value       = google_storage_bucket.main.self_link
}

# ---------------------------------------------------------------------------------------------------------------------
# Folder Paths
# Standard paths within the bucket for different types of data
# ---------------------------------------------------------------------------------------------------------------------

output "data_path" {
  description = "The path where production data files are stored"
  value       = "gs://${google_storage_bucket.main.name}/data/"
}

output "samples_path" {
  description = "The path where sample datasets are stored"
  value       = "gs://${google_storage_bucket.main.name}/samples/"
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Settings
# Information about enabled security features
# ---------------------------------------------------------------------------------------------------------------------

output "versioning_enabled" {
  description = "Whether object versioning is enabled"
  value       = var.enable_versioning
}

output "encryption_type" {
  description = "The type of encryption used (Google-managed or Customer-managed)"
  value       = var.enable_cmek ? "Customer-managed" : "Google-managed"
}

# ---------------------------------------------------------------------------------------------------------------------
# Logging Information
# Details about logging configuration when enabled
# ---------------------------------------------------------------------------------------------------------------------

output "logging_enabled" {
  description = "Whether logging is enabled (access or audit)"
  value       = var.enable_access_logs || var.enable_audit_logs
}

output "logging_bucket" {
  description = "The name of the logging bucket (if enabled)"
  value       = try(google_storage_bucket.access_logs[0].name, null)
}

output "logging_path" {
  description = "The path where logs are stored (if enabled)"
  value       = var.enable_access_logs || var.enable_audit_logs ? "gs://${google_storage_bucket.access_logs[0].name}/logs/" : null
}
