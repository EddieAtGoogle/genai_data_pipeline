-- Create the consumer review table
CREATE OR REPLACE TABLE `consumer_reviews_dataset.consumer_review_data`
(
    review_ts TIMESTAMP,
    brand STRING,
    sentiment STRING,
    original_content STRING,
    content STRING,
    product_line STRING,
    text_embedding ARRAY<FLOAT64>
);

-- Load data from Parquet file into the table
LOAD DATA INTO `consumer_reviews_dataset.consumer_review_data`
FROM FILES (
    format = 'PARQUET',
    uris = ['gs://your-bucket-name/consumer_review_data.parquet']
);