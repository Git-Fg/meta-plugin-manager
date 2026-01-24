# Autonomy Testing Framework

Evaluating skill autonomy (80-95% completion without questions). Forked skills MUST complete without asking questions.

## Scoring Rubric

| Score | Questions | Completion | Grade |
|-------|-----------|------------|-------|
| 95% | 0-1 | 100% | Excellence |
| 85% | 2-3 | 90% | Good |
| 80% | 4-5 | 80% | Acceptable |
| <80% | 6+ | <80% | Fail |

## What Counts as a Question

**Reduces autonomy (❌)**:
- "Which file should I modify?"
- "What should I name this variable?"
- "Should I use X or Y approach?"
- "How do you want me to proceed?"

**Does NOT count (✅ - operational)**:
- Reading files for context
- Running bash commands as part of workflow
- Checking diagnostics
- Executing tests

## Scoring from test-output.json

**Check Line 3 (result):**
```json
"permission_denials": [
  {
    "tool_name": "AskUserQuestion",
    "tool_input": { "questions": [...] }
  }
]
```

**Autonomy calculation:**
- Count entries in `"permission_denials"` where `tool_name === "AskUserQuestion"`
- Each = 1 question
- 0 questions = 95-100% autonomy
- 1-3 questions = map to 85-95%
- 4-5 questions = map to 80-84%
- 6+ questions = <80% (fail)

## Autonomy Verification

```bash
# Check permission_denials array (MANDATORY)
grep -o '"permission_denials": \[\]' <project_path>/test_folder/test-output.json

# Alternative: Check for empty permission_denials
if grep -q '"permission_denials": \[\]' <project_path>/test_folder/test-output.json; then
  echo "✅ PASS: No questions asked"
else
  echo "⚠️ FAIL: Questions detected"
fi
```

**Expected**: `"permission_denials": []` (empty array)

## Autonomy Test Template

```bash
cat > <project_path>/test_autonomy/.claude/skills/test-autonomy/SKILL.md << 'EOF'
---
name: test-autonomy
description: "Tests skill autonomy"
user-invocable: true
context: fork
---

You are a forked skill. Task: Choose between Option A or B for a project.

**CRITICAL**: You are in a forked context and CANNOT ask the user.
Make your own decision based on built-in criteria.

Output: ## AUTONOMY_TEST_COMPLETE with your decision.
EOF

cd <project_path>/test_autonomy && claude --dangerously-skip-permissions -p "Call test-autonomy" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > <project_path>/test_autonomy/test-output.json 2>&1

# Verify autonomy
if grep -q '"permission_denials": \[\]' <project_path>/test_autonomy/test-output.json; then
  echo "✅ AUTONOMY: PASS (no questions asked)"
else
  echo "❌ AUTONOMY: FAIL (questions detected)"
  grep '"permission_denials"' <project_path>/test_autonomy/test-output.json || true
fi
```

## Autonomy Scoring (Permission Denials)

| Permission Denials | Autonomy Score | Grade |
|-------------------|---------------|-------|
| 0 | 100% | A+ |
| 1 | 95% | A |
| 2-3 | 85-90% | B |
| 4-5 | 75-80% | C |
| 6+ | <75% | FAIL |

## Improving Autonomy Score

### 1. Add Decision Criteria

Instead of asking "Should I use X or Y?", provide criteria:

```markdown
## Decision Logic
- Use TypeScript when: project uses tsconfig.json
- Use JavaScript when: no tsconfig.json present
- Default to TypeScript for new projects
```

### 2. Provide Examples

Instead of asking "What format?", show expected output:

```markdown
## Expected Output Format
```json
{
  "status": "success",
  "files": ["path/to/file"],
  "summary": "description"
}
```
```

### 3. Include Context Sources

Instead of asking "Which config file?", specify:

```markdown
## Configuration Files
- Primary: `.claude/config.json`
- Fallback: `package.json` (if using npm)
- Environment: `.env` (for local overrides)
```

### 4. Define Defaults

Instead of asking for preferences, provide sensible defaults:

```markdown
## Defaults (override with specific criteria)
- Port: 3000
- Environment: development
- Output: ./dist/
```

## Common Autonomy Violations

- Asking for clarification
- Seeking user approval
- Deferring decisions
- Requesting additional information

## Autonomous Design Principles

✅ **DO**: Include decision criteria in skill content
✅ **DO**: Provide default behaviors for all scenarios
✅ **DO**: Make choices based on project context
✅ **DO**: Complete without user interaction

❌ **DON'T**: Include question words in skill content
❌ **DON'T**: Leave decisions to the user
❌ **DON'T**: Ask for clarification
❌ **DON'T**: Request approval or confirmation

## Real-World Autonomy Examples

**Poor (50% autonomy - asks 3 questions):**
```
"What framework should I use?"
"Where should I create the component?"
"What should I name the file?"
```

**Good (90% autonomy - 1 validation question):**
```
"Creating component in ./src/components/ using React (detected from package.json).
Name: UserProfile.tsx. Confirm or provide alternative name?"
```

**Excellent (95% autonomy - 0 questions):**
```
"Created UserProfile.tsx in ./src/components/ based on existing patterns."
```
