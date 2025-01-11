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

## Loading Consumer Review Data

### 1. Sample Data
This project includes a sample consumer review dataset located at:
```
genai_data_pipeline/data/consumer_review_data.parquet
```

This sample data file follows the required schema and can be used to test your pipeline setup:
```sql
-- Required schema for consumer_review_data.parquet
review_ts: TIMESTAMP,           -- Review timestamp
brand: STRING,                  -- Product brand
sentiment: STRING,              -- Analyzed sentiment
original_content: STRING,       -- Original review text
content: STRING,               -- Processed review text
product_line: STRING,          -- Product category
text_embedding: ARRAY<FLOAT64>  -- Vector embedding for ML
```

### 2. Upload Data to GCS

#### Option A: Using Cloud Console
1. Navigate to [Cloud Storage Browser](https://console.cloud.google.com/storage/browser)
2. Browse to your bucket's `raw/reviews/` folder
3. Click "Upload Files" and select the sample Parquet file from `genai_data_pipeline/data/consumer_review_data.parquet`
4. Wait for the upload to complete

#### Option B: Using Command Line
```bash
# Set your variables
export PROJECT_ID="your-project-id"
export BUCKET_NAME="${PROJECT_ID}-consumer-reviews"

# Upload the sample file
gsutil cp genai_data_pipeline/data/consumer_review_data.parquet gs://${BUCKET_NAME}/raw/reviews/

# Verify the upload
gsutil ls gs://${BUCKET_NAME}/raw/reviews/
```

### 3. Load Data into BigQuery

After the file is uploaded and the BigQuery table is created by Terraform, load the data using either method:

#### Option A: Using BigQuery Console
1. Open [BigQuery Console](https://console.cloud.google.com/bigquery)
2. Navigate to your dataset
3. Click "Query" and run:
```sql
LOAD DATA INTO `${PROJECT_ID}.consumer_reviews_dataset.consumer_review_data`
FROM FILES (
  format = 'PARQUET',
  uris = ['gs://${PROJECT_ID}-consumer-reviews/raw/reviews/consumer_review_data.parquet']
);
```

#### Option B: Using Command Line
```bash
# Load data using bq command
bq load \
  --source_format=PARQUET \
  --replace \
  ${PROJECT_ID}:consumer_reviews_dataset.consumer_review_data \
  gs://${PROJECT_ID}-consumer-reviews/raw/reviews/consumer_review_data.parquet

# Verify the load
bq query --use_legacy_sql=false \
  'SELECT COUNT(*) as row_count FROM `'"${PROJECT_ID}"'.consumer_reviews_dataset.consumer_review_data'
```

### 4. Troubleshooting Data Loading

#### Common Issues and Solutions

1. **Permission Denied**
   ```bash
   # Verify BigQuery service account has access
   gsutil iam get gs://${BUCKET_NAME}
   
   # Grant access if missing
   gsutil iam ch serviceAccount:[BIGQUERY_SA_EMAIL]:objectViewer gs://${BUCKET_NAME}
   ```

2. **Schema Mismatch**
   ```bash
   # View Parquet file schema
   gsutil cat gs://${BUCKET_NAME}/raw/reviews/consumer_review_data.parquet | parquet-tools schema

   # Compare with BigQuery table schema
   bq show --schema ${PROJECT_ID}:consumer_reviews_dataset.consumer_review_data
   ```

3. **File Not Found**
   ```bash
   # Verify file exists and path is correct
   gsutil ls -l gs://${BUCKET_NAME}/raw/reviews/consumer_review_data.parquet
   ```

### 5. Best Practices

1. **Data Quality**
   - Validate Parquet file schema before uploading
   - Ensure timestamps are in UTC
   - Handle NULL values appropriately
   - Clean and preprocess data before loading

2. **Performance**
   - Use appropriate compression (Snappy recommended)
   - Consider file size (ideal: 100MB - 1GB per file)
   - Use parallel uploads for large files

3. **Security**
   - Use service accounts instead of user credentials
   - Apply principle of least privilege
   - Enable audit logging for sensitive data

4. **Cost Optimization**
   - Delete source files after successful load if not needed
   - Use lifecycle rules for old versions
   - Monitor storage usage

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