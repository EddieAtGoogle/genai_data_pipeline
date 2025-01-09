resource "google_storage_bucket" "consumer_reviews" {
  name          = "${var.project_id}-consumer-reviews"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
}