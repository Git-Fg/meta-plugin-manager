---
name: tool-analyzer
description: "Analyze tool usage patterns from stream-json log files and verify test suites"
user-invocable: true
---

# Tool Analyzer

Analyzes JSON log files from Claude Code execution to extract tool usage patterns, verify skill invocations, and detect hallucinations. Works on single files or entire test suites.

## Usage

**Single File Analysis**:
```
tool-analyzer /path/to/test-output.json
```

**Batch Processing (Entire Test Suite)**:
```
tool-analyzer tests/raw_logs/
```

The analyzer automatically discovers, processes, and verifies all test files with comprehensive reporting.

## Verification Logic (Embedded)

The analyzer includes built-in verification logic for each test file:

### Single File Verification
```bash
# Extract metrics from JSON
DURATION=$(grep -o '"duration_ms":[0-9]*' "$FILE" | head -1 | cut -d':' -f2)
PERMISSION_DENIALS=$(grep -o '"permission_denials":\[[^]]*\]' "$FILE")
ACTUAL_SKILLS=$(grep -o '"name":"Skill"' "$FILE" | wc -l)

# Verify skill count
if [ "$ACTUAL_SKILLS" -eq "$EXPECTED" ]; then
  echo "✅ PASS: Correct skill invocations"
fi

# Check autonomy
if grep -q '"permission_denials": \[\]' "$FILE"; then
  echo "✅ AUTONOMY: 100% (no questions)"
fi
```

### Batch Processing Logic
```bash
# Discover all JSON files
for file in $(find tests/raw_logs/ -name "*.json" -type f); do
  # Verify each file
  VERIFY_FILE "$file"

  # Track results
  TOTAL=$((TOTAL + 1))
  if [ "$STATUS" = "PASS" ]; then
    PASSED=$((PASSED + 1))
  fi
done

# Generate summary
echo "Total: $TOTAL | Passed: $PASSED | Failed: $((TOTAL - PASSED))"
```

## What It Does

### Single File Analysis
Examines stream-json output and reports:
- Total tool invocations
- Skill calls breakdown
- Execution pattern (single/chain/forked)
- Success rates
- Verification details
- Autonomy scores
- Hallucination detection

### Batch Processing (Test Suites)
1. **Discovers** all JSON files recursively
2. **Verifies** each file with embedded logic
3. **Aggregates** results across entire suite
4. **Identifies** patterns, failures, anomalies
5. **Detects** hallucinations across tests
6. **Generates** comprehensive reports

## Examples

### Single File Analysis
```bash
tool-analyzer tests/test_4_4/test-output.json
tool-analyzer tests/test_8_1/test-output.json
tool-analyzer /path/to/your/test-output.json
```

### Batch Test Suite Processing
```bash
# Process entire suite
tool-analyzer tests/raw_logs/

# Process specific phase
tool-analyzer tests/raw_logs/phase_2/

# Process phase_1:
# - test_1.1.basic.skill.calling.json
# - test_1.2.three.skill.chain.json
```

### Expected Output
```
=== HALLUCINATION DETECTION REPORT ===

PHASE: phase_1
▶ test_1.1.basic.skill.calling.json
  Duration: 7,736ms | Skills: 2 | Autonomy: 100%
  ✅ PASS

▶ test_1.2.three.skill.chain.json
  Duration: 13,399ms | Skills: 2 | Autonomy: 100%
  ✅ PASS

[... continues for all files ...]

Total: 25 | Verified: 25 | Failed: 0
Hallucination Detection: NONE ✅
```

## Execution Workflow

### For Single Tests:
1. **Call** `tool-analyzer` with test file path
2. **Analyzer** extracts metrics, verifies execution
3. **Review** output for issues or patterns
4. **Read** full log manually only if needed

### For Test Suites (Batch Mode):
1. **Call** `tool-analyzer tests/raw_logs/`
2. **Analyzer automatically**:
   - Discovers all `*.json` files recursively
   - Verifies each file using embedded logic
   - Aggregates results across all tests
   - Identifies patterns, failures, anomalies
3. **Review** comprehensive automated report
4. **Inspect** only flagged tests manually

### What Happens (Embedded Logic):

**Phase 1: Discovery**
```bash
# Find all test files
find tests/raw_logs/ -name "*.json" -type f | sort
```

**Phase 2: Verification**
```bash
# Process each file
for file in $FILES; do
  # Extract metrics
  DURATION=$(extract_duration "$file")
  SKILLS=$(count_skill_invocations "$file")
  PERMISSIONS=$(check_permission_denials "$file")

  # Verify against expectations
  if [ "$SKILLS" -eq "$EXPECTED" ]; then
    STATUS="PASS"
  fi

  # Track results
  record_result "$file" "$STATUS"
done
```

**Phase 3: Aggregation**
```bash
# Compile summary
TOTAL=$(count_total_tests)
PASSED=$(count_passed_tests)
FAILED=$((TOTAL - PASSED))

# Generate report
generate_report "$TOTAL" "$PASSED" "$FAILED"
```

**Phase 4: Output**
- Per-file verification results
- Aggregate statistics
- Autonomy scores
- Hallucination detection
- Phase-by-phase breakdown
