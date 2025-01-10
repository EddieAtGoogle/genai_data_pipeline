# ---------------------------------------------------------------------------------------------------------------------
# Google Cloud Storage Bucket
# Main storage bucket for the data pipeline
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "main" {
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

  # Require secure transport (HTTPS)
  force_destroy = var.force_destroy
  
  # Customer-managed encryption key (if enabled)
  dynamic "encryption" {
    for_each = var.enable_cmek ? [1] : []
    content {
      default_kms_key_name = var.kms_key_name
    }
  }

  # Lifecycle rules
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

  # Temporary file cleanup
  dynamic "lifecycle_rule" {
    for_each = var.enable_lifecycle_rules ? [1] : []
    content {
      condition {
        matches_prefix = ["temp/"]
        age           = var.temp_file_age_days
      }
      action {
        type = "Delete"
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
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket_object" "folders" {
  for_each = toset([
    "raw/",
    "raw/reviews/",
    "processed/",
    "temp/"
  ])

  bucket = google_storage_bucket.main.name
  name   = each.key
  content = ""  # Empty content for folders
}

# ---------------------------------------------------------------------------------------------------------------------
# Logging Configuration
# Enable access logging if specified
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "access_logs" {
  count         = var.enable_access_logs ? 1 : 0
  name          = "${var.project_id}-consumer-reviews-logs"
  project       = var.project_id
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  lifecycle_rule {
    condition {
      age = var.log_retention_days
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_logging" "main_logging" {
  count         = var.enable_access_logs ? 1 : 0
  bucket        = google_storage_bucket.main.name
  log_bucket    = google_storage_bucket.access_logs[0].name
  log_object_prefix = "bucket-logs/"
}

# ---------------------------------------------------------------------------------------------------------------------
# Audit Configuration
# Enable audit logging if specified
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket_iam_audit_config" "audit_config" {
  count  = var.enable_audit_logs ? 1 : 0
  bucket = google_storage_bucket.main.name
  
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}