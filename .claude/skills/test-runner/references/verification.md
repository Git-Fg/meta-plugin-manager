# Verification Logic

Extracts metrics from JSON log files to verify skill invocations, detect execution patterns, and identify anomalies.

## NDJSON Structure (3 Lines)

- **Line 1**: System init (`tools`, `skills`, `agents`, `mcp_servers`)
- **Line 2**: Assistant message
- **Line 3**: Result (`num_turns`, `duration_ms`, `permission_denials`)

## Verification Metrics

### Single File Analysis
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

## What It Reports

### Single File Analysis
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

## Expected Output Format

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
1. **Call** `test-runner` with test file path
2. **Analyzer** extracts metrics, verifies execution
3. **Review** output for issues or patterns
4. **Read** full log manually only if needed

### For Test Suites (Batch Mode):
1. **Call** `test-runner tests/raw_logs/`
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

## Tool Detection

### Built-in Tool Verification

**Check for specific tool usage:**
```bash
# Count Tool tool uses
TOOL_COUNT=$(grep -o '"name":"Tool"' "$FILE" | wc -l)

# Count Task tool uses (TaskList tools)
TASKLIST_COUNT=$(grep -o '"name":"Task"' "$FILE" | wc -l)
TASKCREATE_COUNT=$(grep -o '"name":"TaskCreate"' "$FILE" | wc -l)
TASKUPDATE_COUNT=$(grep -o '"name":"TaskUpdate"' "$FILE" | wc -l)
TASKGET_COUNT=$(grep -o '"name":"TaskGet"' "$FILE" | wc -l)
TASKLIST_ONLY_COUNT=$(grep -o '"name":"TaskList"' "$FILE" | wc -l)
```

**TaskList Tool Detection (Priority):**
- `TaskCreate` - Creates new tasks
- `TaskUpdate` - Updates task status
- `TaskGet` - Retrieves task details
- `TaskList` - Lists task summaries

### Expected Tool Counts by Test Type

| Test Type | Expected Skill Calls | Verification Pattern |
|-----------|---------------------|---------------------|
| Single skill | 1 | 1 tool_use → 1 success |
| Chain (A→B→C) | 3 | 3 sequential tool_uses |
| Forked worker | 1 | 1 tool_use with "forked" status |
| Orchestrator pattern | N | Orchestrator + N workers |
| Nested forks | N | Each fork level = 1 tool_use |
