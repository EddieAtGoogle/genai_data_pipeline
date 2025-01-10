# Storage Module

This module manages Google Cloud Storage resources for the GenAI Data Pipeline.

## Core Features

### 1. Bucket Configuration
- Unique bucket naming with project ID prefix
- Uniform bucket-level access (security best practice)
- Versioning for data protection
- Public access prevention
- Regional or multi-regional storage options

### 2. Data Organization
```
bucket/
├── raw/                 # Raw data files
│   └── reviews/        # Consumer review data (.parquet)
├── processed/          # Processed data files
└── temp/              # Temporary processing files
```

### 3. Lifecycle Management
- Automatic transition to coldline storage for old data
- Versioning cleanup rules
- Temporary file cleanup
- Cost optimization policies

### 4. Security Features
- Uniform bucket-level access enforcement
- CMEK support (optional)
- Secure transport (HTTPS) requirement
- Object versioning for recovery
- Public access prevention

### 5. Monitoring & Logging
- Object lifecycle events
- Access logging
- Storage metrics
- Audit logging configuration

## Usage

### Basic Usage
```hcl
module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
}
```

### With Advanced Features
```hcl
module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
  
  # Enable additional features
  enable_versioning     = true
  enable_cmek          = true
  lifecycle_rules      = true
  enable_access_logs   = true
  
  # Custom settings
  storage_class        = "STANDARD"
  retention_period_days = 30
}
```

## Variables

### Required Variables
- `project_id`: GCP project ID
- `region`: GCP region for bucket location

### Optional Variables
- `bucket_name`: Override default bucket name
- `storage_class`: Storage class (STANDARD, NEARLINE, etc.)
- `enable_versioning`: Enable object versioning
- `retention_period_days`: Object retention period
- `enable_cmek`: Use customer-managed encryption keys

## Outputs
- Bucket name
- Bucket URL
- Bucket self link
- CMEK key details (if enabled)

## Best Practices Implemented

### 1. Security
- Uniform bucket-level access
- Secure transport requirement
- Public access prevention
- Object versioning

### 2. Cost Optimization
- Lifecycle rules for storage class transitions
- Automatic cleanup of old versions
- Temporary file management

### 3. Organization
- Structured folder hierarchy
- Clear naming conventions
- Separation of raw and processed data

### 4. Monitoring
- Access logging
- Audit logging
- Storage metrics

## Common Use Cases

### 1. Data Lake Storage
- Store raw data files
- Maintain data versions
- Organize by data type

### 2. ETL Pipeline Storage
- Source data storage
- Temporary processing files
- Processed output storage

### 3. Backup and Archive
- Version history
- Long-term retention
- Cost-effective storage classes

## Educational Notes

### Storage Classes
- **STANDARD**: Frequently accessed data
- **NEARLINE**: Access < once per month
- **COLDLINE**: Access < once per quarter
- **ARCHIVE**: Access < once per year

### Cost Considerations
- Storage costs vary by class
- Egress charges apply
- Operation costs vary by type
- Early deletion fees for Nearline/Coldline

### Security Best Practices
- Always enable uniform bucket-level access
- Use service accounts for access
- Enable object versioning
- Require secure transport 