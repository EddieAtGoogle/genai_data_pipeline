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