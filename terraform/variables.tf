# ---------------------------------------------------------------------------------------------------------------------
# Required Project-Wide Variables
# Core settings needed for project configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The default GCP region for resource deployment"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# ---------------------------------------------------------------------------------------------------------------------
# Project Setup Configuration
# Optional settings for project-wide features
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

# ---------------------------------------------------------------------------------------------------------------------
# Cross-Module Configuration
# Variables that affect multiple modules or service integration
# ---------------------------------------------------------------------------------------------------------------------

variable "dataset_id" {
  description = "The BigQuery dataset ID used across BigQuery and Dataform modules"
  type        = string
  default     = "consumer_reviews_dataset"
}

variable "dataform_users_group" {
  description = "Google Group email for Dataform users (required for IAM configuration)"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Service Account Configuration
# Basic service account settings (detailed configuration in module)
# ---------------------------------------------------------------------------------------------------------------------

variable "service_account_prefix" {
  description = "Prefix for service account names"
  type        = string
  default     = "genai"
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Configuration
# Basic IAM settings (detailed configuration in module)
# ---------------------------------------------------------------------------------------------------------------------

variable "grant_bigquery_admin" {
  description = "Whether to grant BigQuery Admin role to Dataform users"
  type        = bool
  default     = false
}

variable "enable_time_based_access" {
  description = "Whether to enable time-based access controls"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Access Control
# ---------------------------------------------------------------------------------------------------------------------

variable "owner_email" {
  description = "Email address of the BigQuery dataset owner"
  type        = string
}

variable "reader_group_email" {
  description = "Email address of the Google Group with read access to BigQuery"
  type        = string
}

variable "restricted_users_group" {
  description = "Email of the Google Group whose members should have restricted column access"
  type        = string
  default     = null  # Optional - only needed if using column-level security
}
