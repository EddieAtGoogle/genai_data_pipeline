# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Dataset
# Main dataset for consumer review data
#
# Key Concepts:
# - A dataset is a container for tables, views, and other data objects in BigQuery
# - Datasets can be regional (data stored in a specific region) or multi-regional (data replicated across regions)
# - Access controls at the dataset level apply to all tables within the dataset
# ---------------------------------------------------------------------------------------------------------------------

resource "google_bigquery_dataset" "main" {
  dataset_id                      = var.dataset_id
  project                        = var.project_id
  location                       = var.location
  description                    = "Dataset for consumer review analysis and ML processing"
  delete_contents_on_destroy     = var.force_destroy
  default_table_expiration_ms    = var.table_expiration_days != null ? var.table_expiration_days * 24 * 60 * 60 * 1000 : null

  # Access control block defines who can access this dataset
  # Multiple access blocks can be defined for different users/groups
  # Common roles: OWNER (full access), WRITER (can modify data), READER (can query data)
  access {
    role          = "OWNER"
    user_by_email = var.owner_email
  }

  access {
    role           = "READER"
    group_by_email = var.reader_group_email
  }

  # Commenting out conditional access block for now to get basic setup working
  # dynamic "access" {
  #   for_each = var.enable_row_level_security ? [1] : []
  #   content {
  #     view {
  #       dataset_id = google_bigquery_dataset.secure_views[0].dataset_id
  #       project_id = var.project_id
  #       table_id   = google_bigquery_table.secure_view[0].table_id
  #     }
  #   }
  # }

  # Labels are key-value pairs attached to resources for organization and billing tracking
  # The merge() function combines multiple maps into one:
  # - First argument: default labels we want to always include
  # - Second argument: user-provided labels that can override or add to defaults
  # Example: merge({a = 1, b = 2}, {b = 3, c = 4}) results in {a = 1, b = 3, c = 4}
  labels = merge({
    environment = var.environment
    managed_by  = "terraform"
  }, var.labels)

  # Add a small delay to allow for IAM propagation
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Secure Views Dataset (for Row-Level Security)
# Only created if row-level security is enabled
# ---------------------------------------------------------------------------------------------------------------------

resource "google_bigquery_dataset" "secure_views" {
  count         = var.enable_row_level_security ? 1 : 0
  dataset_id    = "${var.dataset_id}_secure_views"
  project       = var.project_id
  location      = var.location
  description   = "Secure views for row-level security"

  access {
    role          = "OWNER"
    user_by_email = var.owner_email
  }

  access {
    role           = "READER"
    group_by_email = var.reader_group_email
  }

  labels = merge({
    environment = var.environment
    managed_by  = "terraform"
    type        = "secure_views"
  }, var.labels)
}

# Create secure view with row-level filtering
resource "google_bigquery_table" "secure_view" {
  count      = var.enable_row_level_security ? 1 : 0
  dataset_id = google_bigquery_dataset.secure_views[0].dataset_id
  table_id   = "filtered_consumer_reviews"
  project    = var.project_id

  deletion_protection = var.enable_deletion_protection

  view {
    query = <<-EOF
      SELECT *
      FROM `${var.project_id}.${var.dataset_id}.consumer_review_data`
      WHERE TRUE  -- Base security filter
      ${var.row_access_filter != "" ? "AND (${var.row_access_filter})" : ""}
    EOF
    use_legacy_sql = false
  }

  labels = merge({
    environment = var.environment
    type        = "secure_view"
    managed_by  = "terraform"
  }, var.labels)
}

# ---------------------------------------------------------------------------------------------------------------------
# Consumer Review Table
# Main table for storing consumer review data
#
# Table Optimization Features:
#
# 1. Partitioning:
#    - Divides table into smaller segments based on a column (usually time-based)
#    - Benefits:
#      * Reduces query costs by scanning only relevant partitions
#      * Improves query performance
#      * Enables partition-level management (e.g., expiration)
#    - In this case, we partition by review_ts (timestamp) on a daily basis
#
# 2. Clustering:
#    - Orders data within each partition based on specified columns
#    - Benefits:
#      * Further reduces query costs by reading less data
#      * Improves performance for queries filtering on clustering columns
#      * Works well with partitioning for compound optimization
#    - We cluster by brand and product_line as these are common filter columns
# ---------------------------------------------------------------------------------------------------------------------

resource "google_bigquery_table" "consumer_review_data" {
  dataset_id          = google_bigquery_dataset.main.dataset_id
  table_id            = "consumer_review_data"
  deletion_protection = var.enable_deletion_protection
  project             = var.project_id
  description         = "Consumer review data with sentiment analysis and embeddings"

  depends_on = [
    google_bigquery_dataset.main
  ]

  # Time-based partitioning configuration
  # - type = "DAY" creates daily partitions
  # - field specifies which column to use for partitioning
  # - require_partition_filter forces queries to specify partition range (cost control)
  time_partitioning {
    type                     = "DAY"
    field                    = "review_ts"
    expiration_ms           = var.partition_expiration_days != null ? var.partition_expiration_days * 24 * 60 * 60 * 1000 : null
  }

  # Clustering configuration
  # - Order matters: queries filtering on brand first will be most efficient
  # - Limit: up to 4 clustering columns
  # - Best for high-cardinality columns (many unique values)
  clustering = [
    "brand",
    "product_line"
  ]

  # Schema definition using jsonencode() to convert HCL to JSON
  # Each field includes:
  # - name: column name
  # - type: data type (STRING, TIMESTAMP, etc.)
  # - mode: REQUIRED (not null), NULLABLE, or REPEATED (array)
  # - description: documents the field's purpose
  schema = jsonencode([
    {
      name = "review_ts"
      type = "TIMESTAMP"
      mode = "REQUIRED"
      description = "Timestamp when the review was created"
    },
    {
      name = "brand"
      type = "STRING"
      mode = "REQUIRED"
      description = "Product brand name"
    },
    {
      name = "sentiment"
      type = "STRING"
      mode = "NULLABLE"
      description = "Analyzed sentiment (positive, negative, neutral)"
    },
    {
      name = "original_content"
      type = "STRING"
      mode = "REQUIRED"
      description = "Original review text"
    },
    {
      name = "content"
      type = "STRING"
      mode = "NULLABLE"
      description = "Processed and cleaned review text"
    },
    {
      name = "product_line"
      type = "STRING"
      mode = "REQUIRED"
      description = "Product category or line"
    },
    {
      name = "text_embedding"
      type = "FLOAT64"
      mode = "REPEATED"
      description = "Vector embedding of the review text for ML processing"
    }
  ])

  # Labels for the table, using merge() to combine default and custom labels
  labels = merge({
    environment = var.environment
    data_type   = "consumer_reviews"
    managed_by  = "terraform"
  }, var.labels)
}

# ---------------------------------------------------------------------------------------------------------------------
# Column Security Policy
# Implements column-level security if enabled
#
# Column-Level Security (CLS) - Beginner-Friendly Implementation:
# By default, all users can see all columns. Only if you specify restricted_users_group
# will those users have limited access (they won't see the product_line column).
#
# This makes it easy for beginners:
# 1. By default, everyone sees everything (no configuration needed)
# 2. To test CLS, just add users to a restricted group
#
# Example:
# - Regular users (default): Can see ALL columns
# - Restricted users (optional): Can see all columns EXCEPT product_line
#
# Note: Unlike RLS, CLS can reduce query costs as restricted columns aren't processed
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Only enable CLS if both the feature flag is true and a restricted group is provided
  enable_cls = var.enable_column_level_security && var.restricted_users_group != null && var.restricted_users_group != ""
  # Define members list based on whether restricted group is provided
  restricted_members = var.restricted_users_group != null && var.restricted_users_group != "" ? ["group:${var.restricted_users_group}"] : []
}

data "google_iam_policy" "table_policy" {
  count = local.enable_cls ? 1 : 0

  # Restricted users can see all columns except product_line (only if group is provided)
  dynamic "binding" {
    for_each = length(local.restricted_members) > 0 ? [1] : []
    content {
      role    = "roles/bigquery.dataViewer"
      members = local.restricted_members

      condition {
        title       = "exclude_product_line"
        description = "Access to all columns except product_line for restricted users"
        expression  = <<-EOT
          resource.type == 'bigquery.googleapis.com/Table' 
          && resource.name.endsWith('consumer_review_data')
          && !resource.name.extract('product_line')
        EOT
      }
    }
  }

  # All other users get full access to all columns (default behavior)
  binding {
    role = "roles/bigquery.dataViewer"
    members = ["allAuthenticatedUsers"]

    condition {
      title       = "full_access"
      description = "Full access to all columns for non-restricted users"
      expression  = <<-EOT
        resource.type == 'bigquery.googleapis.com/Table' 
        && resource.name.endsWith('consumer_review_data')
      EOT
    }
  }
}

# Apply the policy to the table only if CLS is enabled and restricted group is specified
# resource "google_bigquery_table_iam_policy" "policy" {
#   count      = local.enable_cls ? 1 : 0
#   project    = var.project_id
#   dataset_id = google_bigquery_dataset.main.dataset_id
#   table_id   = google_bigquery_table.consumer_review_data.table_id

#   policy_data = data.google_iam_policy.table_policy[0].policy_data
# }