# Script Integration Patterns

Best practices for leveraging scripts in skills with dynamic context injection and dual output modes.

## Script Location

Skills bundle scripts in their directory for easy access:

```
skill-name/
├── SKILL.md
├── scripts/
│   ├── analyzer.sh
│   └── helpers.sh
└── references/
```

## Dynamic Context Injection

### Basic Pattern

Use `!command` syntax to run commands and insert output:

```markdown
---
description: "Test verification with dynamic data"
---

## Test Analysis

Data from script:
!`bash scripts/analyze_tools.sh test-output.json`

Claude receives actual data, not the command.
```

### Advanced: JSON Parsing

```bash
# Get JSON from script
ANALYSIS=$(bash scripts/analyze_tools.sh test-output.json --json)

# Parse with jq (if available)
AUTONOMY=$(echo "$ANALYSIS" | jq -r '.autonomy_score')
VERDICT=$(echo "$ANALYSIS" | jq -r '.verdict')

# Use in skill content
The test achieved $AUTONOMY% autonomy with verdict: $VERDICT
```

## Dual Output Modes

### Human-Readable (Default)

```bash
bash scripts/analyze_tools.sh test-output.json
```

Output:
```
# Tool/Skill Execution Verification: test-output.json

## 1. Actual Skill Tool Invocations (Critical)

✅ **VERIFIED**: Found actual Skill tool invocations

**Skill Invocations:**
  - Skill: test-skill
    Tool ID: call_function_123

## 2. Tool Result Verification (Success Check)

✅ **VERIFIED**: 1/1 skill tool invocations successful
```

### Machine-Readable (--json flag)

```bash
bash scripts/analyze_tools.sh test-output.json --json
```

Output:
```json
{
  "verdict": "PASS",
  "autonomy_score": 100,
  "autonomy_grade": "Excellence",
  "permission_denials": 0,
  "skill_invocations": 1,
  "verified_success": 1,
  "forked_skills": 0,
  "tasklist_tools": {
    "taskcreate": 0,
    "taskupdate": 0,
    "tasklist": 0
  },
  "completion_markers": ["## TEST_COMPLETE"],
  "hallucination_detected": 0,
  "duration_ms": 5000,
  "num_turns": 10
}
```

## Skill Integration Patterns

### Pattern 1: Script-Driven Analysis

```markdown
## Analysis Phase

Extract test metrics:
!`bash scripts/analyze_tools.sh test-output.json --json | jq -r '.autonomy_score'`

Autonomy: !`bash scripts/analyze_tools.sh test-output.json --json | jq -r '.autonomy_grade'`

Verdict: !`bash scripts/analyze_tools.sh test-output.json --json | jq -r '.verdict'`
```

### Pattern 2: JSON Update Workflow

```bash
# In skill workflow:
ANALYSIS=$(bash scripts/analyze_tools.sh test-output.json --json)

# Parse results
AUTONOMY=$(echo "$ANALYSIS" | jq -r '.autonomy_score')
VERDICT=$(echo "$ANALYSIS" | jq -r '.verdict')
DENIALS=$(echo "$ANALYSIS" | jq -r '.permission_denials')

# Update JSON
Read skill_test_plan.json
Update test with:
- status: COMPLETED
- result: $VERDICT
- autonomy_score: $AUTONOMY
- permission_denials: $DENIALS
Write back to file
```

### Pattern 3: Batch Processing

```bash
# Process multiple files
for file in tests/*.json; do
    echo "Analyzing: $file"
    bash scripts/analyze_tools.sh "$file" --json > "${file%.json}.analysis.json"
done

# Aggregate results
jq -s 'map({file: .file, verdict: .verdict, autonomy: .autonomy_score})' \
   tests/*.analysis.json
```

## Best Practices

### 1. Structured Output

Always provide both human and machine-readable modes:

```bash
#!/usr/bin/env bash

# Check for JSON flag
if [ "$2" = "--json" ]; then
    # Output JSON
    echo '{"key": "value"}'
else
    # Output human-readable
    echo "Key: value"
fi
```

### 2. Error Handling

```bash
#!/usr/bin/env bash

set -euo pipefail  # Exit on error

# Check required arguments
if [ -z "$1" ]; then
    [ "$2" = "--json" ] && echo '{"error": "No file specified"}' || \
        echo "Usage: $0 <file> [--json]"
    exit 1
fi

# Validate file exists
if [ ! -f "$1" ]; then
    [ "$2" = "--json" ] && echo '{"error": "File not found"}' || \
        echo "Error: File not found"
    exit 1
fi
```

### 3. Rich Metadata

Include comprehensive data in JSON mode:

```json
{
  "verdict": "PASS",
  "autonomy_score": 95,
  "autonomy_grade": "Excellence",
  "permission_denials": 0,
  "skill_invocations": 2,
  "forked_skills": 1,
  "tasklist_tools": {
    "taskcreate": 1,
    "taskupdate": 2,
    "tasklist": 1,
    "taskget": 0
  },
  "completion_markers": [
    "## SKILL_A_COMPLETE",
    "## SKILL_B_COMPLETE"
  ],
  "hallucination_detected": false,
  "duration_ms": 7500,
  "num_turns": 15,
  "patterns": ["Regular Chain", "TaskList Workflow"],
  "evidence": {
    "ndjson_valid": true,
    "lines_count": 3,
    "completion_rate": 100
  }
}
```

### 4. Skill Composition

Chain skills with script data:

```markdown
## Workflow

1. Execute test
   → test-output.json

2. Analyze with script
   !`bash scripts/analyze_tools.sh test-output.json --json`

3. Validate with quality framework
   → Apply dimensional scoring (0-10 scale): Structural (30%), Components (50%), Standards (20%)
   → Check for anti-patterns and validate 2026 standards

4. Update JSON
   → Auto-updates test plan
```

## Script Capabilities

### Shell Primitives

Scripts have full shell access:
- **Piping**: `jq`, `grep`, `awk`, `sed`
- **Process substitution**: `$(command)`
- **File operations**: `find`, `ls`, `cat`
- **JSON processing**: `jq` for parsing/generating
- **Network**: `curl`, `wget` (if available)

### Complex Logic

```bash
# Calculate autonomy score
calculate_autonomy() {
    local denials="$1"
    if [ "$denials" -eq 0 ]; then
        echo "100"
    elif [ "$denials" -le 3 ]; then
        echo "90"
    else
        echo "70"
    fi
}

# Detect patterns
detect_patterns() {
    local json="$1"
    local patterns=()

    if echo "$json" | grep -q '"context":"fork"'; then
        patterns+=("Forked Execution")
    fi

    if echo "$json" | grep -q '"name":"TaskCreate"'; then
        patterns+=("TaskList Workflow")
    fi

    printf '%s\n' "${patterns[@]}"
}
```

## Common Patterns

### Pattern: Verification Script

```bash
#!/usr/bin/env bash
# Comprehensive verification with dual output

set -euo pipefail

FILE="${1:-}"
MODE="${2:-}"

error() {
    [ "$MODE" = "--json" ] && \
        echo "{\"error\": \"$1\"}" || \
        echo "Error: $1"
    exit 1
}

[ -z "$FILE" ] && error "No file specified"
[ ! -f "$FILE" ] && error "File not found"

# Perform verification
SKILLS=$(grep -c '"name":"Skill"' "$FILE" || echo "0")

if [ "$MODE" = "--json" ]; then
    cat <<EOF
{
  "file": "$FILE",
  "skill_count": $SKILLS,
  "verified": true
}
EOF
else
    echo "File: $FILE"
    echo "Skills: $SKILLS"
    echo "Status: Verified"
fi
```

### Pattern: JSON Aggregator

```bash
#!/usr/bin/env bash
# Aggregate multiple JSON files

for file in "$@"; do
    [ -f "$file" ] || continue
    cat "$file"
done | jq -s 'reduce .[] as $item ({}; . + $item)'
```

## Testing Scripts

### Verify Script Works

```bash
# Test human-readable mode
bash scripts/analyze_tools.sh test.json

# Test JSON mode
bash scripts/analyze_tools.sh test.json --json | jq .

# Test error handling
bash scripts/analyze_tools.sh missing.json --json
```

### Integration Test

```bash
# Create test file
echo '{"test": true}' > test.json

# Run through skill
test-runner "Analyze" test.json

# Verify output
jq '.autonomy_score' test-analysis.json
```

## Benefits of Script Integration

1. **Separation of Concerns**
   - Skill content: Instructions and workflows
   - Scripts: Complex logic and data processing

2. **Reusability**
   - Scripts can be used across multiple skills
   - Shared verification logic

3. **Testability**
   - Scripts can be tested independently
   - Easy to verify logic separately

4. **Maintainability**
   - Update script logic without changing skill
   - Clear separation of responsibilities

5. **Performance**
   - Scripts run with full shell capabilities
   - Can use optimized tools (jq, awk, etc.)

## Anti-Patterns

❌ **DON'T**: Put complex logic in SKILL.md
❌ **DON'T**: Use skill content for data processing
❌ **DON'T**: Hardcode values in skill content
❌ **DON'T**: Ignore error handling in scripts

✅ **DO**: Move complex logic to scripts
✅ **DO**: Use dynamic context injection
✅ **DO**: Provide both output modes
✅ **DO**: Handle errors gracefully
