# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the GCP project where resources will be created"
  type        = string
}

variable "region" {
  description = "The region where the storage bucket will be created"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Basic Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "bucket_name" {
  description = "Override the default bucket name (defaults to project_id-consumer-reviews)"
  type        = string
  default     = ""
}

variable "storage_class" {
  description = "The storage class of the bucket"
  type        = string
  default     = "STANDARD"
  
  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Security Features
# ---------------------------------------------------------------------------------------------------------------------

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

variable "kms_key_name" {
  description = "The KMS key name for CMEK encryption (required if enable_cmek is true)"
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Lifecycle Management
# ---------------------------------------------------------------------------------------------------------------------

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

variable "max_versions" {
  description = "Maximum number of versions to keep per object when versioning is enabled"
  type        = number
  default     = 3
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Logging and Monitoring
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
# Validation Rules
# ---------------------------------------------------------------------------------------------------------------------

variable "min_retention_days" {
  description = "Minimum number of days to retain objects (if set)"
  type        = number
  default     = null

  validation {
    condition     = var.min_retention_days == null || (var.min_retention_days >= 1 && var.min_retention_days <= 3650)
    error_message = "If set, min_retention_days must be between 1 and 3650."
  }
}

