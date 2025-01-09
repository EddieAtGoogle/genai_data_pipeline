output "gcs_bucket_name" {
  description = "The name of the GCS bucket for consumer review data"
  value       = module.storage.bucket_name
}

output "bigquery_dataset" {
  description = "The BigQuery dataset ID"
  value       = module.bigquery.dataset_id
}

output "bigquery_table" {
  description = "The BigQuery table ID"
  value       = module.bigquery.table_id
}

output "dataform_repository" {
  description = "The name of the Dataform repository"
  value       = module.dataform.repository_name
}
