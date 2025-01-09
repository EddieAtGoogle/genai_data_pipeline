output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = google_storage_bucket.consumer_reviews.name
}
