# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# These variables must be provided when using this module
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the GCP project where service accounts will be created"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., 'dev', 'prod') - used for labeling and naming"
  type        = string
  default     = "dev"  # Default to dev for learning/testing
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables
# These variables have defaults and can be optionally overridden
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_key_rotation" {
  description = "Whether to enable service account key rotation (not implemented yet)"
  type        = bool
  default     = false
}

variable "service_account_prefix" {
  description = "Prefix to be used in service account names for uniqueness"
  type        = string
  default     = ""  # Empty default means no prefix
}

variable "secret_labels" {
  description = "Additional labels to apply to secrets in Secret Manager"
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# Validation Rules
# These help catch common mistakes and ensure proper variable values
# ---------------------------------------------------------------------------------------------------------------------

variable "max_key_age_days" {
  description = "Maximum age of service account keys in days before rotation (if enabled)"
  type        = number
  default     = 90

  validation {
    condition     = var.max_key_age_days >= 30 && var.max_key_age_days <= 365
    error_message = "Key age must be between 30 and 365 days."
  }
} 