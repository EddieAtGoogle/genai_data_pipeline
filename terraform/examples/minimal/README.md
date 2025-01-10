# Minimal Example

This example demonstrates the basic setup of the GenAI Data Pipeline with minimal configuration.

## Components Included
- Basic project setup
- Single service account
- Essential API enablement
- Basic BigQuery dataset and table
- Simple Dataform configuration

## Estimated Costs
- BigQuery: Minimal usage (~$10/month)
- Cloud Storage: Minimal storage (~$1/month)
- Dataform: Free tier

## Usage

1. Copy this directory's contents to your working directory
2. Update `terraform.tfvars`:
```hcl
project_id     = "your-project-id"
region         = "us-central1"
dataset_id     = "consumer_reviews_dataset"
```

3. Initialize and apply:
```bash
terraform init
terraform plan
terraform apply
```

## Cleanup
To remove all resources:
```bash
terraform destroy
```

## Next Steps
Once comfortable with this example, explore the complete example for advanced features. 