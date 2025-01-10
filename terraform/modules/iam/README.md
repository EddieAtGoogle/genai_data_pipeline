# IAM Module

This module manages IAM roles and permissions for the GenAI Data Pipeline.

## Purpose
- Manages IAM role assignments
- Implements least privilege access
- Configures service account permissions
- Sets up cross-service access

## Role Assignments
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
```hcl
module "iam" {
  source         = "./modules/iam"
  project_id     = var.project_id
  service_accounts = {
    dataform = module.service_accounts.dataform_service_account_email
    bigquery = module.service_accounts.bigquery_service_account_email
  }
}
```

## Variables
[Variables documentation will be added here]

## Outputs
[Outputs documentation will be added here]

## Common Issues
- Permission inheritance patterns
- Role conflicts
- Missing parent permissions 