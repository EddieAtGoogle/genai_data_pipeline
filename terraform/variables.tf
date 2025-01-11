variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The default GCP region"
  type        = string
  default     = "us-central1"
}

variable "dataset_id" {
  description = "The BigQuery dataset ID"
  type        = string
  default     = "consumer_reviews_dataset"
}

variable "git_remote_url" {
  description = "The Git remote URL for the Dataform repository"
  type        = string
}

variable "git_auth_token" {
  description = "The Git authentication token"
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Project Setup Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "set_resource_location_policy" {
  description = "Whether to set organization-level resource location policy"
  type        = bool
  default     = true
}

variable "allowed_regions" {
  description = "List of regions where resources can be created"
  type        = list(string)
  default     = ["us-central1", "us-east1", "us-west1"]
}

variable "enable_apis" {
  description = "Whether to enable required APIs in the project"
  type        = bool
  default     = true
}

variable "validate_billing" {
  description = "Whether to validate billing account configuration"
  type        = bool
  default     = true
}

variable "create_dataform_role" {
  description = "Whether to create custom Dataform role"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Service Accounts Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "enable_key_rotation" {
  description = "Whether to enable key rotation for service accounts"
  type        = bool
  default     = true
}

variable "service_account_prefix" {
  description = "Prefix for service account names"
  type        = string
  default     = "genai"
}

variable "max_key_age_days" {
  description = "Maximum age of service account keys in days"
  type        = number
  default     = 90
}

variable "secret_labels" {
  description = "Labels to apply to secrets"
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_time_based_access" {
  description = "Whether to enable time-based access controls"
  type        = bool
  default     = true
}

variable "custom_role_prefix" {
  description = "Prefix for custom IAM roles"
  type        = string
  default     = "genai"
}

variable "grant_bigquery_admin" {
  description = "Whether to grant BigQuery Admin role"
  type        = bool
  default     = false
}

variable "max_role_members" {
  description = "Maximum number of members per role"
  type        = number
  default     = 10
}

variable "additional_dataform_permissions" {
  description = "Additional permissions for Dataform service account"
  type        = list(string)
  default     = []
}

variable "additional_bigquery_permissions" {
  description = "Additional permissions for BigQuery service account"
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "The geographic location where the dataset should reside"
  type        = string
  default     = "US"
}

variable "owner_email" {
  description = "Email address of the dataset owner"
  type        = string
  default     = null
}

variable "reader_group_email" {
  description = "Email address of the Google Group with read access"
  type        = string
  default     = null
}

variable "restricted_users_group" {
  description = "Email of the Google Group whose members should have restricted access"
  type        = string
  default     = null
}

variable "table_expiration_days" {
  description = "Number of days after which tables will expire"
  type        = number
  default     = null
}

variable "partition_expiration_days" {
  description = "Number of days after which partitions will expire"
  type        = number
  default     = null
}

variable "enable_deletion_protection" {
  description = "Whether to prevent deletion of the table"
  type        = bool
  default     = true
}

variable "enable_column_level_security" {
  description = "Whether to enable column-level security"
  type        = bool
  default     = false
}

variable "enable_row_level_security" {
  description = "Whether to enable row-level security"
  type        = bool
  default     = false
}

variable "require_partition_filter" {
  description = "Whether to require partition filters in queries"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Storage Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "storage_class" {
  description = "The storage class of the bucket"
  type        = string
  default     = "STANDARD"
}

variable "enable_versioning" {
  description = "Whether to enable object versioning"
  type        = bool
  default     = true
}

variable "enable_cmek" {
  description = "Whether to enable Customer-Managed Encryption Keys"
  type        = bool
  default     = false
}

variable "enable_lifecycle_rules" {
  description = "Whether to enable lifecycle management rules"
  type        = bool
  default     = true
}

variable "archive_age_days" {
  description = "Age in days after which objects are transitioned to Coldline storage"
  type        = number
  default     = 90
}

variable "temp_file_age_days" {
  description = "Age in days after which temporary files are deleted"
  type        = number
  default     = 7
}

variable "enable_access_logs" {
  description = "Whether to enable access logging"
  type        = bool
  default     = false
}

variable "enable_audit_logs" {
  description = "Whether to enable audit logging"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Number of days to retain access logs"
  type        = number
  default     = 30
}

variable "min_retention_days" {
  description = "Minimum number of days to retain objects"
  type        = number
  default     = 1
}

variable "bucket_name" {
  description = "Override the default bucket name (defaults to project_id-consumer-reviews)"
  type        = string
  default     = ""
}