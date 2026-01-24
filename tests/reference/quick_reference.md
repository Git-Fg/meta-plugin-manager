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

## Pre-Flight Checklist (MANDATORY)

**Before EVERY test, verify**:

### Setup
- [ ] Test folder created at `/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/`
- [ ] Create skill files with absolute paths
- [ ] Define relationships between skills
- [ ] Set win conditions (## COMPLETE markers)
- [ ] Prepare test data

### YAML Frontmatter
- [ ] Skills have correct YAML frontmatter
- [ ] `name`, `description` fields present
- [ ] `context: fork` for forked skills
- [ ] `user-invocable: true` if needed

### Execution Readiness
- [ ] test-output.json will be saved in test folder
- [ ] You will analyze the log using test-runner skill (then read manually if needed)
- [ ] Absolute paths used (no /tmp/, no relative paths)
- [ ] cd only used to set working directory (not for navigation)
- [ ] Non-interactive flags prepared:
  - `--dangerously-skip-permissions`
  - `--output-format stream-json`
  - `--verbose --debug`
  - `--no-session-persistence`
  - `--max-turns N`

**ONLY after checklist complete, proceed to execution.**

## Post-Test Verification Checklist

### NDJSON Structure
- [ ] **3 lines present** - `wc -l test-output.json`
- [ ] **Line 1**: System init with skills array
- [ ] **Line 2**: Assistant message with markers
- [ ] **Line 3**: Result with num_turns, permission_denials

### Execute
- [ ] Call skill
- [ ] Verify markers appear
- [ ] Check context behavior
- [ ] Document output

### Validate
- [ ] Win conditions work
- [ ] Context preserved/blocked correctly
- [ ] Results transfer
- [ ] Autonomy score: permission_denials = []
- [ ] No unexpected errors

### Document & Archive
- [ ] Results match expected
- [ ] Unexpected behavior noted
- [ ] Archive to `.attic/test_name_success`
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

## NDJSON Output Format (MANDATORY)

Every test produces exactly **3 lines** of NDJSON:

### Line 1: System Initialization
```json
{"type":"system","subtype":"init","cwd":"...","tools":[...],"skills":[...],"agents":[...]}
```
- Verifies skills loaded
- Shows available tools and agents

**Verification**: `head -1 test-output.json`

### Line 2: Assistant Message
```json
{"type":"assistant","content":[{"type":"text","text":"..."}]}
```
- Contains skill execution output
- Includes completion markers (## SKILL_COMPLETE)

**Verification**: `sed -n '2p' test-output.json`

### Line 3: Result Summary
```json
{"type":"result","result":{"num_turns":10,"duration_ms":5000,"permission_denials":[]}}
```
- `permission_denials`: Autonomy score (empty = 100%)
- `num_turns`: Conversation rounds
- `duration_ms`: Execution time
- `total_cost_usd`: Cost

**Verification**: `tail -1 test-output.json`

### Quick Verification Commands
```bash
# Check 3 lines present
[ "$(wc -l < test-output.json)" -eq 3 ] && echo "✅ NDJSON OK"

# Verify autonomy
grep '"permission_denials": \[\]' test-output.json && echo "✅ 100% Autonomy"

# Check completion markers
grep "COMPLETE" test-output.json
```

---

## Quick Test Commands

### Execute Test (Non-Interactive)
```bash
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name
claude --dangerously-skip-permissions -p "Call skill-name" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json 2>&1
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

### Archive Successful Tests
```bash
mv /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name \
   /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/.attic/test_name_success
```

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