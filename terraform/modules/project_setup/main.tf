# Enable required APIs for the project
resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",  # For project access
    "secretmanager.googleapis.com",         # For storing sensitive data
    "dataform.googleapis.com",              # For Dataform operations
    "bigquery.googleapis.com",              # For BigQuery operations
    "storage.googleapis.com",               # For GCS operations
    "iam.googleapis.com"                    # For IAM operations
  ])

  project = var.project_id
  service = each.value

  # Disable dependent services when API is disabled
  disable_dependent_services = true
  # Disable service on destroy
  disable_on_destroy = false
}

# Check if billing is enabled
# Commented out as it's not needed for project validation
# data "google_project" "project" {
#   project_id = var.project_id
# }

# Validate project setup
resource "null_resource" "project_validation" {
  triggers = {
    project_id = var.project_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      if [[ -z "$(gcloud beta billing projects describe ${var.project_id} --format='get(billingEnabled)')" ]]; then
        echo "Error: Billing is not enabled for project ${var.project_id}"
        exit 1
      fi
    EOT
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional: Custom Role for Dataform (Requires Organization-Level Permissions)
# This block will only be created if create_dataform_role = true and the user has sufficient permissions
# If you don't have permission to create custom roles, set create_dataform_role = false in terraform.tfvars
# and manually grant the following predefined roles instead:
# - roles/dataform.editor
# - roles/bigquery.dataEditor
# ---------------------------------------------------------------------------------------------------------------------

resource "google_project_iam_custom_role" "dataform_minimal" {
  count       = var.create_dataform_role ? 1 : 0
  role_id     = "dataform_minimal"
  title       = "Minimal Dataform Role"
  description = "Minimal set of permissions required for Dataform operations"
  permissions = [
    "dataform.repositories.get",
    "dataform.repositories.list",
    "dataform.workspaces.create",
    "dataform.workspaces.delete",
    "dataform.workspaces.get",
    "dataform.workspaces.list",
    "dataform.workspaces.update"
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional: Resource Location Policy (Requires Organization-Level Permissions)
# This block will only be created if set_resource_location_policy = true and the user has sufficient permissions
# If you don't have organization-level permissions, set set_resource_location_policy = false in terraform.tfvars
# ---------------------------------------------------------------------------------------------------------------------

/* resource "google_project_organization_policy" "resource_location" {
  count      = var.set_resource_location_policy ? 1 : 0
  project    = var.project_id
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    allow {
      values = var.allowed_regions
    }
  }
}  */