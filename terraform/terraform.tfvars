# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# These must be set for the pipeline to work
# ---------------------------------------------------------------------------------------------------------------------

project_id     = "your-project-id"      # The GCP project ID where resources will be created
region         = "us-central1"          # Primary region for resource deployment, typically where most users are located
dataset_id     = "consumer_reviews_dataset"  # Name of the BigQuery dataset that will store the consumer reviews data

# ---------------------------------------------------------------------------------------------------------------------
# Git Configuration
# Required for Dataform repository setup
# ---------------------------------------------------------------------------------------------------------------------

git_remote_url = "https://github.com/your-org/your-repo.git"  # URL of your Git repository containing Dataform definitions
git_auth_token = ""  # GitHub Personal Access Token with repo scope permissions (will be stored securely in Secret Manager)

# ---------------------------------------------------------------------------------------------------------------------
# Optional Dataform Configuration
# These variables control how Dataform operates. Default values are suitable for most use cases.
# Uncomment and modify these if you want to override the defaults
# ---------------------------------------------------------------------------------------------------------------------

# secret_id           = "custom-secret-name"          # Name for the Secret Manager secret storing the Git token
# repository_name     = "custom-repo-name"           # Name of your Dataform repository in GCP
# release_config_name = "custom-release"             # Name for the release configuration
# default_branch      = "main"                       # Git branch containing your Dataform definitions
# environment         = "dev"                        # Deployment environment (dev/staging/prod)
# release_schedule    = "0 4 * * 1"                  # Cron schedule for automated releases (default: Monday 4 AM)
# compilation_location = "US"                        # Region for compiling Dataform code (US/EU/ASIA)

# labels = {                                         # Optional labels for resource organization and cost tracking
#   team        = "data-engineering"
#   cost_center = "12345"
# }

# ---------------------------------------------------------------------------------------------------------------------
# Project Setup Configuration
# Controls basic project settings and API enablement
# ---------------------------------------------------------------------------------------------------------------------

set_resource_location_policy = true                                # Enable location-based access control
allowed_regions            = ["us-central1", "us-east1", "us-west1"]  # Regions where resources can be created
enable_apis               = true                                   # Automatically enable required GCP APIs
validate_billing          = true                                  # Verify billing account is properly configured
create_dataform_role     = true                                  # Create custom IAM role for Dataform

# ---------------------------------------------------------------------------------------------------------------------
# Service Accounts Configuration
# Settings for service account creation and management
# ---------------------------------------------------------------------------------------------------------------------

environment              = "dev"    # Current environment (dev/staging/prod) - affects naming and permissions
enable_key_rotation      = true     # Automatically rotate service account keys (recommended for security)
service_account_prefix   = "genai"  # Prefix for service account names (e.g., genai-dataform@...)
max_key_age_days        = 90       # Maximum age for service account keys before rotation

secret_labels = {                   # Labels applied to secrets in Secret Manager
  environment = "dev"              # Helps identify secrets by environment
  managed_by  = "terraform"        # Indicates these secrets are managed via Terraform
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Configuration
# Security and access control settings
# ---------------------------------------------------------------------------------------------------------------------

enable_time_based_access = true      # Enable time-based access restrictions (recommended for prod)
custom_role_prefix      = "genai"   # Prefix for custom IAM roles (e.g., genai.dataform.admin)
grant_bigquery_admin    = false     # Grant BigQuery Admin role (set to true only if needed)
max_role_members        = 10        # Maximum number of members per IAM role for security

# Additional IAM permissions if needed
additional_dataform_permissions = []  # Extra permissions for Dataform service account
additional_bigquery_permissions = []  # Extra permissions for BigQuery service account

# ---------------------------------------------------------------------------------------------------------------------
# BigQuery Configuration
# Settings for BigQuery dataset and tables
# ---------------------------------------------------------------------------------------------------------------------

location                    = "US"                               # Geographic location for the BigQuery dataset
owner_email                = ""                                 # Email of dataset owner (REQUIRED)
reader_group_email         = ""                                 # Group email for read access (REQUIRED)
restricted_users_group     = ""                                 # Group with restricted column access (optional)
table_expiration_days      = 90                                # Days until tables are auto-deleted (null for no expiration)
partition_expiration_days  = 30                                # Days until partitions are auto-deleted (null for no expiration)
enable_deletion_protection = true                              # Prevent accidental table deletion (recommended)
enable_column_level_security = true                           # Enable column-level access control
enable_row_level_security = false                             # Enable row-level access control
require_partition_filter  = true                              # Require partition filters in queries for better performance

# ---------------------------------------------------------------------------------------------------------------------
# Storage Configuration
# Settings for GCS bucket
# ---------------------------------------------------------------------------------------------------------------------

storage_class           = "STANDARD"    # Storage class for data (STANDARD/NEARLINE/COLDLINE/ARCHIVE)
enable_versioning       = true          # Keep previous versions of objects (recommended for data safety)
enable_cmek             = false         # Use customer-managed encryption keys (requires additional setup)
enable_lifecycle_rules  = true          # Enable automatic object lifecycle management
archive_age_days        = 90            # Days until objects are archived to Coldline storage
temp_file_age_days      = 7             # Days until temporary files are deleted
enable_access_logs      = true          # Enable access logging for audit purposes
enable_audit_logs       = true          # Enable detailed audit logging
log_retention_days      = 30            # Days to retain logs
min_retention_days      = 1             # Minimum days to retain objects

# Optional: Override the default bucket name (defaults to project_id-consumer-reviews)
# bucket_name           = "custom-bucket-name"