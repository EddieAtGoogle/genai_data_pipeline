# ---------------------------------------------------------------------------------------------------------------------
# Dataform Service Account
# This service account will be used by Dataform to:
# - Read and write to BigQuery tables
# - Access the Dataform repository
# - Execute transformations
# ---------------------------------------------------------------------------------------------------------------------
resource "google_service_account" "dataform" {
  account_id   = "dataform-sa"
  display_name = "Dataform Service Account"
  description  = "Service account for Dataform operations in the data pipeline"
  project      = var.project_id
}

# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Service Account
# This service account will be used to:
# - Load data into BigQuery
# - Execute queries
# - Manage BigQuery resources
# ---------------------------------------------------------------------------------------------------------------------
resource "google_service_account" "bigquery" {
  account_id   = "bigquery-sa"
  display_name = "BigQuery Service Account"
  description  = "Service account for BigQuery operations in the data pipeline"
  project      = var.project_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Service Account Keys
# We create keys for service accounts that need them and store them securely in Secret Manager
# This is necessary when services need to authenticate using service account credentials
# ---------------------------------------------------------------------------------------------------------------------

# Create a key for the Dataform service account
resource "google_service_account_key" "dataform" {
  service_account_id = google_service_account.dataform.name
}

# Create a key for the BigQuery service account
resource "google_service_account_key" "bigquery" {
  service_account_id = google_service_account.bigquery.name
}

# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager Secrets
# Store service account keys securely in Secret Manager
# This is more secure than storing keys in files or environment variables
# ---------------------------------------------------------------------------------------------------------------------

# Store Dataform service account key in Secret Manager
resource "google_secret_manager_secret" "dataform_key" {
  secret_id = "dataform-sa-key"
  project   = var.project_id

  replication {
    auto {}
  }

  labels = {
    environment = var.environment
    purpose     = "dataform-auth"
  }
}

# Store the actual key in the secret
resource "google_secret_manager_secret_version" "dataform_key" {
  secret      = google_secret_manager_secret.dataform_key.id
  secret_data = base64decode(google_service_account_key.dataform.private_key)
}

# Store BigQuery service account key in Secret Manager
resource "google_secret_manager_secret" "bigquery_key" {
  secret_id = "bigquery-sa-key"
  project   = var.project_id

  replication {
    auto {}
  }

  labels = {
    environment = var.environment
    purpose     = "bigquery-auth"
  }
}

# Store the actual key in the secret
resource "google_secret_manager_secret_version" "bigquery_key" {
  secret      = google_secret_manager_secret.bigquery_key.id
  secret_data = base64decode(google_service_account_key.bigquery.private_key)
}

# ---------------------------------------------------------------------------------------------------------------------
# Service Account Key Rotation (Optional)
# If enabled, creates a null_resource that can be used to trigger key rotation
# This is a placeholder for implementing automatic key rotation
# ---------------------------------------------------------------------------------------------------------------------
resource "null_resource" "key_rotation_trigger" {
  count = var.enable_key_rotation ? 1 : 0

  triggers = {
    rotation_time = timestamp()  # This will cause the resource to be recreated when applied
  }

  # This is where you would implement key rotation logic
  # For now, it just outputs a message
  provisioner "local-exec" {
    command = "echo 'Key rotation triggered at ${timestamp()}'"
  }
} 