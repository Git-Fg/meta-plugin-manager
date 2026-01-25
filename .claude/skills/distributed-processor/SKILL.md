---
name: distributed-processor
description: This skill should be used when the user asks to "test TaskList with forked skills", "coordinate distributed data processing", "test distributed processing with isolation", or needs guidance on testing TaskList error handling and recovery with forked skills for distributed data processing workflows (not for simple single-process workflows).
context: fork
---

## PROCESSING_START

You are coordinating distributed data processing across multiple regions.

**Context**: A large dataset needs to be processed in parallel across different geographic regions. Each region's data is independent and processed in complete isolation. Results must be aggregated into a final report.

**Processing Architecture**:
- Coordinator uses TaskList to track all processing tasks
- Each region processor is a forked skill (complete isolation)
- Results flow back to coordinator for aggregation

**Processing Tasks** (parallel, independent):

1. **process-region-a** - Process data from Region A
   - Call region-processor-skill with context: fork, args="region=A"
   - Forked skill processes in isolation

2. **process-region-b** - Process data from Region B
   - Call region-processor-skill with context: fork, args="region=B"
   - Forked skill processes in isolation

3. **process-region-c** - Process data from Region C
   - Call region-processor-skill with context: fork, args="region=C"
   - Forked skill processes in isolation

4. **aggregate-results** - Combine all processed outputs
   - Wait for all region processors to complete
   - Aggregate results into final dataset

**Execute autonomously**:

1. Create TaskList with all tasks
2. Use Skill tool with context: fork for each region processor
   - Pass region identifier via args parameter
3. Monitor task completion
4. When all processors complete, aggregate results
5. Return aggregated dataset to caller

**Expected output format**:
```
Distributed Processing: COORDINATING
[task-id] process-region-a: IN_PROGRESS -> COMPLETE
[task-id] process-region-b: IN_PROGRESS -> COMPLETE
[task-id] process-region-c: IN_PROGRESS -> COMPLETE
[task-id] aggregate-results: BLOCKED -> IN_PROGRESS -> COMPLETE

=== AGGREGATED RESULTS ===
Region A: [records processed, summary]
Region B: [records processed, summary]
Region C: [records processed, summary]

Total: [combined statistics]
```
