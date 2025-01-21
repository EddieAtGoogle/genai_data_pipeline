# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# These must be set for the pipeline to work
# ---------------------------------------------------------------------------------------------------------------------

project_id     = "genai-pipeline-demo-1"      # The GCP project ID where resources will be created
region         = "us-east1"          # Primary region for resource deployment, typically where most users are located
dataset_id     = "consumer_reviews_dataset"  # Name of the BigQuery dataset that will store the consumer reviews data

# ---------------------------------------------------------------------------------------------------------------------
# Project Setup Configuration
# Only override these if different from module defaults
# ---------------------------------------------------------------------------------------------------------------------

set_resource_location_policy = true                                # Enable location-based access control (default: false)
allowed_regions            = ["us-central1", "us-east1", "us-west1"]  # Regions where resources can be created

# ---------------------------------------------------------------------------------------------------------------------
# Service Accounts Configuration
# Only override these if different from module defaults
# ---------------------------------------------------------------------------------------------------------------------

enable_key_rotation      = true                    # Enable key rotation (default: false)
service_account_prefix   = "genai-pipeline-demo"   # Custom prefix for service account names

# ---------------------------------------------------------------------------------------------------------------------
# IAM Configuration
# Only override these if different from module defaults
# ---------------------------------------------------------------------------------------------------------------------

custom_role_prefix      = "genai-pipeline-demo"   # Prefix for custom IAM roles (e.g., genai.dataform.admin)
dataform_users_group    = "genai-demo-dataform-users@eddietinsley.altostrat.com"  # Required: Google Group for Dataform users

# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Configuration
# Only override these if different from module defaults
# ---------------------------------------------------------------------------------------------------------------------

owner_email                = "admin@eddietinsley.altostrat.com"          # Email of dataset owner
reader_group_email         = "bq-data-readers@eddietinsley.altostrat.com"       # Group email for read access
restricted_users_group     = "bq-restricted-users@eddietinsley.altostrat.com"   # Group with restricted column access

# ---------------------------------------------------------------------------------------------------------------------
# Storage Configuration
# Only override these if different from module defaults
# ---------------------------------------------------------------------------------------------------------------------

# Enable logging features (defaults are false in module)
enable_access_logs      = true          # Enable access logging for audit purposes
enable_audit_logs       = true          # Enable detailed audit logging

# Optional: Override the default bucket name (defaults to project_id-consumer-reviews)
# bucket_name           = "custom-bucket-name"