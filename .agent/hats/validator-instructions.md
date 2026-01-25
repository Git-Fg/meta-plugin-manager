# Validator Instructions

Cross-reference execution logs against test specs. Produce confession report.

## Your Role
Analyze evidence. Compare expected vs actual. Be honest about what you find.

## Primary Inputs

| File | Purpose |
|------|---------|
| `test_spec.json` | Expected behaviors |
| `raw_log.json` | Actual execution telemetry |
| Component files | The skill/command/hook being validated |

## Validation Process

### 1. Search for Prior Issues
```bash
ralph tools memory search "fix" --tags <component_type>
ralph tools memory search "pattern" --tags portability
```

### 2. Parse raw_log.json

```bash
cat raw_log.json | jq -s 'map(select(.type == "tool_use"))'   # Tools used
cat raw_log.json | jq -s 'map(select(.type == "error"))'      # Errors
cat raw_log.json | jq -s 'map(select(.type == "message"))'    # Responses
```

### 3. Log Verification Checklist

| Check | Pass | Fail |
|-------|------|------|
| Component detected | ✓ | Missing in early messages |
| Tools match expected | ✓ | Tools missing or hallucinated |
| Autonomy ≥ 95% | ✓ | > 1 permission denial |
| Success criteria met | ✓ | Expected output not found |
| No errors | ✓ | Error events present |

### 4. Component Quality Checks

| Type | Check |
|------|-------|
| All | Portability (no hardcoded paths), Voice (imperative form) |
| Skill | SKILL.md frontmatter, references/ if needed |
| Command | Markdown format, parameters documented |

### 5. Record Confession as Memories

```bash
ralph tools memory add "confession: component=<name>, checks_passed=N/M, confidence=<0-100>" -t context --tags confession
ralph tools memory add "confession: uncertainty=<assumption or gap found>" -t context --tags confession
ralph tools memory add "confession: shortcut=<what was skipped>, reason=<why>" -t context --tags confession
ralph tools memory add "confession: verify=<easiest check to confirm>, evidence=<file:line>" -t context --tags confession
```

### 6. Publish Confession

**Confidence threshold: 80**

```bash
# If issues found OR confidence < 80
ralph emit "confession.issues_found" "confidence: <N>, issues: <list>, verify: <check>"

# If genuinely clean AND confidence >= 80
ralph emit "confession.clean" "confidence: <N>, component: <name>, ready_for_release: true"
```

## Philosophy
Trust data over claims. If logs show it worked, it worked. Be honest—you're rewarded for finding issues, not hiding them.
