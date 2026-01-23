# Skill Testing Quick Reference

## Test Phases Summary

### Phase 1: Basic Calling (Skills Calling Skills)
- **1.1**: Linear chain (A → B)
- **1.2**: Three-skill chain (A → B → C)
- **Goal**: Verify win conditions work

### Phase 2: Forked Skills
- **2.1**: Regular calls forked
- **2.2**: Context isolation verification
- **2.3**: Forked skills cannot ask questions
- **Goal**: Verify forking behavior

### Phase 3: Forked + Subagents
- **3.1**: Forked calls built-in subagent (Explore)
- **3.2**: Forked calls custom subagent
- **Goal**: Verify subagent access from forks

### Phase 4: Advanced Patterns
- **4.1**: Forked calls regular skill
- **4.2**: Forked calls forked (double fork)
- **4.3**: Parallel forked skills
- **Goal**: Test complex interactions

### Phase 5: Context Transfer
- **5.1**: Pass parameters to forked
- **5.2**: Variables blocked in forked
- **Goal**: Verify context boundaries

### Phase 6: Error Handling
- **6.1**: Forked skill failure
- **6.2**: Missing win condition
- **Goal**: Test error scenarios

### Phase 7: Real-World
- **7.1**: Audit workflow
- **7.2**: Multi-stage analysis
- **Goal**: Practical scenarios

---

## Skill Types Reference

### Regular Skill
```yaml
---
name: regular-skill
description: "User-invocable or standalone skill"
---

[No win condition needed]
```

### Transitive Skill
```yaml
---
name: transitive-skill
description: "Called by other skills"
---

## TRANSITIVE_SKILL_COMPLETE

[Output results]
```

### Forked Skill
```yaml
---
name: forked-skill
description: "Runs in isolated context"
context: fork
agent: Explore
---

## FORKED_SKILL_COMPLETE

[Output results]
```

---

## Win Condition Markers

Each transitive skill MUST output completion marker:

- `## SKILL_B_COMPLETE`
- `## SKILL_A_COMPLETE`
- `## FORKED_SKILL_COMPLETE`
- `## QUALITY_VALIDATION_COMPLETE`

**Purpose**: Signal completion to calling skill

---

## Context Rules

### Regular Skills
- ✅ Can access main context
- ✅ Can access conversation history
- ✅ Can access user preferences
- ✅ Can access project information
- ✅ Can call other skills

### Forked Skills
- ❌ Cannot access main context
- ❌ Cannot access conversation history
- ❌ Cannot access user preferences
- ❌ Cannot access project information
- ✅ Can call subagents
- ✅ Can use Explore tools
- ✅ Can perform isolated operations

---

## Testing Checklist

For each test:

### Setup
- [ ] Create skill files
- [ ] Define relationships
- [ ] Set win conditions
- [ ] Prepare test data

### Execute
- [ ] Call skill
- [ ] Verify markers appear
- [ ] Check context behavior
- [ ] Document output

### Validate
- [ ] Win conditions work
- [ ] Context preserved/blocked correctly
- [ ] Results transfer
- [ ] No unexpected errors

### Document
- [ ] Results match expected
- [ ] Unexpected behavior noted
- [ ] Model updated if needed

---

## Expected Behaviors

### Skill Calling Skills
✅ Win condition markers appear
✅ Results pass back
✅ Context preserved
✅ Chain continues

### Forked Skills
✅ Isolated from main context
✅ Have Explore tools
✅ Cannot ask questions
✅ Results pass back

### Forked + Subagents
✅ Can spawn subagents
✅ Subagents execute
✅ Results combine
✅ Isolation maintained

### Error Handling
✅ Errors propagate
✅ Main context aware
✅ Recovery possible
✅ Missing markers detected

---

## Key Questions to Answer

1. Do win conditions work as completion markers?
2. Can skills wait for markers?
3. Is context preserved in regular skills?
4. Is context isolated in forked skills?
5. Can forked skills access subagents?
6. Can forked skills call regular skills?
7. Can forked skills call other forked skills?
8. Can multiple forked skills run in parallel?
9. Can data be passed to forked skills?
10. Do errors propagate correctly?

---

## Quick Test Commands

### Call a Skill
```
/skill-name [parameters]
```

### Verify Completion Marker
Look for:
```
## SKILL_NAME_COMPLETE
```

### Check Context Access
Ask forked skill about:
- User preferences
- Project name
- Conversation history
- Previous steps

Expected: No access in forked context

---

## Common Patterns

### Hub-and-Spoke
```
Hub Skill
  → Forked Worker 1 (isolated)
  → Forked Worker 2 (isolated)
  → Combine Results
```

### Sequential Chain
```
Skill A → Skill B → Skill C
(Regular → Regular → Regular)
```

### Mixed Context
```
Regular Skill
  → Forked Skill (isolated)
  → Regular Skill (restored)
```

### Parallel Execution
```
Regular Skill
  → Worker A (isolated)
  → Worker B (isolated)
  → Aggregate Results
```

---

## Troubleshooting

### Win Condition Not Appearing
- Check skill outputs marker
- Verify skill completes
- Check for errors

### Context Leak in Forked
- Should NOT happen
- Indicates bug in fork
- Document and report

### Results Not Transferring
- Check win condition
- Verify calling relationship
- Check for errors

### Forked Skill Hangs
- May be waiting for input
- Forked skills cannot ask questions
- Should complete autonomously

---

## Document Results Template

```markdown
## Test [ID]: [Name]

**Setup**: [Skills created]
**Execution**: [Steps taken]
**Results**:
- ✅/❌ [Point 1]
- ✅/❌ [Point 2]
- ✅/❌ [Point 3]

**Observations**: [What happened]
**Conclusion**: [Pass/Fail/Finds]
```

---

## Phase Progression

**Start with Phase 1**:
- Simple skill calling
- Win conditions
- Basic context

**Then Phase 2**:
- Forked skills
- Context isolation
- Win conditions in forks

**Then Phase 3**:
- Forked + subagents
- Tool access
- Isolation confirmed

**Then Phase 4**:
- Advanced patterns
- Complex interactions
- Edge cases

**Then Phase 5**:
- Context transfer
- Parameter passing
- Boundaries

**Then Phase 6**:
- Error handling
- Failure scenarios
- Recovery

**Finally Phase 7**:
- Real-world scenarios
- Practical use cases
- Integration
```