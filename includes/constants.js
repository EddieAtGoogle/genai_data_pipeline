// Define constants to be used in the pipeline
const PROJECT_ID = "";
const SCHEMA_NAME = ""
const REMOTE_CONNECTION = ""
const TRANSLATION_REMOTE_SERVICE_TYPE = "CLOUD_AI_TRANSLATE_V3"
const TEXT_LLM_ENDPOINT = "gemini-1.5-flash-002"
const EMBEDDING_REMOTE_SERVICE_TYPE = "CLOUD_AI_TEXT_EMBEDDING_MODEL_V1"

const SENTIMENT_ANALYSIS_PROMPT = "Classify the sentiment of the following text as one of the following: disappointed, satisfied, thrilled, angry, content, delighted, underwhelmed, frustrated, happy, or impressed. Text:"

module.exports = {
    PROJECT_ID,
    SCHEMA_NAME,
    REMOTE_CONNECTION,
    TRANSLATION_REMOTE_SERVICE_TYPE,
    TEXT_LLM_ENDPOINT,
    EMBEDDING_REMOTE_SERVICE_TYPE,
    SENTIMENT_ANALYSIS_PROMPT
};