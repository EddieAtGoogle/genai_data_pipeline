variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "set_resource_location_policy" {
  description = "Whether to set the resource location organization policy"
  type        = bool
  default     = false
}

variable "allowed_regions" {
  description = "List of allowed GCP regions for resource creation"
  type        = list(string)
  default     = ["us-central1", "us-east1", "us-west1"]
}

variable "enable_apis" {
  description = "Whether to enable the required APIs"
  type        = bool
  default     = true
}

variable "validate_billing" {
  description = "Whether to validate billing is enabled"
  type        = bool
  default     = true
}

variable "create_dataform_role" {
  description = "Whether to create the custom Dataform role"
  type        = bool
  default     = true
} 