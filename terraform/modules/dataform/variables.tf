# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# These variables must be set when using this module
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID where Dataform resources will be created"
  type        = string
}

variable "region" {
  description = "The region where Dataform resources will be created"
  type        = string
}

variable "dataset_id" {
  description = "The BigQuery dataset ID where Dataform will write its output"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Git Configuration
# These variables are optional. By default, the module will use Dataform's built-in repository.
# Only set these if you want to use your own Git repository.
# ---------------------------------------------------------------------------------------------------------------------

variable "use_remote_git" {
  description = "Whether to use a remote Git repository. If false, uses Dataform's built-in repository (recommended for learning)"
  type        = bool
  default     = false
}

variable "git_remote_url" {
  description = "The URL of the Git repository to use. Only required if use_remote_git is true"
  type        = string
  default     = null
}

variable "git_auth_token" {
  description = "GitHub Personal Access Token for repository access. Only required if use_remote_git is true"
  type        = string
  default     = null
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables
# These variables have defaults and can be optionally overridden
# ---------------------------------------------------------------------------------------------------------------------

variable "secret_id" {
  description = "The ID to use for the Secret Manager secret that stores the Git auth token. Only used if use_remote_git is true"
  type        = string
  default     = "dataform-git-token"
}

variable "repository_name" {
  description = "The name to use for the Dataform repository"
  type        = string
  default     = "genai-pipeline"
}

variable "release_config_name" {
  description = "The name to use for the release configuration"
  type        = string
  default     = "weekly-release"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "release_schedule" {
  description = "Cron schedule for automated releases (default: weekly on Monday at 4 AM)"
  type        = string
  default     = "0 4 * * 1"
}

variable "compilation_location" {
  description = "The location to use for BigQuery operations"
  type        = string
  default     = "US"
}

variable "labels" {
  description = "A map of labels to apply to the Dataform resources"
  type        = map(string)
  default     = {}
}