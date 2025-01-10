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

output "raw_data_path" {
  description = "The path where raw data should be uploaded"
  value       = "gs://${google_storage_bucket.main.name}/raw/reviews/"
}

output "processed_data_path" {
  description = "The path where processed data will be stored"
  value       = "gs://${google_storage_bucket.main.name}/processed/"
}

output "temp_data_path" {
  description = "The path for temporary data storage"
  value       = "gs://${google_storage_bucket.main.name}/temp/"
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Settings
# Information about enabled security features
# ---------------------------------------------------------------------------------------------------------------------

output "versioning_enabled" {
  description = "Whether object versioning is enabled"
  value       = google_storage_bucket.main.versioning[0].enabled
}

output "encryption_type" {
  description = "The type of encryption used (Google-managed or Customer-managed)"
  value       = var.enable_cmek ? "Customer-managed" : "Google-managed"
}

# ---------------------------------------------------------------------------------------------------------------------
# Logging Information
# Details about logging configuration when enabled
# ---------------------------------------------------------------------------------------------------------------------

output "access_logging_enabled" {
  description = "Whether access logging is enabled"
  value       = var.enable_access_logs
}

output "access_logging_bucket" {
  description = "The name of the access logging bucket (if enabled)"
  value       = var.enable_access_logs ? google_storage_bucket.access_logs[0].name : null
}

output "audit_logging_enabled" {
  description = "Whether audit logging is enabled"
  value       = var.enable_audit_logs
}
