variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for Dataform resources"
  type        = string
}

variable "dataset_id" {
  description = "The BigQuery dataset ID"
  type        = string
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