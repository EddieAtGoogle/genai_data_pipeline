resource "google_dataform_repository" "genai_pipeline" {
  provider = google-beta

  name     = "genai-pipeline"
  region   = var.region
  project  = var.project_id

  git_remote_settings {
    url                                 = var.git_remote_url
    default_branch                      = "main"
    authentication_token_secret_version = var.git_auth_token
  }
}

resource "google_dataform_repository_release_config" "weekly_release" {
  provider = google-beta

  project    = var.project_id
  region     = var.region
  repository = google_dataform_repository.genai_pipeline.name
  name       = "weekly-release"

  git_commitish = "main"
  
  cron_schedule = "0 4 * * 1"  # 4am on Monday

  code_compilation_config {
    default_database = var.project_id
    default_schema   = var.dataset_id
    default_location = "US"
  }
}