# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the GCP project where resources will be created"
  type        = string
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset to create"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Basic Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "The geographic location where the dataset should reside"
  type        = string
  default     = "US"
}

variable "environment" {
  description = "Environment name for resource labeling"
  type        = string
  default     = "dev"
}

variable "labels" {
  description = "A map of labels to apply to contained resources"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Whether to force the deletion of the dataset and its contents"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Access Control
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Table Configuration
# ---------------------------------------------------------------------------------------------------------------------

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

variable "require_partition_filter" {
  description = "Whether to require partition filters in queries"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Security Features
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_column_level_security" {
  description = "Whether to enable column-level security. By default, all authenticated users can see all columns."
  type        = bool
  default     = false
}

variable "restricted_users_group" {
  description = "Email of the Google Group whose members should NOT see the product_line column (e.g., 'restricted-users@company.com'). Leave empty to allow all users to see all columns."
  type        = string
  default     = ""
}

variable "enable_row_level_security" {
  description = "Whether to enable row-level security"
  type        = bool
  default     = false
}

variable "row_access_filter" {
  description = "The predicate to apply for row-level security"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Validation Rules
# ---------------------------------------------------------------------------------------------------------------------

variable "allowed_regions" {
  description = "List of allowed regions for dataset location"
  type        = list(string)
  default     = ["US", "EU", "us-central1", "us-east1", "us-west1"]

  validation {
    condition     = length(var.allowed_regions) > 0
    error_message = "At least one region must be specified in allowed_regions."
  }
}

variable "min_partition_expiration_days" {
  description = "Minimum number of days for partition expiration"
  type        = number
  default     = 30

  validation {
    condition     = var.min_partition_expiration_days >= 30
    error_message = "Partition expiration must be at least 30 days."
  }
}
