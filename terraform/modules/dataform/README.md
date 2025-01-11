# Dataform Module

This module manages Dataform resources for the GenAI Data Pipeline, providing automated data transformations and analytics workflows.

## 🎯 Purpose
- Creates and configures a Dataform repository
- Sets up automated weekly releases
- Manages Git integration and authentication
- Configures compilation settings
- Securely stores Git credentials in Secret Manager

## 🏗️ Resources Created

### 1. Secret Manager Resources
- Secret for Git authentication token
- Automatic replication configuration
- Secure access controls

### 2. Dataform Repository
- Managed Git-based repository
- Secure authentication via Secret Manager
- Regional deployment
- Resource labeling

### 3. Release Configuration
- Weekly automated releases
- Configurable schedule (default: Monday 4am)
- BigQuery compilation settings
- Branch-based releases

## 🚀 Usage

### Basic Usage
```hcl
module "dataform" {
  source     = "./modules/dataform"
  project_id = var.project_id
  region     = var.region
  dataset_id = "consumer_reviews_dataset"
  
  # Git configuration
  git_remote_url = "https://github.com/your-org/your-repo.git"
  git_auth_token = "ghp_your_github_personal_access_token"  # Will be stored in Secret Manager
}
```

### Advanced Usage
```hcl
module "dataform" {
  source     = "./modules/dataform"
  project_id = var.project_id
  region     = var.region
  dataset_id = "consumer_reviews_dataset"
  
  # Git configuration
  git_remote_url = "https://github.com/your-org/your-repo.git"
  git_auth_token = "ghp_your_github_personal_access_token"  # Will be stored in Secret Manager
  
  # Secret Manager settings
  secret_id = "custom-secret-name"  # Optional: customize the secret name
  
  # Custom settings
  repository_name     = "custom-repo-name"
  release_config_name = "custom-release"
  default_branch      = "main"
  environment        = "prod"
  
  # Release schedule (every day at 2am)
  release_schedule = "0 2 * * *"
  
  # Additional labels
  labels = {
    team        = "data-engineering"
    cost_center = "12345"
  }
}
```

## 📋 Variables

### Required Variables
| Name | Description | Type |
|------|-------------|------|
| `project_id` | GCP project ID | `string` |
| `region` | GCP region for resources | `string` |
| `dataset_id` | BigQuery dataset ID | `string` |
| `git_remote_url` | Git repository URL | `string` |
| `git_auth_token` | Git authentication token value | `string` |

### Optional Variables
| Name | Description | Default | Type |
|------|-------------|---------|------|
| `secret_id` | Secret Manager secret ID | `"dataform-git-token"` | `string` |
| `repository_name` | Dataform repository name | `"genai-pipeline"` | `string` |
| `release_config_name` | Release configuration name | `"weekly-release"` | `string` |
| `default_branch` | Git default branch | `"main"` | `string` |
| `environment` | Environment name | `"dev"` | `string` |
| `release_schedule` | Cron schedule for releases | `"0 4 * * 1"` | `string` |
| `compilation_location` | BigQuery location | `"US"` | `string` |
| `labels` | Resource labels | `{}` | `map(string)` |

## 📤 Outputs
| Name | Description |
|------|-------------|
| `repository_name` | Created repository name |
| `repository_id` | Full repository identifier |
| `repository_location` | Repository location |
| `release_config_name` | Release configuration name |
| `release_schedule` | Configured release schedule |
| `release_branch` | Git branch for releases |
| `compilation_database` | Default compilation database |
| `compilation_schema` | Default compilation schema |
| `compilation_location` | BigQuery operation location |

## 🔧 Setup Guide

### 1. Git Repository Setup
1. Create a Git repository for your Dataform code
2. Add your initial Dataform configuration
3. Push to your default branch

### 2. Git Authentication
1. Create a GitHub Personal Access Token (PAT) with repo access
2. Use this token as the `git_auth_token` variable
3. The module will automatically:
   - Create a Secret Manager secret
   - Store the token securely
   - Configure Dataform to use it

### 3. Module Configuration
1. Add the module to your Terraform configuration
2. Configure required variables
3. Apply the configuration

## 🔍 Troubleshooting

### Common Issues

#### 1. Git Authentication Fails
```bash
# Verify secret was created
gcloud secrets list --filter="name:dataform-git-token"

# Check secret version
gcloud secrets versions list dataform-git-token

# Verify service account permissions
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.role:secretmanager.secretAccessor"
```

#### 2. Release Configuration Issues
```bash
# View release configuration
gcloud beta dataform repositories releases list \
  --project=$PROJECT_ID \
  --region=$REGION \
  --repository=genai-pipeline
```

#### 3. Compilation Errors
```bash
# Check BigQuery permissions
bq show --project_id=$PROJECT_ID $DATASET_ID

# Verify service account roles
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.role:bigquery.dataEditor"
```

## 📚 Best Practices

### 1. Version Control
- Use meaningful commit messages
- Follow branching strategy
- Regular code reviews

### 2. Security
- Rotate Git tokens regularly
- Use minimal permissions
- Enable audit logging
- Monitor secret access

### 3. Release Management
- Test changes before release
- Monitor release logs
- Regular schedule validation

## 🔄 Maintenance

### Regular Tasks
1. Review release logs
2. Validate transformations
3. Check resource usage
4. Update dependencies
5. Rotate Git tokens

### Monitoring
1. Set up alerts for failures
2. Monitor compilation times
3. Track resource utilization
4. Audit secret access 