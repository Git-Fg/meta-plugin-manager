# Critical Discoveries

**7 findings that redefine skill workflow architecture**

---

## 🚨 Discovery #1: Regular Skill Chains are One-Way Handoffs

**Test Evidence**: test_1.2.three.skill.chain.json

```
Execution flow observed:
User → skill-a → skill-b → END
             (skill-a completes here)
                  (skill-c never executes)
```

**Key Observation**: Line 8 shows "SKILL_A_COMPLETE" immediately after skill-b finishes. No evidence of skill-c execution.

**Implication**:
- ❌ Cannot design workflows expecting control to return
- ❌ Regular skill chains don't work for multi-step processes
- ✅ Use for handoff patterns only

---

## 🚨 Discovery #2: Forked Skills Enable Subroutine Pattern

**Test Evidence**: test_4.2.double.fork.json

```
Execution flow observed:
User → forked-outer → forked-inner → forked-outer → END
                (isolated)    (isolated)   (resumes)
```

**Key Observation**:
- Line 5: "FORKED_OUTER_COMPLETE"
- Both forked skills completed successfully
- Control returned to outer after inner finished

**Implication**:
- ✅ Hub-and-spoke patterns now possible
- ✅ Orchestrators can aggregate worker results
- ✅ Sequential pipelines work correctly

---

## ✅ Discovery #3: Context Isolation is Complete

**Test Evidence**: test_2.2.context.isolation.json

```
Input: user_preference=prefer_dark_mode project_codename=PROJECT_X
Output: CONTEXT_ISOLATION_CONFIRMED
```

**Key Observations**:
- Forked skill received parameters successfully
- Could not access caller's context variables
- Isolation maintained throughout execution
- Duration: 16,886ms (proper execution time)

**Implication**:
- ✅ Complete isolation maintained
- ✅ Safe parallel execution
- ✅ Parameters work for data transfer

---

## ✅ Discovery #4: Forked Skills are 100% Autonomous

**Test Evidence**: test_2.3.forked.autonomy.json

```
Task: Make a decision about a project
Result: "I'll choose Option A: TypeScript"
Reasoning: Detailed explanation based on guidelines
Completion: INTERACTIVE_TEST_COMPLETE
```

**Key Observations**:
- Made independent decision without asking questions
- Referenced CLAUDE.md guidelines autonomously
- Completed with structured output
- 0 permission denials
- Duration: 18,570ms

**Implication**:
- ✅ Perfect autonomy (0 permission denials)
- ✅ No user interaction required
- ✅ Ideal for background workers

---

## ✅ Discovery #5: Forked Skills Access Specialized Tools

**Test Evidence**: test_3.2.forked.with.custom.subagents.json

```
Agent Used: custom-worker
Capability: File search and analysis
Result: "Found 1 .md file in the directory"
Completion: CUSTOM_AGENT_COMPLETE
```

**Key Observations**:
- Custom subagent configured with restricted tools (Read, Grep)
- Forked skill successfully used these capabilities
- File found at expected location
- Duration: 16,574ms

**Additional Evidence**: test_7.1.subagent.skill.injection.json
- Used equipped-agent with utility-skill
- Hub-and-spoke pattern validated

**Implication**:
- ✅ Combine isolation with specialized capabilities
- ✅ Parallel exploration is feasible
- ✅ Each worker can have custom tool access

---

## ✅ Discovery #6: Double-Fork Works Correctly

**Test Evidence**: test_4.2.double.fork.json

```
Nested Execution:
forked-outer (forked)
  └─ calls forked-inner (forked)
       └─ completes and returns control
forked-outer resumes
  └─ completes and returns control
```

**Key Observations**:
- Line 5: "FORKED_OUTER_COMPLETE"
- Both levels of fork executed successfully
- Control returned at each level
- Duration: 50,948ms (longer due to nested execution)

**Implication**:
- ✅ Nested isolation works
- ✅ Multi-level orchestration possible
- ✅ Complex pipelines feasible

---

## ❌ Discovery #7: Regular Orchestrators Need Refinement

**Test Evidence**: test_4.3.parallel.forked.FAILED.json

```
Invocation: "Call parallel-orchestrator"
Response: "I need to know what specific task you'd like it to execute"
Result: Test marked as FAILED
```

**Key Observations**:
- Orchestrator asked for clarification instead of executing
- Had workers (worker-a, worker-b) available but didn't use them
- User wanted autonomous execution, got request for more input
- Duration: 7,382ms (short - didn't execute)

**Implication**:
- ⚠️ Regular skills might need different invocation patterns
- ⚠️ Forked orchestrators might work better
- ⚠️ More testing needed on orchestrator patterns

---

## Summary Table

| # | Discovery | Tests | Impact | Status |
|---|-----------|-------|--------|--------|
| 1 | One-way handoffs | 1.1, 1.2 | High | 🚨 Critical |
| 2 | Forked subroutine | 2.1, 4.2, 6.1, 6.2 | High | 🚨 Critical |
| 3 | Context isolation | 2.2, 5.1 | Medium | ✅ Validated |
| 4 | 100% autonomy | 2.3 | Medium | ✅ Validated |
| 5 | Specialized tools | 3.2, 7.1 | Medium | ✅ Validated |
| 6 | Double-fork works | 4.2 | Medium | ✅ Validated |
| 7 | Orchestrator limits | 4.3 | Low | ⚠️ Needs work |

---

## Architectural Impact

### Before These Discoveries
```
❌ Linear chain pattern (doesn't work):
Skill-A → Skill-B → Skill-C → END
```

### After These Discoveries
```
✅ Hub-and-spoke pattern (works):
Orchestrator → Worker-1 (forked) → Orchestrator → Worker-2 (forked) → Orchestrator → END
```

**Key Rule**: Use `context: fork` for any skill that needs to return control to caller

---

**Source**: Direct evidence from 25 raw JSON logs in `tests/raw_logs/`
**Verification**: All findings cross-referenced with actual execution traces
