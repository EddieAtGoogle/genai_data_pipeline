# ---------------------------------------------------------------------------------------------------------------------
# Dataset Information
# Basic dataset details needed by other modules
# ---------------------------------------------------------------------------------------------------------------------

output "dataset_id" {
  description = "The ID of the created dataset"
  value       = google_bigquery_dataset.main.dataset_id
}

output "dataset_location" {
  description = "The geographic location of the dataset"
  value       = google_bigquery_dataset.main.location
}

output "dataset_self_link" {
  description = "The URI of the created dataset"
  value       = google_bigquery_dataset.main.self_link
}

# ---------------------------------------------------------------------------------------------------------------------
# Table Information
# Details about the consumer review table
# ---------------------------------------------------------------------------------------------------------------------

output "table_id" {
  description = "The ID of the consumer review table"
  value       = google_bigquery_table.consumer_review_data.table_id
}

output "table_self_link" {
  description = "The URI of the consumer review table"
  value       = google_bigquery_table.consumer_review_data.self_link
}

output "table_schema" {
  description = "The schema of the consumer review table"
  value       = jsondecode(google_bigquery_table.consumer_review_data.schema)
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Information
# Details about enabled security features
# ---------------------------------------------------------------------------------------------------------------------

output "row_level_security_enabled" {
  description = "Whether row-level security is enabled"
  value       = var.enable_row_level_security
}

output "column_level_security_enabled" {
  description = "Whether column-level security is enabled"
  value       = var.enable_column_level_security
}

# ---------------------------------------------------------------------------------------------------------------------
# Configuration Details
# Information about various configuration settings
# ---------------------------------------------------------------------------------------------------------------------

output "partition_field" {
  description = "The field used for table partitioning"
  value       = "review_ts"
}

output "clustering_fields" {
  description = "The fields used for table clustering"
  value       = google_bigquery_table.consumer_review_data.clustering
}

output "table_expiration" {
  description = "The table expiration setting in days"
  value       = var.table_expiration_days
}

# ---------------------------------------------------------------------------------------------------------------------
# Full Resource Names
# Fully qualified resource names for external references
# ---------------------------------------------------------------------------------------------------------------------

output "full_table_id" {
  description = "The fully qualified table ID in the format: project.dataset.table"
  value       = "${var.project_id}.${google_bigquery_dataset.main.dataset_id}.${google_bigquery_table.consumer_review_data.table_id}"
}

output "full_dataset_id" {
  description = "The fully qualified dataset ID in the format: project.dataset"
  value       = "${var.project_id}.${google_bigquery_dataset.main.dataset_id}"
}
