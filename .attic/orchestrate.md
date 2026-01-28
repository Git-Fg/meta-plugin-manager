---
name: orchestrate
description: Native component development orchestration. Use when creating skills, commands, agents, or MCPs with staged validation: plan → design → execute → validate → stage.
---

# Orchestrate Command

<mission_control>
<objective>Execute end-to-end component development with semantic error detection through background watchdog monitoring and staged validation gates</objective>
<success_criteria>Component built with watchdog-monitored execution, validation passes (confidence >= 80), and artifacts staged for review</success_criteria>
</mission_control>

<trigger>When creating skills, commands, agents, or MCPs that require staged validation with semantic error detection</trigger>

<interaction_schema>
PLAN → DESIGN → EXECUTE (with watchdog) → VALIDATE → STAGE
</interaction_schema>

Native component development workflow with staged validation and quality gates.

## What This Command Does

Execute end-to-end component development with **semantic error detection**:

1. **Plan** - Generate architectural blueprint using skill-development
2. **Design** - Create test specification using tdd-workflow
3. **Execute** - Build component in sandbox with **background watchdog monitoring**
4. **Validate** - Quality gate combining watchdog analysis + meta-critic
5. **Stage** - Prepare artifacts for review with validation report

**Key Innovation**: Background watchdog agent detects semantic errors (hallucination, intent drift, logic failures) that exit codes miss. The orchestrator reads the watchdog report and manually decides next actions.

## How It Works

### Phase 1: Planning (Blueprint Generation)

Load `skill-development` and generate architectural blueprint:

```
**Blueprint Contents:**
- Component type (skill/command/agent/MCP)
- Core responsibilities and scope
- Triggering conditions
- Success criteria
- Risk assessment
```

Create `.claude/workspace/blueprint.yaml` with structured plan.

**Recognition**: "Does the blueprint define clear scope and acceptance criteria?"

### Phase 2: Test Design (Specification)

Load `tdd-workflow` and design test specification:

```
**Test Spec Contents:**
- Test cases (happy path, edge cases, errors)
- Coverage targets (80% minimum)
- Mock strategy for external deps
- Validation criteria
```

Create `.claude/workspace/test_spec.json` with structured tests.

**Recognition**: "Do tests cover actual usage, not just implementation?"

### Phase 3: Execution (Build in Sandbox with Watchdog)

MANDATORY READ BEFORE EXECUTION: The executor pattern requires a background watchdog agent for semantic error detection. This is NOT optional - semantic issues (hallucination, logic errors, intent drift) cannot be detected by simple exit codes.

#### Step 3.1: Sandbox Setup and Navigation

CRITICAL: Always navigate to sandbox and verify pwd before execution:

```bash
# Create sandbox directory
mkdir -p .claude/workspace/sandbox

# Navigate to sandbox
cd .claude/workspace/sandbox || exit 1

# Verify current directory (MANDATORY)
pwd
# Expected output: /path/to/project/.claude/workspace/sandbox

# Abort if not in sandbox
if [[ $(pwd) != *"sandbox"* ]]; then
  echo "ERROR: Not in sandbox directory. Current: $(pwd)"
  exit 1
fi
```

**Recognition**: "Is the pwd verified before ANY execution?"

#### Step 3.2: Launch Background Watchdog Agent

Create and launch a watchdog agent that monitors execution for semantic errors:

```bash
# Create watchdog script
cat > .claude/workspace/watchdog.sh << 'EOF'
#!/bin/bash
LOG_FILE=".claude/workspace/execution.log"
WATCHDOG_REPORT=".claude/workspace/watchdog_report.json"
CHECK_INTERVAL=30  # seconds

echo "{\"start_time\":\"$(date -Iseconds)\",\"status\":\"watching\"}" > "$WATCHDOG_REPORT"

while true; do
  sleep $CHECK_INTERVAL

  # Check for semantic error patterns
  SEMANTIC_ERRORS=0
  ISSUES="[]"

  # Pattern 1: Hallucination indicators
  if grep -qi "I don't have access\|I cannot see\|no such file\|not found" "$LOG_FILE" 2>/dev/null; then
    SEMANTIC_ERRORS=1
  fi

  # Pattern 2: Logic failures
  if grep -qi "test failed\|assertion.*failed\|expected.*actual" "$LOG_FILE" 2>/dev/null; then
    SEMANTIC_ERRORS=1
  fi

  # Pattern 3: Intent drift
  if grep -qi "I'll.*instead\|Let me try\|Actually.*better" "$LOG_FILE" 2>/dev/null; then
    SEMANTIC_ERRORS=1
  fi

  # Pattern 4: Tool failures
  if grep -qi "command not found\|permission denied\|error:" "$LOG_FILE" 2>/dev/null; then
    SEMANTIC_ERRORS=1
  fi

  # Update report if errors detected
  if [ $SEMANTIC_ERRORS -eq 1 ]; then
    cat > "$WATCHDOG_REPORT" << EOJ
<watchdog_report>
  <validation_timestamp>$(date -Iseconds)</validation_timestamp>
  <status>errors_detected</status>
  <semantic_errors>true</semantic_errors>
  <last_lines>$(tail -20 "$LOG_FILE" | sed 's/"/\\"/g')</last_lines>
  <patterns_found>
    $(grep -qi "I don't have access\|I cannot see" "$LOG_FILE" 2>/dev/null && echo '<pattern>context_access_issue</pattern>')
    $(grep -qi "test failed\|assertion.*failed" "$LOG_FILE" 2>/dev/null && echo '<pattern>test_failure</pattern>')
    $(grep -qi "I'll.*instead\|Let me try" "$LOG_FILE" 2>/dev/null && echo '<pattern>intent_drift</pattern>')
    $(grep -qi "command not found\|permission denied" "$LOG_FILE" 2>/dev/null && echo '<pattern>tool_failure</pattern>')
  </patterns_found>
</watchdog_report>
EOJ
    break
  fi

  # Check if main process completed
  if ! pgrep -f "claude.*orchestrate" > /dev/null 2>&1; then
    echo "{\"timestamp\":\"$(date -Iseconds)\",\"status\":\"completed\"}" > "$WATCHDOG_REPORT"
    break
  fi
done

echo "Watchdog terminated"
EOF

chmod +x .claude/workspace/watchdog.sh

# Launch watchdog in background
.claude/workspace/watchdog.sh &
WATCHDOG_PID=$!
echo "Watchdog launched (PID: $WATCHDOG_PID)"
```

**Recognition**: "Is the watchdog running BEFORE main execution starts?"

#### Step 3.3: Execute Component Build

With watchdog active, execute the build in sandbox:

```bash
# Verify we're still in sandbox (MANDATORY re-check)
pwd
if [[ $(pwd) != *"sandbox"* ]]; then
  echo "ERROR: Lost sandbox context. Aborting."
  kill $WATCHDOG_PID 2>/dev/null
  exit 1
fi

# Start execution log
exec > >(tee .claude/workspace/execution.log)
exec 2>&1

# Load blueprint and test spec
BLUEPRINT="../blueprint.yaml"
TEST_SPEC="../test_spec.json"

# Verify files exist
if [[ ! -f "$BLUEPRINT" ]]; then
  echo "ERROR: Blueprint not found at $BLUEPRINT"
  exit 1
fi

if [[ ! -f "$TEST_SPEC" ]]; then
  echo "ERROR: Test spec not found at $TEST_SPEC"
  exit 1
fi

# Execute TDD cycle following blueprint
echo "=== PHASE: RED (Write Failing Tests) ==="
# Load tdd-workflow skill and write tests

echo "=== PHASE: GREEN (Implement to Pass) ==="
# Implement code to make tests pass

echo "=== PHASE: REFACTOR (Clean Up) ==="
# Refactor while keeping tests green

echo "=== EXECUTION COMPLETE ==="
```

**Recognition**: "Is pwd verified before EVERY execution step?"

#### Step 3.4: Monitor Watchdog and Collect Report

After execution completes, collect watchdog report:

```bash
# Wait a moment for final watchdog check
sleep 5

# Kill watchdog
kill $WATCHDOG_PID 2>/dev/null
wait $WATCHDOG_PID 2>/dev/null

# Read watchdog report
if [[ -f ".claude/workspace/watchdog_report.json" ]]; then
  cat .claude/workspace/watchdog_report.json
else
  echo '{"status":"no_report"}'
fi

# Return to project root
cd ..
```

**MANDATORY**: The orchestrator MUST read the watchdog report manually and decide next steps based on semantic errors detected.

**Recognition**: "Did I read and understand the watchdog report before proceeding?"

### Phase 4: Validation (Watchdog + Quality Gate)

CRITICAL: Validation MUST begin by reading and understanding the watchdog report. Semantic errors detected by the watchdog are BLOCKING issues that must be addressed.

#### Step 4.1: Read Watchdog Report (MANDATORY)

```bash
# Read the watchdog report
cat .claude/workspace/watchdog_report.json

# Parse the JSON structure
# {
#   "timestamp": "2026-01-27T...",
#   "status": "errors_detected" | "completed" | "no_report",
#   "semantic_errors": true | false,
#   "last_lines": "...",
#   "patterns_found": ["intent_drift", "test_failure", ...]
# }
```

**MANDATORY ORCHESTRATOR DECISION**: Read the report and manually determine:

1. **What semantic errors occurred?**
   - Context access issues: Agent couldn't find files
   - Intent drift: Agent changed approach without consultation
   - Logic failures: Tests failed or assertions broken
   - Tool failures: Commands failed to execute

2. **Why did these errors occur?**
   - Blueprint unclear?
   - Missing file references?
   - Agent made autonomous decision?
   - Sandbox isolation issue?

3. **What must be done to fix?**
   - Return to planning (blueprint issue)?
   - Return to execution (implementation issue)?
   - Manual intervention required?
   - Abort and restart?

**Recognition**: "Have I understood the ROOT CAUSE of semantic errors before proceeding?"

#### Step 4.2: Load Meta-Critic for Standards Validation

AFTER understanding watchdog report, load `meta-critic` for standards validation:

```
**Validation Matrix:**
| Dimension | Source | Check |
|-----------|--------|-------|
| Intent | User request | Did we build what was asked? |
| Delivery | Built artifact | Does implementation match blueprint? |
| Standards | Meta-skill | Does it comply with best practices? |
| Semantics | Watchdog report | Were semantic errors detected? |
```

**Combining Watchdog + Meta-Critic**:

1. **Watchdog Report** = Semantic errors during execution
2. **Meta-Critic** = Standards compliance after completion

Both must pass for staging.

#### Step 4.3: Generate Validation Report

Generate comprehensive report including watchdog findings:

<thinking>
**Task Analysis:** Need standardized validation report format combining watchdog and meta-critic
**Constraints:** Must show both semantic and standards validation
**Approach:** Use XML container for watchdog findings as high-signal anchor
**Selected:** Combine XML watchdog report with JSON validation summary
</thinking>

**Watchdog Report (XML - High Signal Anchor):**

```xml
<watchdog_report>
  <validation_timestamp>2026-01-27T...</validation_timestamp>
  <component>
    <name>...</name>
    <type>skill/command/agent/MCP</type>
  </component>
  <watchdog_analysis>
    <status>errors_detected | clean</status>
    <semantic_errors>true | false</semantic_errors>
    <patterns_found>
      <pattern>intent_drift</pattern>
      <pattern>test_failure</pattern>
    </patterns_found>
    <root_cause>Agent changed approach without consulting user</root_cause>
    <severity>BLOCKING | HIGH | MEDIUM | LOW</severity>
  </watchdog_analysis>
  <standards_validation>
    <blueprint_compliance>PASS | FAIL</blueprint_compliance>
    <test_coverage>85%</test_coverage>
    <meta_skill_alignment>PASS | FAIL</meta_skill_alignment>
    <critical_issues>[]</critical_issues>
    <recommendations>[]</recommendations>
  </standards_validation>
  <confidence_score>75</confidence_score>
  <overall_status>NEEDS_FIXES | STAGED</overall_status>
</watchdog_report>
```

**Blocking Conditions** (ANY of these requires fix iteration):

- Confidence score < 80
- Semantic errors detected by watchdog
- Blueprint compliance FAIL
- Test coverage < 80%
- Critical issues in standards validation

**Recognition**: "Does the validation report include BOTH watchdog and meta-critic findings?"

### Phase 5: Staging (Prepare for Review)

If validation passes (confidence >= 80):

```
**Staging Structure:**
.claude/workspace/staged/
├── RUN_ID/
│   ├── artifacts/              # Built component
│   │   └── .claude/[type]/[name]/
│   ├── blueprint.yaml          # Architectural contract
│   ├── test_spec.json          # Test specification
│   ├── execution.log           # Build telemetry
│   ├── watchdog_report.json    # Semantic error analysis
│   ├── validation.json         # Quality gate results
│   └── REPORT.md               # Validation certificate
```

Create validation report with:

- Executive summary (component, type, result, confidence)
- Verification matrix (blueprint compliance, test results)
- Execution telemetry (steps taken, tools used)
- Gap analysis (what works, improvements needed)
- Recommendations (before production, future enhancements)

**Recognition**: "Is the report complete enough for user to make approve/reject decision?"

### Fix Iteration Loop (Watchdog-Guided)

When watchdog reports semantic errors OR validation fails:

#### Iteration Decision Tree

```
┌─────────────────────────────────────────────────────────┐
│  WATCHDOG REPORT ANALYSIS (Manual Read Required)        │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          │               │               │
    Semantic Errors    No Errors    Watchdog Failed
          │               │               │
          ▼               ▼               ▼
  Determine Root     Continue to    Check Process
     Cause Type      Meta-Critic     Restart/Abort
          │
    ┌─────┴─────┬─────────────┬─────────────┐
    │           │             │             │
Blueprint   Sandbox    Agent       Manual
Issue      Isolation   Behavior     Issue
    │           │             │             │
    ▼           ▼             ▼             ▼
Return to   Fix pwd     Adjust     Request
Phase 1   navigation   system      Guidance
    prompt                                      │
    │                                           │
    └───────────────────┬───────────────────────┘
                        ▼
                  Re-execute
                  Phase 3
```

#### Fix Iteration Steps

1. **Read Watchdog Report Manually**

   ```bash
   cat .claude/workspace/watchdog_report.json | jq .
   ```

   Identify patterns_found and root_cause

2. **Determine Fix Type**
   - **Blueprint Issue** → Return to Phase 1 (replan)
   - **Sandbox Issue** → Fix pwd/navigation, return to Phase 3
   - **Agent Behavior** → Adjust system prompt/instructions
   - **Manual Issue** → Request user guidance

3. **Apply Fix and Re-execute**

   ```bash
   # Clean previous attempt
   rm -rf .claude/workspace/sandbox/*
   rm .claude/workspace/watchdog_report.json
   rm .claude/workspace/execution.log

   # Re-run from appropriate phase
   ```

4. **Re-run Validation**
   - New watchdog report generated
   - Compare with previous report
   - Verify semantic errors resolved

**Stop conditions**:

- User requests abort
- Same semantic error persists after 3 fix attempts
- New critical semantic errors introduced
- Watchdog fails to start/monitor

**Recognition**: "Have I identified the ROOT CAUSE type before applying fixes?"

## Output Format

After completion, produce orchestration report:

```
ORCHESTRATION REPORT
====================

Component:        [name]
Type:             [skill/command/agent/MCP]
Status:           [STAGED/NEEDS_FIXES/ABORTED]
Confidence:       [0-100]

Watchdog Status:  [CLEAN/SEMANTIC_ERRORS/FAILED]
Patterns Found:   [intent_drift, test_failure, ...]
Root Cause:       [Agent changed approach without consultation]

Artifacts:        .claude/workspace/staged/[RUN_ID]/
Blueprint:        .claude/workspace/staged/[RUN_ID]/blueprint.yaml
Test Spec:        .claude/workspace/staged/[RUN_ID]/test_spec.json
Execution Log:    .claude/workspace/staged/[RUN_ID]/execution.log
Watchdog Report:  .claude/workspace/staged/[RUN_ID]/watchdog_report.json
Validation:       .claude/workspace/staged/[RUN_ID]/validation.json
Report:           .claude/workspace/staged/[RUN_ID]/REPORT.md

Next Steps:
1. Read watchdog report: cat .claude/workspace/staged/[RUN_ID]/watchdog_report.json
2. Review validation report: cat .claude/workspace/staged/[RUN_ID]/REPORT.md
3. If satisfied, approve: component/stage-release .claude/workspace/staged/[RUN_ID]
4. If unsatisfied, delete: rm -rf .claude/workspace/staged/[RUN_ID]
```

## Best Practices

### During Planning

- Define clear scope boundaries
- Set measurable success criteria
- Identify risks early
- Reference appropriate meta-skill

### During Execution (CRITICAL)

- **Always verify pwd** before ANY command execution
- **Always launch watchdog** BEFORE starting main execution
- **Always kill watchdog** AFTER execution completes
- **Always read watchdog report** BEFORE proceeding to validation
- Follow TDD cycle strictly (RED→GREEN→REFACTOR)
- Never skip test writing
- Achieve 80% coverage minimum
- Document deviations from blueprint

### During Validation

- **MANDATORY**: Read watchdog report first
- Understand ROOT CAUSE of semantic errors
- Be specific (file:line references, not abstract categories)
- Reference meta-skill standards
- Classify issues by severity
- Provide actionable recommendations

### During Staging

- Preserve ALL artifacts (blueprint, tests, logs, watchdog report, validation)
- Create clear navigation structure
- Include evidence links
- Make approve/reject decision obvious

### Watchdog Pattern Recognition

The watchdog detects SEMANTIC errors that exit codes miss:

| Error Type         | Pattern                | Example                                  |
| ------------------ | ---------------------- | ---------------------------------------- |
| **Context Access** | Agent can't find files | "I don't have access to", "no such file" |
| **Intent Drift**   | Agent changes approach | "I'll try instead", "Let me do this"     |
| **Logic Failure**  | Tests/assertions fail  | "test failed", "expected X but got Y"    |
| **Tool Failure**   | Commands fail          | "command not found", "permission denied" |

**Recognition**: "Did the watchdog catch something that would have been missed otherwise?" → This is why the watchdog exists.

## Integration with Native Tools

This command uses native Claude Code capabilities:

| Capability          | Used For                                             |
| ------------------- | ---------------------------------------------------- |
| `Skill` tool        | Loading skill-development, tdd-workflow, meta-critic |
| `TaskCreate`        | Tracking workflow state                              |
| `TaskUpdate`        | Progress updates                                     |
| `Bash`              | Sandbox creation, watchdog launch, execution         |
| `Read/Write`        | Artifact creation, watchdog report parsing           |
| `Bash (background)` | Watchdog monitoring (30-second intervals)            |

**Watchdog Pattern**: Background bash script monitors execution log for semantic error patterns. This is NOT a subagent - it's a native bash process with structured JSON output.

**No external orchestrator needed** - everything runs natively.

## Safety Features

- **Sandbox isolation**: Components built in `.claude/workspace/sandbox/`
- **Staging gate**: Validation required before staging
- **Manual approval**: User explicitly approves deployment
- **Full audit trail**: All artifacts preserved in staged directory
- **Rollback safety**: Delete staging directory if unsatisfied

## Related Commands

This command integrates with:

- `qa/verify` - Comprehensive quality gates
- `qa/code-review` - Security and quality review

## Arguments

First argument: Component type (optional)

```
/orchestrate                    # Interactive prompt for type
/orchestrate skill              # Direct to skill creation
/orchestrate command            # Direct to command creation
/orchestrate agent              # Direct to agent creation
/orchestrate mcp                # Direct to MCP creation
```

Remaining arguments: Additional context (component description, requirements, constraints)

**Example**:

```
/orchestrate skill "Analyze Docker logs for critical errors and send alerts"
```

## Recognition Questions

Before executing each phase, ask:

- **Plan**: "Does the blueprint define clear scope and acceptance criteria?"
- **Design**: "Do tests cover actual usage, not just implementation?"
- **Execute - Sandbox**: "Is the pwd verified before ANY execution?"
- **Execute - Watchdog**: "Is the watchdog running BEFORE main execution?"
- **Execute - Completion**: "Did I read the watchdog report?"
- **Validate**: "Have I understood the ROOT CAUSE of semantic errors?"
- **Stage**: "Is the report complete enough for user to make approve/reject decision?"

**Trust intelligence** - Use principles, not rigid prescriptions. Adapt based on context.

**CRITICAL**: The watchdog report is NOT optional. It is the PRIMARY signal for semantic errors. Meta-critic validates standards; watchdog validates execution semantics.

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Watchdog report MUST be read and understood before proceeding to validation
MANDATORY: pwd MUST be verified before ANY execution in sandbox
MANDATORY: Semantic errors detected by watchdog are BLOCKING issues
MANDATORY: Confidence score must be >= 80 for staging
MANDATORY: All artifacts must be preserved in staged directory

The watchdog report is a high-signal "Anchor Token" that indicates semantic errors during execution. Meta-critic validates standards compliance; watchdog validates execution semantics. BOTH must pass for staging.
</critical_constraint>
