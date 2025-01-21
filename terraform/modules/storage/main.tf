# ---------------------------------------------------------------------------------------------------------------------
# Google Cloud Storage Bucket
# Main storage bucket for the data pipeline
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "main" {
  provider      = google-beta  # Use beta provider for advanced features
  name          = var.bucket_name != "" ? var.bucket_name : "${var.project_id}-consumer-reviews"
  project       = var.project_id
  location      = var.region
  storage_class = var.storage_class

  # Security settings
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  
  # Enable versioning if specified
  versioning {
    enabled = var.enable_versioning
  }

  # Configure unified logging if enabled
  dynamic "logging" {
    for_each = var.enable_access_logs || var.enable_audit_logs ? [1] : []
    content {
      log_bucket        = google_storage_bucket.access_logs[0].name
      log_object_prefix = "logs/"  # Single prefix for all logs
    }
  }

  # Require secure transport (HTTPS)
  force_destroy = var.force_destroy
  
  # Customer-managed encryption key (if enabled)
  dynamic "encryption" {
    for_each = var.enable_cmek ? [1] : []
    content {
      default_kms_key_name = var.kms_key_name
    }
  }

  # Lifecycle rules for old data archival
  dynamic "lifecycle_rule" {
    for_each = var.enable_lifecycle_rules ? [1] : []
    content {
      condition {
        age = var.archive_age_days
      }
      action {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
    }
  }

  # Version cleanup
  dynamic "lifecycle_rule" {
    for_each = var.enable_versioning && var.enable_lifecycle_rules ? [1] : []
    content {
      condition {
        num_newer_versions = var.max_versions
      }
      action {
        type = "Delete"
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Folder Structure
# Create the basic folder structure using objects
# Note: GCS doesn't actually have folders, these are zero-byte objects ending with "/" to simulate folders
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket_object" "folders" {
  for_each = toset([
    "data/",    # Production data files
    "samples/"  # Sample datasets
  ])

  bucket  = google_storage_bucket.main.name
  name    = each.key
  content = " "  # Single space with newline - required for object creation
}

# ---------------------------------------------------------------------------------------------------------------------
# Logging Bucket
# Separate bucket for storing access and audit logs
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "access_logs" {
  count         = var.enable_access_logs || var.enable_audit_logs ? 1 : 0
  provider      = google-beta
  name          = "${var.project_id}-consumer-reviews-logs"
  project       = var.project_id
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Cleanup old logs based on retention policy
  lifecycle_rule {
    condition {
      age = var.log_retention_days
    }
    action {
      type = "Delete"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Configuration
# Grant BigQuery access to read from the bucket (only if service account email is provided)
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket_iam_member" "bigquery_access" {
  count  = var.bigquery_service_account_email != null ? 1 : 0
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.bigquery_service_account_email}"
}