resource "google_bigquery_dataset" "consumer_reviews" {
  dataset_id  = var.dataset_id
  location    = "US"
  description = "Dataset for consumer reviews analysis"

  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "consumer_review_data" {
  dataset_id = google_bigquery_dataset.consumer_reviews.dataset_id
  table_id   = "consumer_review_data"

  schema = jsonencode([
    {
      name = "review_ts",
      type = "TIMESTAMP",
      mode = "NULLABLE"
    },
    {
      name = "brand",
      type = "STRING",
      mode = "NULLABLE"
    },
    {
      name = "sentiment",
      type = "STRING",
      mode = "NULLABLE"
    },
    {
      name = "original_content",
      type = "STRING",
      mode = "NULLABLE"
    },
    {
      name = "content",
      type = "STRING",
      mode = "NULLABLE"
    },
    {
      name = "product_line",
      type = "STRING",
      mode = "NULLABLE"
    },
    {
      name = "text_embedding",
      type = "FLOAT64",
      mode = "REPEATED"
    }
  ])
}