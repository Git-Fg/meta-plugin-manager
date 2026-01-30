---
name: distributed-processor
description: "Coordinate distributed processing with parallel execution, forked skills, and isolated work units. Use when distributed processing, work isolation, or parallel execution is required. Includes parallel coordination, fork management, and result aggregation. Not for sequential tasks, single-threaded workflows, or non-isolated processing."
---

# Distributed Processor
<mission_control>
<objective>Coordinate distributed processing with parallel execution, forked skills, and isolated work units.</objective>
<success_criteria>All work units complete, results aggregated, isolation maintained</success_criteria>
</mission_control>

## The Path to High-Autonomy Distributed Processing

### 1. Isolation Prevents Cross-Contamination

Forked skills provide complete isolation between work units. Each region runs independently without access to other regions' state, ensuring that failures or unexpected behaviors in one region cannot affect others.

**Why this works:** Isolation creates fault boundaries. When Region B crashes, Region A continues unaffected. The coordinator can retry or skip Region B without restarting the entire system.

### 2. TaskList Provides Coordination Without Polling

A visible task list enables proper dependency management. The aggregator waits on `blockedBy` relationships rather than polling or guessing when regions complete.

**Why this works:** Explicit dependencies make coordination reliable. The system knows exactly when to aggregate—no race conditions, no premature aggregation, no orphaned tasks.

### 3. Parallel Execution Maximizes Throughput

Processing regions concurrently reduces total execution time from sequential (A + B + C) to parallel (max(A, B, C)). For compute-intensive operations, this can reduce runtime by 60-80%.

**Why this works:** Modern systems have multiple CPU cores. Forked skills utilize available cores simultaneously instead of leaving them idle while processing sequentially.

### 4. Result Aggregation Ensures Data Integrity

Collecting outputs after completion ensures that the final dataset represents complete work. Partial aggregation produces corrupted or misleading results.

**Why this works:** Waiting on dependencies guarantees that all data is available before aggregation begins. No partial results, no missing regions, no "data was still processing" errors.

### 5. Fault Tolerance Through Retry Logic

Distributed systems experience partial failures. Retry mechanisms enable recovery without complete system restart.

**Why this works:** Individual region failures don't doom the entire job. Retry failed regions, skip non-critical failures, or mark aggregation with errors—the system remains operational and productive.

## Quick Start

**Coordinate parallel:** `TaskList` tracks all forked tasks

**Fork skills:** Each region gets isolated subprocess

**Aggregate results:** Collect outputs after all complete

**Why:** Forked skills provide isolation—each region runs independently without cross-contamination.

## Operational Patterns

This skill follows these behavioral patterns:

- **Delegation**: Spawn isolated contexts for distributed processing
- **Tracking**: Maintain a visible task list for parallel coordination
- **Management**: Manage task lifecycle for fork execution

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation for delegation, tracking, and coordination operations.

## Navigation

| If you need... | Read... |
| :------------- | :------ |
| Coordinate parallel | ## Quick Start → Coordinate parallel |
| Fork skills | ## Quick Start → Fork skills |
| Aggregate results | ## Quick Start → Aggregate results |
| Architecture | ## Implementation Patterns → Three-Component Architecture |
| Coordination patterns | ## Implementation Patterns |
| Isolation patterns | See context: fork patterns |

---

## Implementation Patterns

### Three-Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    COORDINATOR                              │
│  Uses TaskList to track all processing tasks               │
└─────────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│  REGION A     │ │  REGION B     │ │  REGION C     │
│  Forked Skill │ │  Forked Skill │ │  Forked Skill │
│  Complete     │ │  Complete     │ │  Complete     │
│  Isolation    │ │  Isolation    │ │  Isolation    │
└───────────────┘ └───────────────┘ └───────────────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                  AGGREGATOR                                 │
│  Combine all processed outputs into final dataset          │
└─────────────────────────────────────────────────────────────┘
```

### Basic Execution

```typescript
// 1. Create task list with all tasks
TaskList.create([
  { id: "region-a", task: "process-region-a" },
  { id: "region-b", task: "process-region-b" },
  { id: "region-c", task: "process-region-c" },
  {
    id: "aggregate",
    task: "aggregate-results",
    blockedBy: ["region-a", "region-b", "region-c"],
  },
]);

// 2. Fork skills for each region (isolated execution)
Delegate to region processor with fork isolation for region A
Delegate to region processor with fork isolation for region B
Delegate to region processor with fork isolation for region C

// 3. Monitor completion, aggregate results
TaskList.waitForCompletion(["region-a", "region-b", "region-c"]);
Dispatch agent to aggregate results
```

### Expected Output

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

---

## Workflows

### Parallel Processing

Fork multiple contexts, process concurrently:

Dispatch region processors for each region in parallel with fork isolation.

### Result Aggregation

Collect results from parallel workers:

```typescript
// Wait for all processors to complete
TaskList.waitForCompletion(["region-a", "region-b", "region-c"]);

// Aggregate into final dataset
aggregate_results = combine_outputs(region_a, region_b, region_c);
return aggregate_results;
```

### Error Handling

Handle failures in distributed execution:

```typescript
try {
  Dispatch region processors for regions A, B, and C with fork isolation
  TaskList.waitForCompletion(...)
} catch (error) {
  TaskList.retry_failed_tasks()
  // or: TaskList.mark_aggregator_with_error()
}
```

---

## Troubleshooting

**Issue**: Processor hangs

- **Symptom**: Task stays in IN_PROGRESS, never completes
- **Solution**: Check for infinite loops in forked skill, add timeout to TaskList

**Issue**: Aggregation fails

- **Symptom**: aggregate-results task fails
- **Solution**: Verify all region processors return compatible output formats

**Issue**: Isolation broken

- **Symptom**: Processors affect each other's state
- **Solution**: Ensure forked skills have no shared resources, use context: fork

**Issue**: Task dependencies not respected

- **Symptom**: aggregate-results runs before processors complete
- **Solution**: Verify blockedBy relationships in TaskList creation

---

## Processing Architecture

**Three-component system:**

- **Coordinator** uses TaskList to track all processing tasks
- **Region processors** are forked skills with complete isolation
- **Results flow back** to coordinator for aggregation

## Processing Tasks

**Parallel, independent execution:**

1. **process-region-a** - Process data from Region A
   - Forked skill processes in isolation

2. **process-region-b** - Process data from Region B
   - Forked skill processes in isolation

3. **process-region-c** - Process data from Region C
   - Forked skill processes in isolation

4. **aggregate-results** - Combine all processed outputs
   - Wait for all region processors to complete
   - Aggregate results into final dataset

## Execution Workflow

**Execute autonomously:**

1. **Create TaskList** with all tasks
2. **Use Skill tool** with context: fork for each region processor
3. **Monitor task completion**
4. **Aggregate results** when all processors complete
5. **Return aggregated dataset**

**Recognition test:** Each region processor runs in complete isolation with no shared state.

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

## Validation Criteria

- Parallel execution of regions
- Results aggregation after completion

**Binary check:** "Proper distributed processing?" → Both criteria must pass.

---

## Common Mistakes to Avoid

### Mistake 1: Starting Aggregation Before All Processors Complete

❌ **Wrong:**
```typescript
Dispatch region processors A, B, C in parallel
TaskList.waitForCompletion(["region-a"])  // Only waits for A!
aggregate_results = combine_outputs(region_a, region_b, region_c)
```

✅ **Correct:**
```typescript
Dispatch region processors A, B, C in parallel
TaskList.waitForCompletion(["region-a", "region-b", "region-c"])  // Wait for ALL
aggregate_results = combine_outputs(region_a, region_b, region_c)
```

### Mistake 2: Missing blockedBy Dependencies

❌ **Wrong:**
```typescript
TaskList.create([
  { id: "region-a", task: "process-region-a" },
  { id: "region-b", task: "process-region-b" },
  { id: "aggregate", task: "aggregate-results" },  // No blockedBy!
]);
```

✅ **Correct:**
```typescript
TaskList.create([
  { id: "region-a", task: "process-region-a" },
  { id: "region-b", task: "process-region-b" },
  {
    id: "aggregate",
    task: "aggregate-results",
    blockedBy: ["region-a", "region-b"],
  },
]);
```

### Mistake 3: No Fault Tolerance for Failed Regions

❌ **Wrong:**
Dispatch region processors → One fails → Entire aggregation fails → No retry attempted

✅ **Correct:**
```typescript
try {
  Dispatch region processors A, B, C with fork isolation
  TaskList.waitForCompletion(["region-a", "region-b", "region-c"])
} catch (error) {
  TaskList.retry_failed_tasks(["region-a"])  // Retry failed region
  // or: mark_aggregator_with_partial_results()
}
```

### Mistake 4: Breaking Isolation Between Regions

❌ **Wrong:**
Regions share a common file for state → Region B corrupts Region A's data → Results unreliable

✅ **Correct:**
Each region gets completely isolated context with no shared resources:
```typescript
Delegate to region processor with fork isolation for region A
Delegate to region processor with fork isolation for region B
// No shared state, no cross-contamination possible
```

### Mistake 5: Sequential Processing When Parallel Is Possible

❌ **Wrong:**
Process Region A → Wait → Process Region B → Wait → Process Region C → Aggregate
(Time = A + B + C)

✅ **Correct:**
```typescript
Delegate to region processor for A (fork)
Delegate to region processor for B (fork)
Delegate to region processor for C (fork)
TaskList.waitForCompletion([...])
// All run in parallel (Time = max(A, B, C))
```

---

## Validation Checklist

Before claiming distributed processing complete:

**Coordination:**
- [ ] TaskList created with all processing tasks
- [ ] blockedBy dependencies properly configured for aggregator
- [ ] No race conditions in task completion

**Parallelism:**
- [ ] Multiple regions dispatched concurrently (not sequentially)
- [ ] Fork isolation used for each region processor
- [ ] No shared state between regions

**Fault Tolerance:**
- [ ] Failed tasks can be retried
- [ ] Partial failures handled gracefully
- [ ] Error recovery strategy defined

**Aggregation:**
- [ ] Wait for ALL processors to complete before aggregating
- [ ] Results from all regions available
- [ ] Final dataset represents complete work

**Isolation:**
- [ ] Each region runs in complete isolation
- [ ] No cross-contamination between regions
- [ ] Fault boundaries maintained

---

## Best Practices Summary

✅ **DO:**
- Use TaskList with blockedBy for proper dependency management
- Wait for ALL processors to complete before aggregating results
- Use fork isolation for each region processor
- Implement retry logic for failed regions
- Dispatch regions concurrently to maximize throughput
- Verify no shared state between isolated regions

❌ **DON'T:**
- Aggregate before all regions complete
- Skip blockedBy dependencies (causes race conditions)
- Process regions sequentially when parallel is possible
- Share state between forked regions
- Skip fault tolerance (single failure = total failure)
- Use regular delegation instead of fork isolation

---

<critical_constraint>
Portability invariant: This component must work in a project with zero .claude/rules dependencies.
</critical_constraint>

---
