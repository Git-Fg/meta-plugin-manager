# Autonomy Testing Framework

## Purpose
Ensure skills and agents complete without user interaction (asking questions, requesting clarification, etc.)

---

## The Autonomy Requirement

**Definition**: An autonomous skill/agent completes its task without requesting user input, clarification, or approval.

**Why Critical**:
- Non-interactive workflows require autonomy
- Forked skills must work independently
- Background workers cannot pause for user decisions
- Automation depends on autonomous execution

---

## Testing Methodology

### Step 1: Pre-Test Autonomy Checklist

Before executing any test, verify the skill is designed for autonomy:

```markdown
- [ ] Skill has no user-interactive prompts
- [ ] Skill has decision criteria built-in
- [ ] Skill has default behaviors for all scenarios
- [ ] Skill does NOT contain "ask", "clarify", "confirm", "should I"
- [ ] Skill has explicit completion markers
```

### Step 2: Execution with Autonomy Monitoring

Run the test with non-interactive flags:

```bash
--dangerously-skip-permissions
--no-session-persistence
--output-format stream-json
```

### Step 3: Verify Autonomy in Output

**Primary Check**: `permission_denials` array
```bash
# Check for empty permission_denials array
grep '"permission_denials": \[\]' test-output.json
```

**Alternative Robust Check**:
```bash
# If permission_denials exists but is not empty, show it
if grep -q '"permission_denials"' test-output.json; then
  echo "Permission denials found:"
  grep -A 3 '"permission_denials"' test-output.json
else
  echo "✅ No permission_denials in output (autonomous)"
fi
```

**Secondary Checks**:
- Completion marker present: `grep "COMPLETE" test-output.json`
- No "I'll need you to..." phrases: `grep -i "need.*you\|ask.*you" test-output.json`
- Num turns reasonable: `grep "num_turns" test-output.json`

---

## Autonomy Scoring

| Permission Denials | Autonomy Score | Grade |
|-------------------|---------------|-------|
| 0 | 100% | A+ |
| 1 | 95% | A |
| 2-3 | 85-90% | B |
| 4-5 | 75-80% | C |
| 6+ | <75% | FAIL |

**Formula**: `Autonomy % = (1 - permission_denials/10) * 100`

---

## Test Pattern Templates

### Template 1: Basic Autonomy Test

```bash
# Setup (use absolute paths)
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy/.claude/skills/test-skill

# Create skill with built-in decisions
cat > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy/.claude/skills/test-skill/SKILL.md << 'EOF'
---
name: test-skill
description: "Tests skill autonomy"
user-invocable: true
context: fork
---

You are a forked skill. Task: Choose between Option A or B for a project.

**CRITICAL**: You are in a forked context and CANNOT ask the user.
Make your own decision based on best practices.

Output: ## AUTONOMY_TEST_COMPLETE with your decision.
EOF

# Execute (cd only used to set working directory)
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy && \
claude --dangerously-skip-permissions -p "Call test-skill" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy/test-output.json 2>&1

# Verify autonomy
if grep -q '"permission_denials": \[\]' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy/test-output.json; then
  echo "✅ AUTONOMY PASS"
else
  echo "❌ AUTONOMY FAIL"
  grep -A 3 '"permission_denials"' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy/test-output.json
fi

# Archive successful tests
mv /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_autonomy \
   /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/.attic/test_autonomy_success
```

### Template 2: Multi-Decision Autonomy Test

```bash
# Test skills that must make multiple decisions

cat > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_decision/.claude/skills/decision-tree/SKILL.md << 'EOF'
---
name: decision-tree
description: "Tests complex decision-making autonomy"
user-invocable: true
context: fork
---

You are a forked skill implementing a decision tree.

Step 1: Choose between X or Y
Step 2: Based on Step 1, choose between A or B
Step 3: Output final decision

**CRITICAL**: You cannot ask questions. Make all decisions independently.

Output: ## DECISION_TREE_COMPLETE with final decision and path taken.
EOF

# Execute with extended max-turns (cd only for working directory)
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_decision && \
claude --dangerously-skip-permissions -p "Call decision-tree" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 15 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_decision/decision-test.json 2>&1

# Verify autonomy AND complexity
jq '.result.permission_denials | length' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_decision/decision-test.json
jq '.result.num_turns' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_decision/decision-test.json

# Verify NDJSON structure (3 lines)
wc -l /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_decision/decision-test.json
# Should output: 3
```

---

## Common Non-Autonomous Patterns (AVOID)

### Pattern 1: Asking for Clarification
```markdown
# ❌ BAD - Asks for input
"I need to know which approach you prefer. Should I use Option A or Option B?"
```

### Pattern 2: Deferred Decision
```markdown
# ❌ BAD - Wants user to decide
"You should decide whether to proceed with this approach."
```

### Pattern 3: Seeking Approval
```markdown
# ❌ BAD - Requests confirmation
"Should I proceed with this plan? Please confirm."
```

---

## Autonomous Patterns (USE)

### Pattern 1: Built-in Decision Criteria
```markdown
# ✅ GOOD - Makes own decision
"Based on the TypeScript-first policy and type safety requirements,
I will choose Option A (TypeScript) as it aligns with project standards."
```

### Pattern 2: Default Behaviors
```markdown
# ✅ GOOD - Has fallbacks
"If no configuration is found, use default settings: verbose logging, strict mode."
```

### Pattern 3: Explicit Completion
```markdown
# ✅ GOOD - Completes independently
"Decision made and task completed."
## AUTONOMY_TEST_COMPLETE
```

---

## Testing Forked Skill Autonomy

Forked skills MUST be autonomous by design:

```yaml
# Skill with autonomy requirement
---
name: autonomous-worker
description: "Background worker that cannot ask questions"
context: fork  # Isolation + autonomy required
---

1. Make all decisions independently
2. Use built-in heuristics
3. Never ask the user
4. Complete with: ## WORKER_COMPLETE

Default decision rules:
- If uncertain: choose safer option
- If ambiguous: pick standard approach
- If missing info: use sensible defaults
```

**Verification**:
```bash
# Check permission_denials array is empty
jq '.result.permission_denials' test-output.json
# Should output: []
```

---

## Anti-Pattern: Interactive Skills

Some skills ARE allowed to be interactive (user-invocable with questions):

```yaml
# ⚠️ SPECIAL CASE - Interactive by design
---
name: interactive-configuration
description: "Helps users configure project - may ask questions"
user-invocable: true
context: regular  # NOT forked
---

This skill CAN ask questions because its purpose is user interaction.
It should NOT be tested for autonomy.
```

**Rule**: Skills with `context: fork` MUST be autonomous. Regular skills may be interactive.

---

## Test Automation

### Autonomy Test Script

```bash
#!/bin/bash
# autonomy-test.sh - Verify skill autonomy

SKILL_NAME="$1"
TEST_DIR="/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/$SKILL_NAME"

echo "Testing autonomy for: $SKILL_NAME"

# Create test directory
mkdir -p "$TEST_DIR/.claude/skills/$SKILL_NAME"

# Run test (cd only to set working directory)
cd "$TEST_DIR" && \
claude --dangerously-skip-permissions -p "Call $SKILL_NAME" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > "$TEST_DIR/autonomy-test.json" 2>&1

# Check NDJSON structure (must have 3 lines)
LINE_COUNT=$(wc -l < "$TEST_DIR/autonomy-test.json")
if [ "$LINE_COUNT" -ne 3 ]; then
  echo "❌ ERROR: Expected 3 lines, got $LINE_COUNT"
  exit 1
fi

# Check permission_denials
if grep -q '"permission_denials": \[\]' "$TEST_DIR/autonomy-test.json"; then
  echo "✅ AUTONOMY: PASS (no questions asked)"
  exit 0
elif grep -q '"permission_denials"' "$TEST_DIR/autonomy-test.json"; then
  echo "❌ AUTONOMY: FAIL (questions detected)"
  echo "Permission denials found:"
  grep -A 3 '"permission_denials"' "$TEST_DIR/autonomy-test.json"
  exit 1
else
  echo "❌ ERROR: Could not find permission_denials in output"
  exit 1
fi
```

**Usage**:
```bash
./autonomy-test.sh skill-name
```

**Note**: Test runs in /tests/skill-name/ with absolute paths.

---

## Documentation Requirements

Every skill should document its autonomy:

```yaml
---
name: skill-name
description: "What the skill does"
autonomy: required|optional|none  # NEW FIELD
context: fork|regular
---

# Autonomy Design

This skill is designed for autonomy because:
- It runs in forked context (isolation required)
- It makes decisions based on built-in criteria
- It has default behaviors for all scenarios

Decision criteria:
- Use TypeScript if project has .ts files
- Use JavaScript if only .js files exist
- Default to TypeScript if unknown

This skill will NEVER ask the user for input.
```

---

## Quality Gates

### For Forked Skills
- ✅ Must have `autonomy: required`
- ✅ Must have decision criteria
- ✅ Must have default behaviors
- ✅ Permission denials MUST be 0

### For Regular Skills
- ⚠️ May be interactive (autonomy: optional)
- ⚠️ Should document if interactive
- ⚠️ Permission denials can be >0

### For Commands
- ✅ May be interactive (user-driven)
- ✅ Autonomy not required

---

## Summary Checklist

**Before Testing**:
- [ ] Skill has autonomy requirement documented
- [ ] Skill has built-in decision criteria
- [ ] Skill has default behaviors
- [ ] Skill does NOT contain question words
- [ ] Test directory created with absolute path
- [ ] Win condition marker defined

**During Testing**:
- [ ] Run with `--dangerously-skip-permissions`
- [ ] Use `--output-format stream-json`
- [ ] Set reasonable `--max-turns`
- [ ] Monitor permission_denials array
- [ ] Verify NDJSON structure (3 lines)

**After Testing**:
- [ ] Verify permission_denials is empty
- [ ] Check completion marker present
- [ ] Review any assistant messages for questions
- [ ] Document autonomy score
- [ ] Archive to .attic/ (successful tests)
- [ ] Read FULL test-output.json

---

## NDJSON Structure Verification (MANDATORY)

Every test must produce exactly 3 lines of NDJSON:

**Line 1: System Initialization**
```bash
head -1 test-output.json | jq .
# Should show: tools, skills, agents, mcp_servers
```

**Line 2: Assistant Message**
```bash
sed -n '2p' test-output.json | jq .
# Contains skill execution and completion markers
```

**Line 3: Result Summary**
```bash
tail -1 test-output.json | jq .
# Contains: num_turns, duration_ms, permission_denials
```

**Quick Verification**:
```bash
# Check 3 lines present
[ "$(wc -l < test-output.json)" -eq 3 ] && echo "✅ NDJSON structure OK"

# Check autonomy
grep '"permission_denials": \[\]' test-output.json && echo "✅ 100% Autonomy"
```

---

## Integration with Test Suite

**In each test phase, add autonomy verification**:
```markdown
### Phase X: Autonomy Verification
- Run skill with non-interactive flags
- Check: permission_denials = []
- Verify: NDJSON structure (3 lines)
- Score: 100% (A) if 0, FAIL if >0
- Document autonomy score
```

**Example**:
```markdown
## Test Results
- Autonomy: 100% (A) ✅
- NDJSON Structure: 3 lines ✅
- Context Isolation: PASS ✅
- Parameter Passing: PASS ✅
- Completion: PASS ✅

Overall: PASS ✅
```

---

This framework ensures every skill is systematically tested for autonomy, preventing interactive behaviors in automated workflows.
