---
name: data-ingestor
description: "Ingest and prepare data for processing"
context: fork
---

# Data Ingestor

Process and ingest data from source.

## FUNCTIONALITY

Ingest sample data:
- Generate synthetic data
- Prepare data for processing
- Return structured data for downstream tasks

## DATA_OUTPUT

Returns JSON structure:
```json
{
  "source": "data-ingestor",
  "data": [...],
  "status": "success"
}
```

## DATA_INGESTION_COMPLETE

Data ingestion completed successfully.
