output "dataset_id" {
  description = "The ID of the BigQuery dataset"
  value       = google_bigquery_dataset.consumer_reviews.dataset_id
}

output "table_id" {
  description = "The ID of the consumer review table"
  value       = google_bigquery_table.consumer_review_data.table_id
}
