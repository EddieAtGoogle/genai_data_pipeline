# BigQuery Module

This module manages BigQuery resources for the GenAI Data Pipeline, providing a scalable analytics environment for consumer review data.

## 🎓 Learning Resources

### BigQuery Fundamentals
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs) - Start here for a comprehensive overview
- [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices-performance-overview) - Learn how to optimize performance and cost
- [BigQuery Pricing](https://cloud.google.com/bigquery/pricing) - Understand the cost model

### Terraform Basics
- [Terraform Language Documentation](https://www.terraform.io/docs/language/index.html) - Core Terraform concepts
- [Google Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs) - GCP-specific resources
- [Terraform Best Practices](https://www.terraform-best-practices.com/) - Community-driven best practices

## Core Features

### 1. Dataset Configuration
- Regional or multi-regional dataset location
- Default table expiration policies
- Access control settings
- Labels for resource organization
- Description and documentation fields

### 2. Table Schema Management
```sql
CREATE TABLE consumer_review_data (
    review_ts TIMESTAMP,           -- Review timestamp
    brand STRING,                  -- Product brand
    sentiment STRING,              -- Analyzed sentiment
    original_content STRING,       -- Original review text
    content STRING,               -- Processed review text
    product_line STRING,          -- Product category
    text_embedding ARRAY<FLOAT64>  -- Vector embedding for ML
)
PARTITION BY DATE(review_ts)      -- Time-based partitioning
CLUSTER BY brand, product_line    -- Clustering for query optimization
```

### 3. Performance Optimization

#### Partitioning
Partitioning divides your table into smaller segments, improving query performance and reducing costs.

**How it works:**
- Table is split into segments based on a column (usually time)
- Queries can skip irrelevant partitions
- Each partition can have its own expiration

**When to use:**
- Large tables (>1TB)
- Time-series data
- Data with natural segmentation

Learn more: [BigQuery Partitioning](https://cloud.google.com/bigquery/docs/partitioned-tables)

#### Clustering
Clustering orders data within partitions based on specific columns.

**Benefits:**
- Improved filter and aggregation performance
- Reduced data scanning
- Works with or without partitioning

**Best practices:**
- Choose columns frequently used in WHERE clauses
- Order clustering columns by query frequency
- Limit to 4 columns maximum

Learn more: [BigQuery Clustering](https://cloud.google.com/bigquery/docs/clustered-tables)

### 4. Security Features

#### Row-Level Security (RLS)
Controls which rows each user can see.

**Example use cases:**
- Regional data access
- Department-specific views
- Customer data isolation

**Implementation:**
```hcl
resource "google_bigquery_row_access_policy" "example" {
  filter_predicate = "authorized_brands CONTAINS brand"
}
```

Learn more: [Row-Level Security](https://cloud.google.com/bigquery/docs/row-level-security)

#### Column-Level Security (CLS)
Restricts access to specific columns based on user roles.

**Common scenarios:**
- PII data protection
- Financial data access control
- Sensitive field masking

Learn more: [Column-Level Security](https://cloud.google.com/bigquery/docs/column-level-security)

#### Column-Level Security (CLS) Implementation Guide

This module implements a beginner-friendly approach to column-level security:

**Default Behavior (No Configuration Needed):**
- All authenticated users can see all columns
- Perfect for learning and development

**Testing Column-Level Security (Optional):**
To experiment with column-level security and restrict access to the `product_line` column for certain users:

1. **Create a Google Group for Restricted Users**
   ```bash
   # Using Google Workspace Admin Console or gcloud
   gcloud identity groups create restricted-users@your-domain.com \
     --organization=your-org-id \
     --display-name="Users with Restricted Column Access"
   ```

2. **Add Members to the Restricted Group**
   ```bash
   gcloud identity groups memberships add \
     --group-email=restricted-users@your-domain.com \
     --member-email=restricted-user@your-domain.com
   ```

3. **Configure the BigQuery Module**
   ```hcl
   module "bigquery" {
     source     = "./modules/bigquery"
     project_id = var.project_id
     dataset_id = "consumer_reviews_dataset"
     
     # Enable column-level security and specify restricted group
     enable_column_level_security = true
     restricted_users_group      = "restricted-users@your-domain.com"
   }
   ```

4. **Test the Access Restrictions**
   ```sql
   -- Run as normal user (will show all columns)
   SELECT review_ts, brand, sentiment, product_line
   FROM `project.dataset.consumer_review_data`;
   
   -- Run as restricted user (product_line will be hidden)
   SELECT review_ts, brand, sentiment, product_line
   FROM `project.dataset.consumer_review_data`;
   ```

5. **Verify Group Membership**
   ```bash
   # List members of the restricted group
   gcloud identity groups memberships list \
     --group-email=restricted-users@your-domain.com
   ```

**Understanding the Implementation:**
- Regular users (default): Can see ALL columns
- Restricted users (optional): Can see all columns EXCEPT `product_line`
- No configuration needed unless you want to test the restrictions
- Perfect for learning environments where you want to start simple and gradually explore security features

### 5. Data Lifecycle Management
- Table expiration policies
- Partition expiration policies
- Automatic table backups
- Version history
- Data retention controls

## Usage

### Basic Usage
```hcl
module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  dataset_id = "consumer_reviews_dataset"
}
```

### Advanced Usage with Security Features
```hcl
module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  dataset_id = "consumer_reviews_dataset"
  
  # Performance settings
  enable_partition    = true
  partition_field    = "review_ts"
  clustering_fields  = ["brand", "product_line"]
  
  # Security settings
  enable_column_level_security = true
  row_level_security_expr     = "authorized_brands CONTAINS brand"
  
  # Lifecycle settings
  table_expiration_days      = 90
  partition_expiration_days  = 30
}
```

## 💡 Tips for Beginners

### Understanding Terraform Syntax

#### The merge() Function
The `merge()` function combines multiple maps:
```hcl
# Example:
labels = merge(
  { environment = "dev" },    # Default labels
  var.custom_labels           # User-provided labels
)
```
- First argument overridden by second
- Useful for combining default and custom values
- [Terraform merge() documentation](https://www.terraform.io/docs/language/functions/merge.html)

### Cost Optimization Tips
1. **Query Costs**
   - Use partition pruning
   - Minimize data scanned
   - Avoid SELECT *
   - Use appropriate data types

2. **Storage Costs**
   - Set expiration policies
   - Use appropriate compression
   - Clean up temporary tables
   - Monitor usage

### Security Best Practices
1. **Access Control**
   - Use principle of least privilege
   - Implement column-level security
   - Consider row-level security
   - Regular access reviews

2. **Data Protection**
   - Enable column-level encryption
   - Use data masking when needed
   - Monitor access patterns
   - Regular security audits

## 🔍 Troubleshooting

### Common Issues
1. **Permissions**
   - Ensure service account has correct roles
   - Check IAM bindings
   - Verify dataset access

2. **Query Performance**
   - Check partition pruning
   - Verify clustering usage
   - Review query patterns

### Getting Help
- [BigQuery Issue Tracker](https://issuetracker.google.com/issues?q=componentid:187149)
- [Terraform Google Provider Issues](https://github.com/hashicorp/terraform-provider-google/issues)
- [Stack Overflow - BigQuery](https://stackoverflow.com/questions/tagged/google-bigquery) 