# ---------------------------------------------------------------------------------------------------------------------
# Custom Roles
# These roles define specific permissions needed for the data pipeline
# We create custom roles to follow the principle of least privilege
# ---------------------------------------------------------------------------------------------------------------------

# Custom role for Dataform operations
resource "google_project_iam_custom_role" "dataform_executor" {
  role_id     = "dataform.executor"
  title       = "Dataform Executor"
  description = "Custom role for Dataform execution with minimal required permissions"
  permissions = [
    # BigQuery permissions
    "bigquery.datasets.get",
    "bigquery.jobs.create",
    "bigquery.tables.create",
    "bigquery.tables.delete",
    "bigquery.tables.get",
    "bigquery.tables.getData",
    "bigquery.tables.update",
    
    # Dataform permissions
    "dataform.repositories.get",
    "dataform.workspaces.create",
    "dataform.workspaces.get",
    "dataform.compilationResults.create",
    "dataform.compilationResults.get"
  ]
  project = var.project_id
}

# Custom role for BigQuery data loading
resource "google_project_iam_custom_role" "bigquery_loader" {
  role_id     = "bigquery.loader"
  title       = "BigQuery Data Loader"
  description = "Custom role for loading data into BigQuery with minimal required permissions"
  permissions = [
    "bigquery.datasets.get",
    "bigquery.jobs.create",
    "bigquery.tables.create",
    "bigquery.tables.get",
    "bigquery.tables.update",
    "bigquery.tables.updateData",
    "storage.objects.get",
    "storage.objects.list"
  ]
  project = var.project_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Dataform Service Account IAM Bindings
# Grant necessary permissions to the Dataform service account
# ---------------------------------------------------------------------------------------------------------------------

# Grant custom Dataform executor role
resource "google_project_iam_member" "dataform_executor" {
  project = var.project_id
  role    = google_project_iam_custom_role.dataform_executor.id
  member  = "serviceAccount:${var.dataform_service_account_email}"
}

# Grant BigQuery job user role (needed for query execution)
resource "google_project_iam_member" "dataform_bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${var.dataform_service_account_email}"
}

# Grant Dataform service agent role
resource "google_project_iam_member" "dataform_service_agent" {
  project = var.project_id
  role    = "roles/dataform.serviceAgent"
  member  = "serviceAccount:${var.dataform_service_account_email}"
}

# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Service Account IAM Bindings
# Grant necessary permissions to the BigQuery service account
# ---------------------------------------------------------------------------------------------------------------------

# Grant custom BigQuery loader role
resource "google_project_iam_member" "bigquery_loader" {
  project = var.project_id
  role    = google_project_iam_custom_role.bigquery_loader.id
  member  = "serviceAccount:${var.bigquery_service_account_email}"
}

# Grant BigQuery data editor role
resource "google_project_iam_member" "bigquery_data_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.bigquery_service_account_email}"
}

# Grant Storage Object Viewer role (for reading from GCS)
resource "google_project_iam_member" "bigquery_storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${var.bigquery_service_account_email}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Dataform User Access
# Grant necessary permissions to users who need to work with Dataform
# ---------------------------------------------------------------------------------------------------------------------

# Grant Dataform editor access to users
# This role allows users to:
# - Create and edit Dataform definitions
# - Execute Dataform workflows
# - View compilation results
resource "google_project_iam_member" "dataform_developers" {
  project = var.project_id
  role    = "roles/dataform.editor"
  member  = "group:${var.dataform_users_group}"
}

# Grant BigQuery job user access to users
# This role allows users to:
# - Execute BigQuery jobs through Dataform
# - View query results
resource "google_project_iam_member" "dataform_bigquery_users" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "group:${var.dataform_users_group}"
}

# Grant BigQuery data viewer access to users
# This role allows users to:
# - View BigQuery datasets and tables
# - Read data from tables
resource "google_project_iam_member" "dataform_bigquery_viewers" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.dataform_users_group}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional: Additional Security Controls
# These resources are created only if specified in the module variables
# ---------------------------------------------------------------------------------------------------------------------

# Conditional IAM bindings with time-based access
resource "google_project_iam_binding" "time_based_access" {
  count   = var.enable_time_based_access ? 1 : 0
  project = var.project_id
  role    = google_project_iam_custom_role.dataform_executor.id

  members = [
    "serviceAccount:${var.dataform_service_account_email}"
  ]

  condition {
    title       = "access_during_business_hours"
    description = "Only allow access during business hours (8 AM to 6 PM)"
    expression  = "request.time.getHours() >= 8 && request.time.getHours() < 18"
  }
} 