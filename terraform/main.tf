provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Project Setup
# This module must run first to ensure all required APIs and policies are in place
# ---------------------------------------------------------------------------------------------------------------------

module "project_setup" {
  source = "./modules/project_setup"
  
  project_id                   = var.project_id
  set_resource_location_policy = var.set_resource_location_policy
  allowed_regions             = var.allowed_regions
  enable_apis                 = var.enable_apis
  validate_billing            = var.validate_billing
}

# Create service accounts after project setup is complete
module "service_accounts" {
  source                = "./modules/service_accounts"
  project_id            = var.project_id
  environment           = var.environment
  service_account_prefix = var.service_account_prefix

  depends_on = [module.project_setup]
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region

  depends_on = [module.project_setup, module.service_accounts]
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  dataset_id = var.dataset_id

  # Access control variables
  owner_email            = var.owner_email
  reader_group_email     = var.reader_group_email
  restricted_users_group = var.restricted_users_group

  depends_on = [module.project_setup, module.service_accounts]
}

module "dataform" {
  source     = "./modules/dataform"
  project_id = var.project_id
  region     = var.region
  dataset_id = var.dataset_id

  depends_on = [module.project_setup, module.bigquery, module.service_accounts]
}

module "iam" {
  source                        = "./modules/iam"
  project_id                    = var.project_id
  dataform_users_group          = var.dataform_users_group
  dataform_service_account_email = module.service_accounts.dataform_service_account_email
  bigquery_service_account_email = module.service_accounts.bigquery_service_account_email
  enable_time_based_access      = var.enable_time_based_access
  grant_bigquery_admin         = var.grant_bigquery_admin

  depends_on = [module.project_setup, module.service_accounts]
} 