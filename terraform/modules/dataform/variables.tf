# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# These variables must be set when using this module
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID where Dataform resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region where Dataform resources will be created"
  type        = string
}

variable "dataset_id" {
  description = "The BigQuery dataset ID where Dataform will create and manage tables"
  type        = string
}

variable "git_remote_url" {
  description = "The Git remote URL for the Dataform repository (e.g., 'https://github.com/your-org/your-repo.git')"
  type        = string
}

variable "git_auth_token" {
  description = "The Git authentication token value that will be stored in Secret Manager"
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Secret Manager Configuration
# These variables control how the Git authentication token is stored
# ---------------------------------------------------------------------------------------------------------------------

variable "secret_id" {
  description = "The ID to use for the Secret Manager secret (defaults to 'dataform-git-token')"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Basic Configuration
# These variables have defaults and can be optionally overridden
# ---------------------------------------------------------------------------------------------------------------------

variable "repository_name" {
  description = "The name of the Dataform repository (defaults to 'genai-pipeline')"
  type        = string
  default     = ""
}

variable "release_config_name" {
  description = "The name of the release configuration (defaults to 'weekly-release')"
  type        = string
  default     = ""
}

variable "default_branch" {
  description = "The default Git branch to use for releases"
  type        = string
  default     = "main"
}

variable "environment" {
  description = "The environment name for resource labeling (e.g., 'dev', 'prod')"
  type        = string
  default     = "dev"
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Release Configuration
# These variables control how and when releases are created
# ---------------------------------------------------------------------------------------------------------------------

variable "release_schedule" {
  description = "Cron schedule for automated releases (default: Every Monday at 4am)"
  type        = string
  default     = "0 4 * * 1"

  validation {
    condition     = can(regex("^[0-9*/-]+ [0-9*/-]+ [0-9*/-]+ [0-9*/-]+ [0-9*/-]+$", var.release_schedule))
    error_message = "Release schedule must be a valid cron expression (e.g., '0 4 * * 1' for every Monday at 4am)."
  }
}

variable "compilation_location" {
  description = "The location for BigQuery operations (default: US)"
  type        = string
  default     = "US"

  validation {
    condition     = contains(["US", "EU"], var.compilation_location)
    error_message = "Compilation location must be either 'US' or 'EU'."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Resource Labels
# These variables control resource labeling
# ---------------------------------------------------------------------------------------------------------------------

variable "labels" {
  description = "A map of labels to apply to all resources"
  type        = map(string)
  default     = {}
}