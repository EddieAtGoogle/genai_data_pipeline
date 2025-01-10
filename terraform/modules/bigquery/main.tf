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
  default_table_expiration_ms    = var.table_expiration_days * 24 * 60 * 60 * 1000

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

  # Labels are key-value pairs attached to resources for organization and billing tracking
  # The merge() function combines multiple maps into one:
  # - First argument: default labels we want to always include
  # - Second argument: user-provided labels that can override or add to defaults
  # Example: merge({a = 1, b = 2}, {b = 3, c = 4}) results in {a = 1, b = 3, c = 4}
  labels = merge({
    environment = var.environment
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

  description = "Consumer review data with sentiment analysis and embeddings"

  # Time-based partitioning configuration
  # - type = "DAY" creates daily partitions
  # - field specifies which column to use for partitioning
  # - require_partition_filter forces queries to specify partition range (cost control)
  time_partitioning {
    type                     = "DAY"
    field                    = "review_ts"
    require_partition_filter = var.require_partition_filter
    expiration_ms           = var.partition_expiration_days * 24 * 60 * 60 * 1000
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
# Row Access Policy
# Implements row-level security if enabled
#
# Row-Level Security (RLS):
# - Filters which rows a user can see based on a predicate (WHERE clause)
# - Use cases:
#   * Limit users to seeing only their department's data
#   * Restrict access based on user's region/territory
#   * Hide sensitive records based on user's clearance
#
# Example predicate: "authorized_brands CONTAINS brand"
# This would only show rows where the user has access to that brand
#
# Note: RLS is applied AFTER the query runs, so it doesn't reduce query costs
# ---------------------------------------------------------------------------------------------------------------------

resource "google_bigquery_row_access_policy" "brand_access" {
  count      = var.enable_row_level_security ? 1 : 0  # Only create if RLS is enabled
  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = google_bigquery_table.consumer_review_data.table_id
  policy_id  = "brand_access_policy"
  project    = var.project_id

  # The filter predicate is a SQL expression that returns true for rows the user can access
  # Default to TRUE if no filter provided (allows all rows - useful for testing)
  filter_predicate = var.row_access_filter != "" ? var.row_access_filter : "TRUE"
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

data "google_iam_policy" "table_policy" {
  count = var.enable_column_level_security && var.restricted_users_group != "" ? 1 : 0

  # Restricted users can see all columns except product_line
  binding {
    role    = "roles/bigquery.dataViewer"
    members = ["group:${var.restricted_users_group}"]

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
resource "google_bigquery_table_iam_policy" "policy" {
  count      = var.enable_column_level_security && var.restricted_users_group != "" ? 1 : 0
  project    = var.project_id
  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = google_bigquery_table.consumer_review_data.table_id

  policy_data = data.google_iam_policy.table_policy[0].policy_data
}