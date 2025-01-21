# IAM Module

This module manages IAM roles and permissions for the GenAI Data Pipeline.

## Purpose
- Manages IAM role assignments
- Implements least privilege access
- Configures service account permissions
- Sets up cross-service access
- Manages Dataform user access

## Role Assignments

### 1. Dataform User Access
Users in the Dataform users group receive:
- `roles/dataform.developer`: Create and edit Dataform definitions
- `roles/bigquery.jobUser`: Execute queries through Dataform
- `roles/bigquery.dataViewer`: View BigQuery data

### 2. Service Account Roles
1. BigQuery Roles
   - `roles/bigquery.dataEditor`: For data manipulation
   - `roles/bigquery.jobUser`: For query execution
   
2. Storage Roles
   - `roles/storage.objectViewer`: For reading data
   - `roles/storage.objectCreator`: For uploading data

3. Dataform Roles
   - `roles/dataform.serviceAgent`: For Dataform operations
   - Custom role for specific Dataform permissions

## Security Best Practices
- Principle of least privilege
- Separation of duties
- Regular access review capabilities
- Clear permission documentation

## Usage

### Basic Usage with Dataform User Access
```hcl
module "iam" {
  source              = "./modules/iam"
  project_id          = var.project_id
  dataform_users_group = "dataform-users@company.com"
  
  service_accounts = {
    dataform = module.service_accounts.dataform_service_account_email
    bigquery = module.service_accounts.bigquery_service_account_email
  }
}
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Dataform Access Issues
```bash
# Verify group exists and has members
gcloud identity groups memberships list \
  --group-email=dataform-users@company.com

# Check IAM bindings
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.role:dataform.developer"
```

#### 2. BigQuery Access Issues
```bash
# Verify BigQuery permissions
bq show --project_id=$PROJECT_ID $DATASET_ID

# Check user roles
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.role:bigquery.jobUser"
```

## 📚 Best Practices

### 1. Group Management
- Use Google Groups for role assignment
- Regularly audit group membership
- Document group purpose and access level

### 2. Permission Management
- Grant minimum required permissions
- Use predefined roles when possible
- Document custom role permissions

### 3. Access Reviews
- Regularly review access patterns
- Monitor usage through audit logs
- Remove unused permissions

## Variables
| Name | Description | Type | Required |
|------|-------------|------|----------|
| project_id | The GCP project ID | string | Yes |
| dataform_users_group | Email of the Dataform users group | string | Yes |
| service_accounts | Map of service account emails | map(string) | Yes |

## Outputs
| Name | Description |
|------|-------------|
| dataform_user_roles | List of roles assigned to Dataform users |
| dataform_executor_role | ID of custom Dataform executor role |
| bigquery_loader_role | ID of custom BigQuery loader role |

## Common Issues
- Permission inheritance patterns
- Role conflicts
- Missing parent permissions 