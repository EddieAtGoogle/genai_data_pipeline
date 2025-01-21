# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# These variables must be set when using this module
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the GCP project where IAM resources will be created"
  type        = string
}

variable "dataform_service_account_email" {
  description = "The email address of the Dataform service account"
  type        = string
}

variable "bigquery_service_account_email" {
  description = "The email address of the BigQuery service account"
  type        = string
}

variable "dataform_users_group" {
  description = "Email address of the Google Group whose members should have Dataform developer access (e.g., 'dataform-users@company.com')"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables
# These variables have defaults and can be optionally overridden
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_time_based_access" {
  description = "Whether to enable time-based access controls (only allows access during business hours)"
  type        = bool
  default     = false
}

variable "custom_role_prefix" {
  description = "Prefix to be used for custom role IDs to ensure uniqueness"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Additional Permission Sets
# These variables control which additional permissions are granted
# ---------------------------------------------------------------------------------------------------------------------

variable "grant_bigquery_admin" {
  description = "Whether to grant BigQuery Admin role instead of just editor (use with caution)"
  type        = bool
  default     = false
}

variable "additional_dataform_permissions" {
  description = "List of additional permissions to add to the Dataform custom role"
  type        = list(string)
  default     = []
}

variable "additional_bigquery_permissions" {
  description = "List of additional permissions to add to the BigQuery custom role"
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Validation Rules
# These help catch common mistakes and ensure proper variable values
# ---------------------------------------------------------------------------------------------------------------------

variable "max_role_members" {
  description = "Maximum number of members that can be bound to a single role"
  type        = number
  default     = 10

  validation {
    condition     = var.max_role_members > 0 && var.max_role_members <= 100
    error_message = "max_role_members must be between 1 and 100."
  }
} 