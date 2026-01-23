# Behavioral Comparison Matrix

**Technical analysis of Regular vs Forked skill execution**

---

## Execution Pattern Comparison

| Aspect | Regular → Regular | Regular → Forked |
|--------|------------------|------------------|
| **Control Returns** | ❌ NO - one-way handoff | ✅ YES - subroutine pattern |
| **Context Access** | ✅ Preserved | ❌ Isolated |
| **Parameters Pass** | ✅ Yes | ✅ Yes |
| **Autonomy Level** | Variable | ✅ 100% |
| **Tool Access** | Standard tools only | ✅ Specialized + custom |
| **Chaining** | ⚠️ Forward only | ✅ Round-trip |
| **Use Case** | Handoff pattern | ✅ Subroutine pattern |
| **Isolation** | None | ✅ Complete |
| **Parallel Safe** | ❌ No | ✅ Yes |
| **Nested Execution** | ❌ No | ✅ Yes (test_4.2) |

---

## Test Evidence by Pattern

### Regular → Regular Pattern
```
Test: 1.2.three.skill.chain
Evidence:
  1. skill-a started
  2. skill-b executed
  3. "SKILL_A_COMPLETE" appears
  4. No evidence of skill-c execution
  5. Control never returns to skill-a after skill-b

Conclusion: One-way transfer, caller never resumes
```

### Regular → Forked Pattern
```
Test: 4.2.double.fork
Evidence:
  1. forked-outer started
  2. forked-inner called (isolated)
  3. forked-inner completed
  4. forked-outer resumed
  5. "FORKED_OUTER_COMPLETE"
  6. Control returned successfully

Conclusion: Isolated execution with control return
```

---

## Context Isolation Verification

### Forked Skill Cannot Access
- ❌ Caller's conversation history
- ❌ User preferences (user_preference, session_id)
- ❌ Context variables (project_codename, etc.)
- ❌ Caller's session state

### Forked Skill CAN Access
- ✅ Parameters via args (test_5.1)
- ✅ Its own isolated execution context
- ✅ Files it creates/modifies
- ✅ Specialized tools via agents

---

## Autonomy Comparison

### Regular Skills
- May ask questions when unclear
- Can reference conversation context
- May need user input for decisions
- Examples: Tests 1.1, 1.2, 6.1, 6.2

### Forked Skills
- ✅ Make independent decisions (test_2.3)
- ✅ Complete without user interaction
- ✅ Use structured output only
- ✅ 0 permission denials across all tests

---

## Tool Access Matrix

| Tool Type | Regular Skills | Forked Skills |
|-----------|----------------|---------------|
| **Built-in Tools** | ✅ All | ✅ All |
| **Read, Grep, Glob** | ✅ Yes | ✅ Yes |
| **Explore Agent** | ✅ Yes | ✅ Yes (test_2.5) |
| **Custom Subagents** | ✅ Yes | ✅ Yes (test_3.2, 7.1) |
| **Agent with Injected Skills** | ❓ Unknown | ✅ Yes (test_7.1) |

---

## Performance Comparison

| Metric | Regular → Regular | Regular → Forked |
|--------|------------------|------------------|
| **Average Duration** | 10,567ms | 25,643ms |
| **Shortest** | 7,736ms (1.1) | 12,067ms (5.1) |
| **Longest** | 13,399ms (1.2) | 93,536ms (7.1) |
| **Overhead** | Lower | Higher (isolation + agents) |

*Note: Forked skills show higher duration due to context isolation and specialized agent usage*

---

## Security Isolation Model

```
Caller Context                    Forked Skill Context
┌─────────────────────────┐      ┌─────────────────────────┐
│ • Conversation history  │      │ • Isolated execution    │
│ • User preferences      │      │ • Parameters only        │
│ • Session variables     │      │ • New session state     │
│ • Previous steps        │      │ • Independent tools      │
└─────────────────────────┘      └─────────────────────────┘
              │                             │
              └─ (parameters pass) ──────────┘
```

**Security Boundary**: Complete isolation except for explicit parameter passing

---

## Recommended Design Patterns

### ✅ CORRECT: Hub-and-Spoke with Forked Workers
```yaml
# orchestrator (regular)
---
name: audit-orchestrator
---
1. Call code-audit-worker (forked, agent: Explore)
2. Call security-audit-worker (forked, agent: Explore)
3. Aggregate both results
4. Output: ## AUDIT_COMPLETE
```

### ❌ INCORRECT: Regular Skill Chain
```yaml
# skill-a (regular) - WON'T WORK
---
name: skill-a
---
1. Call skill-b
2. Process results from skill-b  # NEVER REACHED
3. Complete  # NEVER REACHED
```

### ✅ CORRECT: Sequential Forked Pipeline
```yaml
# pipeline (regular)
---
name: analysis-pipeline
---
1. Call prepare-data (forked)
2. Call analyze-data (forked, agent: Explore)
3. Call format-results (forked)
4. Combine all results
5. Output: ## PIPELINE_COMPLETE
```

---

## Decision Matrix

```
Need to call another skill?
│
├─ Yes → Will you need control to return?
│        ├─ Yes → Use context: fork
│        └─ No → Use regular (one-way handoff)
│
└─ No → Single skill execution
```

---

## Anti-Patterns to Avoid

1. ❌ **Regular skill chains expecting return** (tests 1.1, 1.2)
2. ❌ **Context-dependent forks** (tests 2.2 validation)
3. ❌ **Command wrapper skills** (test 4.3 failure)
4. ❌ **Linear chain brittleness** (test 1.2 evidence)

---

**Conclusion**: The fundamental distinction between regular and forked skills is critical for architecture design. Use `context: fork` when control must return to the caller.

---

**Evidence**: 25 tests across 7 phases in `tests/raw_logs/`
**Cross-Verified**: All patterns confirmed with actual execution logs
