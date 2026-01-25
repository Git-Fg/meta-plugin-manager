---
name: distributed-processor
description: This skill should be used when the user asks to "test TaskList with forked skills", "coordinate distributed data processing", "test distributed processing with isolation", or needs guidance on testing TaskList error handling and recovery with forked skills for distributed data processing workflows (not for simple single-process workflows).
context: fork
---

# Distributed Data Processing

Think of distributed processing as **orchestrating a symphony**—multiple musicians (regions) playing independently in perfect isolation, with a conductor (coordinator) bringing it all together at the end.

## PROCESSING_START

You are coordinating distributed data processing across multiple regions.

**Context**: A large dataset needs processing in parallel across different geographic regions. Each region's data is independent and processed in complete isolation. Results must be aggregated into a final report.

## Processing Architecture

**Three-component system:**
- **Coordinator** uses TaskList to track all processing tasks
- **Region processors** are forked skills with complete isolation
- **Results flow back** to coordinator for aggregation

## Recognition Patterns

**When to use distributed-processor:**
```
✅ Good: Large dataset needs parallel processing
✅ Good: Independent regions can process data separately
✅ Good: Forked skills needed for complete isolation
✅ Good: Results need aggregation into final report
❌ Bad: Single dataset requiring sequential processing
❌ Bad: No geographic or logical data separation

Why good: Independent processing enables parallel execution and fault isolation.
```

**Pattern Match:**
- User mentions "parallel processing", "distributed data", "forked skills"
- Large datasets that can be partitioned
- Independent processing with later aggregation

**Recognition:** "Can this data be partitioned and processed independently?" → Use distributed-processor.

## Processing Tasks

**Parallel, independent execution:**

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

## Execution Workflow

**Execute autonomously:**

1. **Create TaskList** with all tasks
2. **Use Skill tool** with context: fork for each region processor
   - Pass region identifier via args parameter
3. **Monitor task completion**
4. **When all processors complete**, aggregate results
5. **Return aggregated dataset** to caller

## Expected Output

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

**Contrast:**
```
✅ Good: All three regions process in parallel
✅ Good: aggregate-results waits for all to complete
✅ Good: Each region runs in complete isolation
❌ Bad: Sequential processing of regions
❌ Bad: aggregate-results runs before processing completes

Why good: Parallel execution maximizes speed while isolation ensures fault containment.
```

**Recognition:** "Does this output show proper distributed processing?" → Check: 1) Parallel execution of regions, 2) Results aggregation after completion.
