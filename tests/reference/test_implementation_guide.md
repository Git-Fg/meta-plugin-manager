# Skill Testing Implementation Guide

## Progressive Testing Approach

### Phase 1: Basic Skill Calling
**Goal**: Verify skills can call other skills and win conditions work

#### Test 1.1: Simple Linear Chain

**Skills to Create**:

1. **skill-b** (transitive)
```yaml
---
name: skill-b
description: "Simple transitive skill for testing"
---

## SKILL_B_COMPLETE

Processing completed successfully.
Output: [Results]
```

2. **skill-a** (regular)
```yaml
---
name: skill-a
description: "Caller skill that calls skill-b"
---

## SKILL_A_STARTED

Calling skill-b...
[Call skill-b and wait for ## SKILL_B_COMPLETE]
Skill-b completed successfully.
## SKILL_A_COMPLETE
```

**Test Execution**:
1. Call skill-a
2. Verify output contains `## SKILL_B_COMPLETE` marker
3. Verify skill-a receives results
4. Verify skill-a outputs `## SKILL_A_COMPLETE`

**Expected Results**:
- ✅ Win condition marker appears
- ✅ Results passed back
- ✅ Context preserved

---

#### Test 1.2: Three-Skill Chain

**Skills to Create**:

1. **skill-c** (transitive)
2. **skill-b** (transitive, calls skill-c)
3. **skill-a** (regular, calls skill-b)

**Test Execution**:
1. Call skill-a
2. Verify chain: skill-a → skill-b → skill-c
3. Verify markers appear: `## SKILL_C_COMPLETE` → `## SKILL_B_COMPLETE`
4. Verify final output: `## SKILL_A_COMPLETE`

---

### Phase 2: Forked Skills Testing

#### Test 2.1: Regular Calls Forked

**Skills to Create**:

1. **skill-forked** (transitive + fork)
```yaml
---
name: skill-forked
description: "Forked skill for testing"
context: fork
agent: Explore
---

## SKILL_FORKED_COMPLETE

[Results from forked context]
```

2. **skill-regular** (regular, calls skill-forked)

**Test Execution**:
1. Call skill-regular
2. Verify skill-forked executes in isolated context
3. Verify results returned
4. Verify completion marker appears

**Expected Results**:
- ✅ Forked skill has Explore capabilities
- ✅ Context isolated
- ✅ Results transferred back

---

#### Test 2.2: Context Isolation Verification

**Skills to Create**:

1. **context-test** (transitive + fork)

**Test Execution**:
1. Set context variables in main conversation:
   - user_preference
   - project_name
   - conversation_history
2. Call context-test
3. Ask forked skill about variables
4. Verify NO access to main context

**Expected Results**:
- ✅ Cannot access main context
- ✅ Isolation confirmed
- ✅ Only Explore tools available

---

### Phase 3: Forked Skills + Subagents

#### Test 3.1: Forked Calls Built-in Subagent

**Skills to Create**:

1. **forked-caller** (transitive + fork)

**Test Execution**:
1. Call forked-caller
2. Verify has Explore tools
3. Test file operations
4. Verify completion marker

**Expected Results**:
- ✅ Can use Read, Grep, Glob
- ✅ Can access filesystem
- ✅ Isolated from main context

---

#### Test 3.2: Forked Calls Custom Subagent

**Subagents to Create**:

1. **custom-worker**
```yaml
---
name: custom-worker
description: "Custom subagent for testing"
tools:
  - Read
  - Grep
model: haiku
---

[Subagent instructions]
```

**Skills to Create**:

1. **forked-calls-custom** (transitive + fork)

**Test Execution**:
1. Call forked-calls-custom
2. Verify can spawn custom-worker
3. Verify custom-worker executes
4. Verify results returned

**Expected Results**:
- ✅ Can spawn subagents
- ✅ Subagent runs in its context
- ✅ Results passed back

---

### Phase 4: Advanced Patterns

#### Test 4.1: Forked Calls Regular

**Skills to Create**:

1. **regular-skill** (transitive)
2. **forked-calls-regular** (transitive + fork, calls regular-skill)

**Test Execution**:
1. Call forked-calls-regular
2. Verify spawns regular-skill in MAIN context
3. Verify context restoration
4. Verify results combined

**Expected Results**:
- ✅ Fork to regular transition
- ✅ Context restored
- ✅ Results available

---

#### Test 4.2: Forked Calls Forked

**Skills to Create**:

1. **forked-inner** (transitive + fork)
2. **forked-outer** (transitive + fork, calls forked-inner)

**Test Execution**:
1. Call forked-outer
2. Verify spawns forked-inner
3. Verify NEW isolated context created
4. Verify nested execution

**Expected Results**:
- ✅ Double fork isolation
- ✅ Two separate contexts
- ✅ Results passed through

---

#### Test 4.3: Parallel Forked Skills

**Skills to Create**:

1. **forked-worker-1** (transitive + fork)
2. **forked-worker-2** (transitive + fork)
3. **parallel-orchestrator** (regular, calls both)

**Test Execution**:
1. Call parallel-orchestrator
2. Verify spawns both workers
3. Verify parallel execution
4. Verify results aggregated

**Expected Results**:
- ✅ Parallel execution
- ✅ Independent contexts
- ✅ Combined results

---

### Phase 5: Context Transfer

#### Test 5.1: Parameters to Forked

**Skills to Create**:

1. **data-receiver** (transitive + fork)
2. **data-sender** (regular, calls data-receiver)

**Test Execution**:
1. Call data-sender
2. Verify parameters passed to forked context
3. Verify main context blocked
4. Verify results returned

**Expected Results**:
- ✅ Parameters passed
- ✅ Main context isolated
- ✅ Results available

---

#### Test 5.2: Context Variables Blocked

**Test Execution**:
1. Set context variables in main
2. Call context-inspector
3. Verify NO access to variables
4. Verify complete isolation

**Expected Results**:
- ✅ Variables inaccessible
- ✅ Complete isolation
- ✅ Only Explore tools

---

### Phase 6: Error Handling

#### Test 6.1: Forked Skill Failure

**Skills to Create**:

1. **failing-forked** (transitive + fork, designed to fail)
2. **forked-caller** (regular, calls failing-forked)

**Test Execution**:
1. Call forked-caller
2. Verify failing-forked fails
3. Verify error propagates
4. Verify main context aware
5. Verify recovery possible

**Expected Results**:
- ✅ Error propagates
- ✅ Main context aware
- ✅ Recovery possible

---

#### Test 6.2: Missing Win Condition

**Skills to Create**:

1. **missing-marker** (transitive, no marker)
2. **waiting-skill** (regular, calls missing-marker)

**Test Execution**:
1. Call waiting-skill
2. Verify waits for marker
3. Verify timeout occurs
4. Verify error detected

**Expected Results**:
- ✅ Timeout occurs
- ✅ Error detected
- ✅ Caller handles missing marker

---

### Phase 7: Real-World Scenarios

#### Test 7.1: Audit Workflow

**Skills to Create**:

1. **code-audit-worker** (transitive + fork, Explore)
2. **security-audit-worker** (transitive + fork, Explore)
3. **audit-orchestrator** (regular, calls both)

**Test Execution**:
1. Call audit-orchestrator
2. Verify parallel workers
3. Verify isolation per worker
4. Verify results combined

**Expected Results**:
- ✅ Parallel workers
- ✅ Isolation
- ✅ Combined results

---

#### Test 7.2: Multi-Stage Analysis

**Skills to Create**:

1. **prepare-data** (transitive)
2. **analyze-data** (transitive + fork, Explore)
3. **format-results** (transitive)
4. **analysis-pipeline** (regular, calls all three)

**Test Execution**:
1. Call analysis-pipeline
2. Verify sequential execution
3. Verify context transitions
4. Verify data flows

**Expected Results**:
- ✅ Context transitions
- ✅ Data flows
- ✅ Only forked isolated

---

## Implementation Checklist

### For Each Test:

- [ ] Create skill files
- [ ] Define win conditions
- [ ] Set up calling relationships
- [ ] Execute test
- [ ] Verify markers appear
- [ ] Verify context behavior
- [ ] Document results
- [ ] Check against expected outcomes

### Validation Criteria:

✅ **Win Conditions**:
- Marker appears in output
- Caller receives results
- Chain continues

✅ **Context Preservation**:
- Main context accessible in regular skills
- Variables available
- Conversation history available

✅ **Context Isolation**:
- Forked skills cannot access main context
- Only Explore tools available
- No conversation access

✅ **Forking Behavior**:
- Regular → Forked works
- Forked → Regular works
- Forked → Forked works
- Parallel execution works

✅ **Error Handling**:
- Failures propagate
- Recovery possible
- Missing markers detected

---

## Documentation Template

For each test, document:

```markdown
## Test [ID]: [Name]

**Setup**:
- Skills created: [list]
- Relationships: [diagram]

**Execution**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Results**:
- ✅/❌ [Validation point 1]
- ✅/❌ [Validation point 2]
- ✅/❌ [Validation point 3]

**Observations**:
- [What happened]
- [Unexpected behavior]
- [Notes]

**Conclusion**:
- [Pass/Fail]
- [Key findings]
- [Implications]
```

---

## Key Questions to Answer

1. **Win Conditions**:
   - Do completion markers work?
   - Can skills wait for markers?
   - Do results transfer back?

2. **Context Handling**:
   - Is main context preserved in regular skills?
   - Is main context blocked in forked skills?
   - Can data be passed to forked skills?

3. **Forking Behavior**:
   - Can forked skills call subagents?
   - Can forked skills call regular skills?
   - Can forked skills call other forked skills?
   - Can multiple forked skills run in parallel?

4. **Error Handling**:
   - Do failures propagate correctly?
   - Can errors be recovered?
   - What happens with missing markers?

5. **Advanced Patterns**:
   - Do hub-and-spoke patterns work?
   - Can context transition between skill types?
   - Does data flow through chains?

---

## Testing Protocol

### Before Each Test:
1. Review test plan
2. Create skill files
3. Set up test environment
4. Define expected outcomes

### During Test:
1. Execute step-by-step
2. Document output
3. Note unexpected behavior
4. Verify markers appear

### After Test:
1. Compare results to expected
2. Document findings
3. Update understanding
4. Plan next test

### After Each Phase:
1. Review all results
2. Identify patterns
3. Update mental model
4. Adjust test plan

---

## Success Criteria

A test **passes** if:
- ✅ All expected markers appear
- ✅ Context behaves as expected
- ✅ Results transfer correctly
- ✅ No unexpected errors

A test **fails** if:
- ❌ Markers don't appear
- ❌ Context leaks where it shouldn't
- ❌ Results don't transfer
- ❌ Unexpected behavior occurs

A test **reveals new behavior** if:
- 🔍 Unexpected but documented behavior
- 🔍 New patterns emerge
- 🔍 Model needs adjustment
- 🔍 Additional tests needed