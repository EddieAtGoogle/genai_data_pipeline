# GenAI Data Pipeline for Consumer Reviews

A Dataform-based data pipeline that processes consumer reviews and questions using Google Cloud's AI capabilities, including sentiment analysis, text embeddings, and clustering.

## Overview

This pipeline processes consumer product reviews and customer questions to derive insights using various AI/ML techniques:

- Sentiment analysis of customer reviews using Gemini 1.5
- Vector embeddings generation for reviews and questions
- Question clustering and theme identification
- Product type classification
- Quality assessment of question-answer pairs

## Architecture

The pipeline is built using:

- **Dataform** for data transformation and orchestration
- **BigQuery** as the data warehouse
- **Google Cloud AI** services:
  - Gemini 1.5 for text generation/analysis
  - Text Embedding API for vector embeddings
  - Vector Search capabilities

## Pipeline Components

### Review Processing

1. `incoming_reviews` - Ingests and validates raw review data
2. `reviews_with_sentiment` - Analyzes review sentiment using Gemini
3. `reviews_with_embeddings` - Generates vector embeddings for reviews
4. `create_vector_index` - Creates a vector search index for similarity matching

### Question Analysis

1. `questions_with_embeddings` - Generates embeddings for customer questions
2. `questions_with_clusters` - Clusters similar questions using K-means
3. `question_themes` - Generates theme summaries for question clusters
4. `qa_with_evaluation` - Evaluates quality of question-answer pairs
5. `qa_with_product_type` - Classifies questions by product type
6. `qa_quality_data` - Combines all question analysis data

### BQML Models

- `bqml_text_llm` - Remote model connection to Gemini 1.5
- `bqml_embedding_model` - Remote model for text embeddings
- `question_clustering_model` - K-means clustering model for questions

## Setup

1. Update `dataform.json` with your project ID and dataset name
2. Configure `constants.js` with:
   - PROJECT_ID
   - SCHEMA_NAME
   - REMOTE_CONNECTION
   - Other AI service configurations

## Tags

The pipeline uses tags to organize operations:

- `process_reviews` - Review processing operations
- `quality_data_prep` - Question analysis operations
- `bqml_model` - Model creation operations
- `vector_index_creation` - Vector search setup
- `regenerate_question_themes` - Theme generation

## Data Quality

The pipeline includes various data quality checks:

- Uniqueness constraints on keys
- Non-null assertions on critical fields
- Row-level conditions for data validation
- Incremental processing to handle new data efficiently

## Dependencies

- @dataform/core: 2.8.3
- Google Cloud Platform services:
  - BigQuery
  - Vertex AI (Gemini)
  - AI Platform