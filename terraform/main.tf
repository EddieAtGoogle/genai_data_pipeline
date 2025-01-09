provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  dataset_id = var.dataset_id
}

module "dataform" {
  source         = "./modules/dataform"
  project_id     = var.project_id
  region         = var.region
  dataset_id     = var.dataset_id
  git_remote_url = var.git_remote_url
  git_auth_token = var.git_auth_token

  depends_on = [module.bigquery]
} 