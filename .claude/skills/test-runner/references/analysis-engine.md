# Built-in Analysis Engine

Internalizes analyze_tools.sh logic for complete autonomy - no external script dependencies.

## Core Analysis Functions

### 1. Parse NDJSON Output

**Purpose**: Extract and validate 3-line NDJSON structure

**Process**:
```bash
Read test-output.json into $FILE_CONTENT

# Split into lines
Split $FILE_CONTENT by newline → $LINES array

# Validate structure
If length($LINES) != 3:
  Output: ## NDJSON_ERROR
  Error: Expected 3 lines, got ${length($LINES)}
  Return

# Parse Line 1: System Init
Parse $LINES[0] as JSON → $SYSTEM_INIT
Extract: tools, skills, agents, mcp_servers

# Parse Line 2: Assistant Message
Parse $LINES[1] as JSON → $ASSISTANT_MSG
Extract: content array with text output

# Parse Line 3: Result
Parse $LINES[2] as JSON → $RESULT
Extract: num_turns, duration_ms, permission_denials

Output: ## NDJSON_PARSED with parsed structure
```

**Line Structure**:

**Line 1: System Init**
```json
{
  "type": "system",
  "subtype": "init",
  "tools": ["Read", "Edit", "Write", ...],
  "skills": ["skill-name", ...],
  "agents": ["agent-name", ...],
  "mcp_servers": [...]
}
```

**Line 2: Assistant Message**
```json
{
  "type": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Skill execution output with completion markers"
    }
  ]
}
```

**Line 3: Result**
```json
{
  "type": "result",
  "result": {
    "num_turns": 10,
    "duration_ms": 5000,
    "permission_denials": []
  }
}
```

### 2. Calculate Autonomy Score

**Purpose**: Determine autonomy based on permission_denials

**Process**:
```bash
# Extract permission denials
$DENIALS = $RESULT.permission_denials

# Count AskUserQuestion denials
$QUESTION_COUNT = 0
For each denial in $DENIALS:
  If denial.tool_name == "AskUserQuestion":
    $QUESTION_COUNT++

# Calculate autonomy score
If $QUESTION_COUNT == 0:
  $AUTONOMY_SCORE = 100
  $GRADE = "Excellence"
  $STATUS = "A+"
Else If $QUESTION_COUNT <= 3:
  $AUTONOMY_SCORE = 90 - ($QUESTION_COUNT * 2)
  $GRADE = "Good"
  $STATUS = "B"
Else If $QUESTION_COUNT <= 5:
  $AUTONOMY_SCORE = 75 - (($QUESTION_COUNT - 3) * 5)
  $GRADE = "Acceptable"
  $STATUS = "C"
Else:
  $AUTONOMY_SCORE = 70 - ($QUESTION_COUNT * 5)
  $GRADE = "Fail"
  $STATUS = "FAIL"

Output: ## AUTONOMY_CALCULATED
Score: ${AUTONOMY_SCORE}%
Grade: ${GRADE}
Status: ${STATUS}
Questions: ${QUESTION_COUNT}
```

**Scoring Table**:
| Permission Denials | Score | Grade | Status |
|-------------------|-------|-------|--------|
| 0 | 100% | Excellence | A+ |
| 1 | 95% | Excellence | A+ |
| 2-3 | 85-90% | Good | B |
| 4-5 | 75-80% | Acceptable | C |
| 6+ | <75% | Fail | FAIL |

### 3. Detect Execution Patterns

**Purpose**: Identify skill interaction patterns

**Process**:
```bash
# Extract tool uses
$TOOL_USES = extractToolUses($FILE_CONTENT)

# Pattern detection
$PATTERNS = []

# Check for regular → regular chain
If hasSequentialSkillCalls($TOOL_USES):
  $PATTERNS.push("Regular Chain")

# Check for forked execution
If hasForkedSkills($TOOL_USES):
  $PATTERNS.push("Forked Execution")

# Check for TaskList usage
If hasTaskListTools($TOOL_USES):
  $PATTERNS.push("TaskList Workflow")

# Check for subagent usage
If hasSubagentUsage($TOOL_USES):
  $PATTERNS.push("Subagent Pattern")

# Classify primary pattern
$PRIMARY_PATTERN = determinePrimaryPattern($PATTERNS)

Output: ## PATTERNS_DETECTED
Patterns: ${PATTERNS}
Primary: ${PRIMARY_PATTERN}
```

**Pattern Detection Logic**:

**Regular Chain**:
```bash
If count("name\":\"Skill\"") >= 2:
  AND NOT hasContextFork($TOOL_USES):
  → Regular → Regular chain
```

**Forked Execution**:
```bash
If any tool_use has:
  "name": "Skill"
  "input": {"context": "fork"}
  → Forked execution detected
```

**TaskList Workflow**:
```bash
If any tool_use has:
  "name": "TaskCreate" OR
  "name": "TaskUpdate" OR
  "name": "TaskGet" OR
  "name": "TaskList"
  → TaskList workflow detected
```

**Subagent Pattern**:
```bash
If any tool_use has:
  "name": "Task"
  "input": {"subagent_type": ...}
  → Subagent pattern detected
```

### 4. Verify Completion Markers

**Purpose**: Check for expected completion markers

**Process**:
```bash
# Extract expected markers from test setup
$EXPECTED_MARKERS = $TEST_VALIDATION.expected_markers

# Extract actual markers from assistant message
$ACTUAL_OUTPUT = $ASSISTANT_MSG.content[0].text
$ACTUAL_MARKERS = extractMarkers($ACTUAL_OUTPUT)

# Verify each expected marker
$VERIFICATION_RESULTS = []
For each marker in $EXPECTED_MARKERS:
  If marker in $ACTUAL_MARKERS:
    $VERIFICATION_RESULTS.push({
      "marker": marker,
      "found": true
    })
  Else:
    $VERIFICATION_RESULTS.push({
      "marker": marker,
      "found": false
    })

# Calculate completion rate
$FOUND_COUNT = count where found == true
$COMPLETION_RATE = ($FOUND_COUNT / length($EXPECTED_MARKERS)) * 100

Output: ## COMPLETION_VERIFIED
Completion Rate: ${COMPLETION_RATE}%
Expected: ${length($EXPECTED_MARKERS)}
Found: ${FOUND_COUNT}
Missing: ${length($EXPECTED_MARKERS) - $FOUND_COUNT}
```

**Marker Pattern**:
- Format: `## SKILL_NAME_COMPLETE`
- Case: Exact match
- Position: Can appear anywhere in output

### 5. Hallucination Detection

**Purpose**: Detect fake vs real execution

**Process**:
```bash
# Check for synthetic markers
If "isSynthetic": true in $FILE_CONTENT:
  # This is internal workflow, not a failure
  $IS_HALLUCINATION = false
  $STATUS = "Internal Workflow"
  Output: ## SYNTHETIC_DETECTED (OK)
  Return

# Check for real skill tool uses
$SKILL_TOOL_COUNT = count("name\":\"Skill\"")
If $SKILL_TOOL_COUNT == 0:
  $IS_HALLUCINATION = true
  $REASON = "No skill tool invocations found"
  Output: ## HALLUCINATION_DETECTED
  Return

# Check for manual SKILL.md reading
If "Bash" in $TOOL_USES:
  AND "cat" in $TOOL_USES command:
  AND ".claude/skills/" in command:
  → Manual file reading (hallucination)

# Check for tool use without result
For each tool_use in $TOOL_USES:
  $TOOL_ID = tool_use.id
  If NOT hasMatchingResult($TOOL_ID, $FILE_CONTENT):
    $IS_HALLUCINATION = true
    $REASON = "Tool use without matching result: ${TOOL_ID}"
    Output: ## HALLUCINATION_DETECTED
    Return

# Check for text-only execution
If $SKILL_TOOL_COUNT > 0:
  AND hasMatchingResults($SKILL_TOOL_COUNT):
  $IS_HALLUCINATION = false

Output: ## HALLUCINATION_CHECKED
Status: ${$IS_HALLUCINATION ? "PASS" : "FAIL"}
```

**Hallucination Indicators**:
- ❌ No `{"name":"Skill"}` tool uses
- ❌ Tool uses without matching results
- ❌ Manual `Bash cat` of SKILL.md files
- ❌ Text-only "skill execution" claims
- ✅ `isSynthetic: true` (internal workflow)
- ✅ Real tool invocations with results
- ✅ Proper completion markers

### 6. Tool Usage Analysis

**Purpose**: Count and categorize tool invocations

**Process**:
```bash
# Count by tool type
$TOOL_COUNTS = {
  "Skill": count("name\":\"Skill\""),
  "Task": count("name\":\"Task\""),
  "TaskCreate": count("name\":\"TaskCreate\""),
  "TaskUpdate": count("name\":\"TaskUpdate\""),
  "TaskGet": count("name\":\"TaskGet\""),
  "TaskList": count("name\":\"TaskList\""),
  "Read": count("name\":\"Read\""),
  "Edit": count("name\":\"Edit\""),
  "Write": count("name\":\"Write\""),
  "Bash": count("name\":\"Bash\"")
}

# Detect TaskList usage
$TASKLIST_USED = false
If $TOOL_COUNTS.TaskCreate > 0 OR
   $TOOL_COUNTS.TaskUpdate > 0 OR
   $TOOL_COUNTS.TaskGet > 0 OR
   $TOOL_COUNTS.TaskList > 0:
  $TASKLIST_USED = true

# Detect forked skills
$FORKED_SKILLS = count("context\":\"fork\"")

Output: ## TOOL_ANALYSIS_COMPLETE
Total Tools: ${sum($TOOL_COUNTS)}
Skill Calls: ${$TOOL_COUNTS.Skill}
TaskList Used: ${$TASKLIST_USED}
Forked Skills: ${$FORKED_SKILLS}
```

### 7. Determine Pass/Fail Verdict

**Purpose**: Final verdict based on all analysis

**Process**:
```bash
$VERDICT = "PASS"
$REASONS = []

# Check autonomy threshold
$MIN_AUTONOMY = $TEST_VALIDATION.autonomy_threshold
If $AUTONOMY_SCORE < $MIN_AUTONOMY:
  $VERDICT = "FAIL"
  $REASONS.push("Autonomy score ${AUTONOMY_SCORE}% below threshold ${MIN_AUTONOMY}%")

# Check completion markers
If $TEST_VALIDATION.must_have_marker:
  If $COMPLETION_RATE < 100:
    $VERDICT = "FAIL"
    $REASONS.push("Missing completion markers (${COMPLETION_RATE}%)")

# Check for hallucination
If $IS_HALLUCINATION:
  $VERDICT = "FAIL"
  $REASONS.push("Hallucination detected: ${$REASON}")

# Check for unexpected errors
If hasErrors($FILE_CONTENT):
  $VERDICT = "FAIL"
  $REASONS.push("Errors detected in execution")

# Compile verdict
$FINAL_RESULT = {
  "verdict": $VERDICT,
  "autonomy_score": $AUTONOMY_SCORE,
  "completion_rate": $COMPLETION_RATE,
  "patterns": $PATTERNS,
  "reasons": $REASONS,
  "tool_counts": $TOOL_COUNTS,
  "duration_ms": $RESULT.duration_ms,
  "num_turns": $RESULT.num_turns
}

Output: ## VERDICT_DETERMINED
Verdict: ${$VERDICT}
Score: ${$AUTONOMY_SCORE}%
Markers: ${$COMPLETION_RATE}%
Reasons: ${$REASONS}
```

## Batch Analysis

### Process Multiple Files

**Purpose**: Analyze entire directory of JSON files

**Process**:
```bash
# Discover all JSON files
$FILES = find($DIRECTORY, "*.json")

# Initialize counters
$TOTAL = 0
$PASSED = 0
$FAILED = 0
$AUTONOMY_SUM = 0
$RESULTS = []

# Analyze each file
For each file in $FILES:
  $ANALYSIS = runFullAnalysis(file)
  $TOTAL++

  If $ANALYSIS.verdict == "PASS":
    $PASSED++
  Else:
    $FAILED++

  $AUTONOMY_SUM += $ANALYSIS.autonomy_score
  $RESULTS.push($ANALYSIS)

# Calculate aggregate metrics
$AVG_AUTONOMY = $AUTONOMY_SUM / $TOTAL
$SUCCESS_RATE = ($PASSED / $TOTAL) * 100

# Generate summary report
$SUMMARY = {
  "total_tests": $TOTAL,
  "passed": $PASSED,
  "failed": $FAILED,
  "success_rate": $SUCCESS_RATE,
  "average_autonomy": $AVG_AUTONOMY,
  "results": $RESULTS
}

Output: ## BATCH_ANALYSIS_COMPLETE
Total: ${$TOTAL}
Passed: ${$PASSED}
Failed: ${$FAILED}
Success Rate: ${$SUCCESS_RATE}%
Avg Autonomy: ${$AVG_AUTONOMY}%
```

## Integration with JSON Management

Analysis engine provides results that JSON management uses:

```bash
# Analysis produces:
$AUTONOMY_SCORE = 95
$VERDICT = "PASS"
$FINDINGS = ["Forked skill executed autonomously", "No questions asked"]
$COMPLETION_MARKERS = ["## FORKED_SKILL_COMPLETE"]

# JSON management consumes:
Update test.status = "COMPLETED"
Add results with analysis data
Update test_summary metrics
Write to skill_test_plan.json
```

This creates the complete autonomous loop:
**discover → execute → analyze → update**

## Usage Examples

### Single File Analysis

```bash
# Analyze test output
test-runner "Analyze" tests/test_1_1/test-output.json

Output:
## ANALYSIS_COMPLETE
Test: test_1_1
Autonomy: 95% (Excellent)
Completion: 100%
Verdict: PASS
Patterns: Regular Chain
Duration: 7736ms
```

### Batch Analysis

```bash
# Analyze phase
test-runner "Analyze" tests/raw_logs/phase_2/

Output:
## BATCH_ANALYSIS_COMPLETE
Total: 5
Passed: 4
Failed: 1
Success Rate: 80%
Avg Autonomy: 88%

Details:
  test_2.1: PASS (95%)
  test_2.2: PASS (90%)
  test_2.3: PASS (100%)
  test_2.4: FAIL (Hallucination)
  test_2.5: PASS (85%)
```

### Autonomous Execution

```bash
# Full workflow
test-runner "Execute next test"

Output:
## AUTONOMOUS_COMPLETE
Test: test_2.3
Status: COMPLETED
Autonomy: 100% (Excellent)
Verdict: PASS
Patterns: Forked Execution
Findings: Forked skills are 100% autonomous
Next: test_2.4 (NOT_STARTED)
Progress: 35% complete (24/67)
```

## Error Handling

### NDJSON Errors

```bash
If lines != 3:
  Output: ## ANALYSIS_ERROR
  Error: Invalid NDJSON structure
  Expected: 3 lines
  Got: ${line_count}
  Action: Check test execution
```

### Parse Errors

```bash
If JSON.parse fails:
  Output: ## ANALYSIS_ERROR
  Error: Cannot parse JSON
  File: ${file_path}
  Action: Check file format
```

### Missing Expected Markers

```bash
If required markers missing:
  Output: ## COMPLETION_WARNING
  Warning: Missing expected markers
  Required: ${expected_markers}
  Found: ${found_markers}
  Action: Review test setup
```

## Migration from External Script

### Before (analyze_tools.sh)

```bash
# External bash script
bash .claude/skills/test-runner/scripts/analyze_tools.sh test-output.json

# Issues:
# - External dependency
# - Bash-specific
# - No JSON integration
# - Manual workflow
```

### After (Built-in Analysis)

```bash
# Internal function
test-runner "Analyze" test-output.json

# Benefits:
# - Zero dependencies
# - JSON-native
# - Automatic integration
# - Full autonomy
```

## Best Practices

### For Analysis

✅ **DO**: Always verify NDJSON structure (3 lines)
✅ **DO**: Check autonomy scores (aim for ≥85%)
✅ **DO**: Validate completion markers
✅ **DO**: Detect hallucinations

❌ **DON'T**: Trust text-only execution claims
❌ **DON'T**: Ignore permission_denials
❌ **DON'T**: Skip completion marker verification

### For Autonomy

✅ **DO**: Ensure 0-1 permission denials
✅ **DO**: Provide decision criteria in skills
✅ **DO**: Use default behaviors
✅ **DO**: Make choices based on context

❌ **DON'T**: Include question words
❌ **DON'T**: Leave decisions to user
❌ **DON'T**: Ask for clarification

### For Pattern Detection

✅ **DO**: Identify correct execution patterns
✅ **DO**: Document findings
✅ **DO**: Track pattern usage
✅ **DO**: Verify expected vs actual

❌ **DON'T**: Misclassify patterns
❌ **DON'T**: Ignore TaskList usage
❌ **DON'T**: Skip subagent detection
