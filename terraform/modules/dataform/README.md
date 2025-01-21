# Dataform Module

This module manages Dataform resources for the GenAI Data Pipeline, providing automated data transformations and analytics workflows.

## 🎯 Purpose
- Creates and configures a Dataform repository
- Sets up automated weekly releases
- Manages Git integration and authentication
- Configures compilation settings

## 🏗️ Repository Options

### Default Repository (Recommended for Learning)
By default, this module uses Dataform's built-in repository, which is perfect for:
- Learning and experimentation
- Simple projects
- Quick prototypes

To use the default repository, simply don't enable remote Git:
```hcl
module "dataform" {
  source     = "./modules/dataform"
  project_id = var.project_id
  region     = var.region
  dataset_id = var.dataset_id
}
```

### Remote Git Repository (Optional)
For production environments or team collaboration, you can use a remote Git repository:
```hcl
module "dataform" {
  source         = "./modules/dataform"
  project_id     = var.project_id
  region         = var.region
  dataset_id     = var.dataset_id
  use_remote_git = true
  git_remote_url = "https://github.com/your-org/your-repo.git"
  git_auth_token = var.git_auth_token
}
```

## 🚀 Usage Examples

### Basic Usage (Default Repository)
```hcl
module "dataform" {
  source     = "./modules/dataform"
  project_id = "my-project"
  region     = "us-central1"
  dataset_id = "consumer_reviews_dataset"
}
```

### Advanced Usage with Remote Git
```hcl
module "dataform" {
  source              = "./modules/dataform"
  project_id          = "my-project"
  region              = "us-central1"
  dataset_id          = "consumer_reviews_dataset"
  
  # Git configuration
  use_remote_git      = true
  git_remote_url      = "https://github.com/your-org/your-repo.git"
  git_auth_token      = var.git_auth_token
  
  # Custom settings
  repository_name     = "custom-repo-name"
  release_schedule    = "0 2 * * *"  # Daily at 2 AM
  environment        = "prod"
}
```

## 📝 Variables

### Required Variables
| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_id | The GCP project ID | string | - |
| region | The region for resources | string | - |
| dataset_id | The BigQuery dataset ID | string | - |

### Git Configuration
| Name | Description | Type | Default |
|------|-------------|------|---------|
| use_remote_git | Whether to use remote Git | bool | false |
| git_remote_url | Git repository URL | string | null |
| git_auth_token | GitHub Personal Access Token | string | null |

### Optional Variables
| Name | Description | Type | Default |
|------|-------------|------|---------|
| repository_name | Repository name | string | "genai-pipeline" |
| release_schedule | Cron schedule | string | "0 4 * * 1" |
| environment | Environment name | string | "dev" |

## 🔍 Troubleshooting

### Common Issues

#### 1. Default Repository Access
```bash
# Verify Dataform API is enabled
gcloud services list --enabled | grep dataform

# Check IAM permissions
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.role:dataform.developer"
```

#### 2. Remote Git Issues
```bash
# Verify secret was created (if using remote Git)
gcloud secrets list --filter="name:dataform-git-token"

# Check secret permissions
gcloud secrets get-iam-policy dataform-git-token
```

## 📚 Best Practices

### 1. Repository Choice
- Start with the default repository for learning
- Switch to remote Git when you need:
  - Version control
  - Team collaboration
  - CI/CD integration

### 2. Security
- Use Secret Manager for Git tokens
- Rotate tokens regularly
- Follow least privilege principle

### 3. Release Management
- Start with weekly releases
- Adjust schedule based on needs
- Monitor release logs

## 🆘 Getting Help
- [Dataform Documentation](https://cloud.google.com/dataform/docs)
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs) 