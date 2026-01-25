---
name: data-processor
description: "Process and transform data"
context: fork
---

# Data Processor

Process and transform ingested data.

## FUNCTIONALITY

Process data:
- Apply transformations
- Perform calculations
- Generate processed results

## DATA_OUTPUT

Returns JSON structure:
```json
{
  "source": "data-processor",
  "data": [...],
  "status": "success"
}
```

## DATA_PROCESSING_COMPLETE

Data processing completed successfully.
