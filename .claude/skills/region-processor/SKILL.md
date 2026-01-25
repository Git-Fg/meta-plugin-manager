---
name: region-processor
description: "Process data for a specific geographic region. Use when: processing regional data in isolation as part of distributed workflow. Not for: single-region or non-distributed processing."
context: fork
---

## PROCESSING_START

Processing data for region: {{REGION}}

**Context**: This skill processes data for a specific geographic region as part of a distributed processing workflow. Each region is processed in complete isolation.

**Processing Logic**:
- Parse region parameter from args
- Simulate data processing for the region
- Generate summary statistics
- Return processed results

**Execute autonomously**:

1. Parse region parameter from $ARGUMENTS
2. Process simulated dataset for the region
3. Generate processing summary
4. Output results in standard format
5. Signal completion

**Expected output format**:
```
Region {{REGION}}: PROCESSING
- Dataset size: [number] records
- Processing time: [duration]
- Records processed: [count]
- Summary: [summary statistics]
## REGION_PROCESSOR_COMPLETE
```

## PROCESSING_COMPLETE
