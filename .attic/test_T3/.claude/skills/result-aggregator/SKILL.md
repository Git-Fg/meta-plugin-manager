---
name: result-aggregator
description: "Aggregate and summarize results"
context: fork
---

# Result Aggregator

Aggregate results from processing tasks.

## FUNCTIONALITY

Aggregate results:
- Collect outputs from workers
- Combine and summarize
- Generate final report

## AGGREGATION_OUTPUT

Returns JSON structure:
```json
{
  "source": "result-aggregator",
  "aggregated": [...],
  "status": "success"
}
```

## RESULT_AGGREGATION_COMPLETE

Result aggregation completed successfully.
