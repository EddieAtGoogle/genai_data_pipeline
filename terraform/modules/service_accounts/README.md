# Service Accounts Module

This module manages service accounts and their associated permissions.

## Purpose
- Creates service accounts for different components
- Manages service account keys
- Configures Secret Manager integration
- Sets up IAM bindings

## Service Accounts Created
1. Dataform Service Account
   - Used for: Data transformations
   - Permissions: BigQuery access, Storage access
   
2. BigQuery Service Account
   - Used for: Data loading and queries
   - Permissions: BigQuery data access

## Security Considerations
- Keys are stored in Secret Manager
- Minimal permissions following principle of least privilege
- Automated key rotation (optional)

## Usage
```hcl
module "service_accounts" {
  source     = "./modules/service_accounts"
  project_id = var.project_id
}
```

## Variables
[Variables documentation will be added here]

## Outputs
[Outputs documentation will be added here] 