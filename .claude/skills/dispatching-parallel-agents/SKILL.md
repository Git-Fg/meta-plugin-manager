---
name: dispatching-parallel-agents
description: "Dispatch parallel agents for concurrent problem-solving. Use when multiple independent problems exist that can be solved concurrently. Includes agent dispatch, result aggregation, and state conflict prevention. Not for sequential dependencies, shared state issues, or single-agent workflows."
---

<mission_control>
<objective>Dispatch parallel agents for concurrent problem-solving when multiple independent issues exist.</objective>
<success_criteria>All agents complete, results aggregated, no state conflicts</success_criteria>
</mission_control>

## The Path to High-Efficiency Parallel Execution

### 1. Independence First, Then Parallelize

Verifying independence before dispatching prevents conflicts that waste time. When agents edit unrelated files or work on separate subsystems, they can run simultaneously without interference.

**Why this works**: Independence verification eliminates the overhead of resolving conflicts later. A minute spent checking independence saves ten minutes fixing merge conflicts.

### 2. Batch for Prompt Efficiency

Single Task() calls with multiple agents consume one prompt instead of many. Grouping independent agents into a single dispatch maximizes efficiency.

**Why this works**: One prompt can carry multiple independent agent specifications. The system processes them in parallel, reducing total prompt overhead.

### 3. Focused Prompts Reduce Context Drift

Each agent receives specific scope, clear goals, and all needed context upfront. Narrow focus prevents agents from wandering into unrelated areas.

**Why this works**: When scope is clear ("Fix these 3 tests in this file" vs "Fix all tests"), agents stay on target. Focused prompts reduce the need for clarification rounds.

### 4. Aggregate Results, Then Verify

Review all agent summaries together, check for conflicts, then run the full suite. This holistic catch prevents integration issues from slipping through.

**Why this works**: Individual agent fixes may work locally but break when combined. Full-suite verification catches these integration gaps before they become problems.

### 5. Match Strategy to Problem Structure

Independent problems → parallel agents. Related failures → sequential investigation. Shared state → single agent or careful coordination.

**Why this works**: Not all problems benefit from parallelization. Choosing the right strategy avoids the overhead of parallel coordination when it won't help.

## Quick Start

**Dispatch agents:** Delegate to specialized workers for each independent problem

**Track completion:** TaskList monitors all concurrent tasks

**Aggregate results:** Collect outputs after all complete

**Why:** 3+ independent problems solved in parallel complete faster than sequential execution.

## Operational Patterns

This skill follows these behavioral patterns:

- **Delegation**: Spawn isolated contexts for concurrent problem-solving
- **Tracking**: Maintain a visible task list for parallel coordination
- **Batching**: Group independent agents into single Task() calls for efficiency

## Navigation

| If you need...         | Read...                                             |
| :--------------------- | :-------------------------------------------------- |
| Dispatch agents        | ## Quick Start → Dispatch agents                    |
| Track completion       | ## Quick Start → Track completion                   |
| Aggregate results      | ## Quick Start → Aggregate results                  |
| Parallel dispatch      | ## Implementation Patterns → Parallel Dispatch      |
| Agent prompt structure | ## Implementation Patterns → Agent Prompt Structure |
| When to use parallel   | See pr-reviewer skill for criteria                  |

---

## Implementation Patterns

### Parallel Dispatch

```typescript
// Dispatch agents for independent problems
Dispatch agent to fix agent-tool-abort.test.ts failures
Dispatch agent to fix batch-completion-behavior.test.ts failures
Dispatch agent to fix tool-approval-race-conditions.test.ts failures
// All three run concurrently
```

### Agent Prompt Structure

```markdown
Fix the 3 failing tests in src/agents/agent-tool-abort.test.ts:

1. "should abort tool with partial output capture"
2. "should handle mixed completed and aborted tools"
3. "should properly track pendingToolCount"

These are timing/race condition issues. Your task:

1. Read the test file and understand what each test verifies
2. Identify root cause - timing issues or actual bugs?
3. Fix by replacing arbitrary timeouts with event-based waiting

Return: Summary of what you found and what you fixed.
```

### Verification Workflow

```markdown
After agents return:

1. Review each summary - Understand what changed
2. Check for conflicts - Did agents edit same code?
3. Run full suite - Verify all fixes work together
4. Spot check - Agents can make systematic errors
```

---

## Workflows

### Independent Analysis

Dispatch multiple analysis agents in parallel for different subsystems:

```
Agent 1 → Analyze frontend failures
Agent 2 → Analyze backend failures
Agent 3 → Analyze infrastructure issues
// All run concurrently, results aggregated
```

### Sequential Handoffs

Dispatch agent, wait for output, dispatch next based on results:

```
Agent 1 → Diagnose root cause
  ↓ (output determines next step)
Agent 2 → Fix related components
  ↓ (if needed)
Agent 3 → Verify fixes
```

### Fan-Out Pattern

Dispatch many agents for different files, collect results:

```
Agent file-A-1 → Fix issues in file A (chunk 1)
Agent file-A-2 → Fix issues in file A (chunk 2)
Agent file-B-1 → Fix issues in file B
Agent file-C-1 → Fix issues in file C
// Collect all results, integrate
```

---

## Troubleshooting

**Issue**: Agents produce conflicting changes

- **Symptom**: Two agents edit the same file differently
- **Solution**: Verify independence before dispatching, use sequential investigation for related problems

**Issue**: Agent scope too broad

- **Symptom**: Agent gets lost, produces unrelated changes
- **Solution**: Narrow scope to single file or subsystem, provide specific constraints

**Issue**: Missing context

- **Symptom**: Agent asks many questions or misses relevant details
- **Solution**: Provide all context upfront (error messages, test names, relevant code)

**Issue**: Shared state interference

- **Symptom**: Agents interfere with each other's work
- **Solution**: Use sequential investigation instead, or ensure complete isolation

---

## Overview

When you have multiple unrelated failures (different test files, different subsystems, different bugs), investigating them sequentially wastes time. Each investigation is independent and can happen in parallel.

**Core principle:** Dispatch one agent per independent problem domain. Let them work concurrently.

## The Pattern

### 1. Identify Independent Domains

Group failures by what's broken:

- File A tests: Tool approval flow
- File B tests: Batch completion behavior
- File C tests: Abort functionality

Each domain is independent - fixing tool approval doesn't affect abort tests.

### 2. Create Focused Agent Tasks

Each agent gets:

- **Specific scope:** One test file or subsystem
- **Clear goal:** Make these tests pass
- **Constraints:** Don't change other code
- **Expected output:** Summary of what you found and fixed

### 3. Dispatch in Parallel

Dispatch agents for independent problems:

### 4. Review and Integrate

When agents return:

- Read each summary
- Verify fixes don't conflict
- Run full test suite
- Integrate all changes

## Agent Prompt Structure

Good agent prompts are:

1. **Focused** - One clear problem domain
2. **Self-contained** - All context needed to understand the problem
3. **Specific about output** - What should the agent return?

### Example Agent Prompt

```markdown
Fix the 3 failing tests in src/agents/agent-tool-abort.test.ts:

1. "should abort tool with partial output capture" - expects 'interrupted at' in message
2. "should handle mixed completed and aborted tools" - fast tool aborted instead of completed
3. "should properly track pendingToolCount" - expects 3 results but gets 0

These are timing/race condition issues. Your task:

1. Read the test file and understand what each test verifies
2. Identify root cause - timing issues or actual bugs?
3. Fix by:
   - Replacing arbitrary timeouts with event-based waiting
   - Fixing bugs in abort implementation if found
   - Adjusting test expectations if testing changed behavior

Do NOT just increase timeouts - find the real issue.

Return: Summary of what you found and what you fixed.
```

## Common Mistakes to Avoid

### Mistake 1: Overly Broad Scope

❌ **Wrong:**
"Fix all the tests" → Agent gets lost in scope

✅ **Correct:**
"Fix agent-tool-abort.test.ts" → Focused scope

### Mistake 2: Missing Context

❌ **Wrong:**
"Fix the race condition" → Agent doesn't know where to look

✅ **Correct:**
Provide error messages, test names, and relevant code snippets

### Mistake 3: No Constraints

❌ **Wrong:**
"Fix the tests" → Agent might refactor production code

✅ **Correct:**
"Fix tests only. Do NOT change production code."

### Mistake 4: Vague Output Request

❌ **Wrong:**
"Fix it" → You don't know what changed

✅ **Correct:**
"Return summary of root cause and changes made"

## When NOT to Use

**Related failures:** Fixing one might fix others - investigate together first
**Need full context:** Understanding requires seeing entire system
**Exploratory debugging:** You don't know what's broken yet
**Shared state:** Agents would interfere (editing same files, using same resources)

## Real Example from Session

**Scenario:** 6 test failures across 3 files after major refactoring

**Failures:**

- agent-tool-abort.test.ts: 3 failures (timing issues)
- batch-completion-behavior.test.ts: 2 failures (tools not executing)
- tool-approval-race-conditions.test.ts: 1 failure (execution count = 0)

**Decision:** Independent domains - abort logic separate from batch completion separate from race conditions

**Dispatch:**

```
Agent 1 → Fix agent-tool-abort.test.ts
Agent 2 → Fix batch-completion-behavior.test.ts
Agent 3 → Fix tool-approval-race-conditions.test.ts
```

**Results:**

- Agent 1: Replaced timeouts with event-based waiting
- Agent 2: Fixed event structure bug (threadId in wrong place)
- Agent 3: Added wait for async tool execution to complete

**Integration:** All fixes independent, no conflicts, full suite green

**Time saved:** 3 problems solved in parallel vs sequentially

## Key Benefits

1. **Parallelization** - Multiple investigations happen simultaneously
2. **Focus** - Each agent has narrow scope, less context to track
3. **Independence** - Agents don't interfere with each other
4. **Speed** - 3 problems solved in time of 1

## Verification

After agents return:

1. **Review each summary** - Understand what changed
2. **Check for conflicts** - Did agents edit same code?
3. **Run full suite** - Verify all fixes work together
4. **Spot check** - Agents can make systematic errors

## Decision Tree

```
START: Multiple failures to investigate?
│
├─ Yes
│  ├─ Are failures independent? (different files/systems)
│  │  ├─ Yes → Use parallel agents
│  │  │  └─ Create focused agent prompts
│  │  └─ No (related failures) → Investigate together
│  │
│  └─ Can agents work independently? (no shared state)
│     ├─ Yes → Use parallel agents
│     └─ No (shared state/dependencies) → Sequential investigation
│
└─ No → Single agent handles it
```

## Validation Checklist

Before dispatching agents:

**Pre-Dispatch:**
- [ ] Clear problem domain identified
- [ ] Specific scope defined (file, subsystem)
- [ ] All context provided (error messages, test names)
- [ ] Constraints specified (what not to change)
- [ ] Expected output defined (summary format)
- [ ] Independence verified (no shared state)

After agents return:

**Post-Dispatch:**
- [ ] All summaries reviewed
- [ ] Fixes verified (no conflicts)
- [ ] Full test suite run
- [ ] Changes integrated
- [ ] Documentation updated

---

## Best Practices Summary

✅ **DO:**
- Verify independence before dispatching (no shared state/files)
- Create focused agent prompts with specific scope
- Provide all context upfront (error messages, test names, relevant code)
- Set clear constraints on what agents should NOT change
- Dispatch multiple agents in parallel for independent problems
- Review all summaries and run full test suite after agents return

❌ **DON'T:**
- Dispatch agents for related failures (fix one might fix others)
- Use parallel agents when shared state exists
- Give overly broad scope ("Fix all tests")
- Skip providing context or constraints
- Skip verification after agents return
- Assume no conflicts without checking

## Real-World Impact

From debugging sessions:

- Multiple failures across different files
- Agents dispatched in parallel
- All investigations completed concurrently
- All fixes integrated successfully
- Zero conflicts between agent changes
- Significant time savings vs sequential investigation

## Key Principles

1. **Identify independence** - Separate problem domains
2. **Create focused prompts** - Specific scope, clear goals
3. **Dispatch in parallel** - Concurrent investigation
4. **Review and integrate** - Verify no conflicts
5. **Run full suite** - Ensure all fixes work together

Parallel agent dispatch transforms "3 hours of sequential work" into "1 hour of parallel work" by dividing and conquering independent problems.

---

<critical_constraint>
**Portability Invariant**: This component must work with zero external dependencies. All context for parallel agent dispatch is self-contained in the SKILL.md file.
</critical_constraint>

---
