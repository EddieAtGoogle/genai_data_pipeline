# Project Setup Module

This module handles the initial GCP project setup and validation.

## Purpose
- Enables required GCP APIs
- Validates project configuration
- Sets up basic project resources

## Resources Created
- API enablement
- Project validation checks
- Basic resource naming conventions

## Usage
```hcl
module "project_setup" {
  source     = "./modules/project_setup"
  project_id = var.project_id
}
```

## Requirements
- GCP project with billing enabled
- Appropriate permissions to enable APIs

## Variables
[Variables documentation will be added here]

## Outputs
[Outputs documentation will be added here] 