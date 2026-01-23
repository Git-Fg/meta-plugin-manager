---
name: claude-cli-non-interactive
description: "Autonomous testing workflow for skills/plugins/subagents using Claude CLI print mode (-p) with stream-json output and real-time monitoring"
user-invocable: true
---

# CLI Non-Interactive Testing

## WIN CONDITION

```markdown
## CLI_TEST_COMPLETE

Workflow: [test-type]
Tests Run: [count]
Results: [summary]
Autonomy: [score]%
```

---

## 🚨 MANDATORY: Read References First

**Before ANY test**, read these in order:

1. **[references/cli-flags.md](references/cli-flags.md)** - All CLI flags, safety limits, output formats
2. **[references/patterns.md](references/patterns.md)** - Pre-configured test patterns
3. **[references/troubleshooting.md](references/troubleshooting.md)** - Real-time monitoring, failure diagnosis
4. **[references/autonomy-scoring.md](references/autonomy-scoring.md)** - 80-95% autonomy scoring
5. **[references/autonomy-patterns.md](references/autonomy-patterns.md)** - Autonomy testing patterns
6. **[references/hallucination-detection.md](references/hallucination-detection.md)** - Real vs synthetic execution

---

## 🚨 MANDATORY: Testing Rules

### Step-by-Step Approach (CRITICAL)
**✅ ALWAYS**: Create ONE new folder per test, execute individually
**❌ NEVER**: Create test runner scripts (run_*.sh, batch_*.sh, etc.)
**❌ NEVER**: Run multiple tests in monitoring loops
**✅ ALWAYS**: Read entire test-output.json before concluding pass/fail

ABSOLUTE CONSTRAINT: You must analyze ALL log files to verify test success. **MANDATORY WORKFLOW**:
1. **First**: Call the `tool-analyzer` skill to automate pattern detection
2. **Then**: Read the full log manually if the analyzer output is unclear
3. Watch for synthetic skill use (hallucinated) vs. real tool/task/skill use

### Path Navigation
**NEVER use `cd` to navigate** - it's unreliable and causes confusion about current directory.

**ONLY TWO EXCEPTIONS**:
1. **Setting claude's working directory** (in same command): `cd /path && claude ...`
2. **Cleanup after test complete**: `cd /original/path` (optional, using absolute paths preferred)

**ALWAYS use absolute paths**:
- `<project_path>/` = actual project path from `!pwd`
- All file operations use absolute paths: `cat <project_path>/test/file.json`
- Never rely on current directory state

**NEVER create test skills in /tmp/** - Always create test skills/agents DIRECTLY in the actual directory. Temporary directories cause confusion and cleanup issues.

**WRONG** ❌:
```bash
cd test-name
claude -p "test" > output.json 2>&1
cat output.json
```

**WRONG** ❌:
```bash
mkdir -p /tmp/test-skills/skill-name  # NEVER use /tmp/ for test skills
```

**CORRECT** ✅:
```bash
mkdir <project_path>/test-name
cd <project_path>/test-name && claude -p "test" > <project_path>/test-name/output.json 2>&1
cat <project_path>/test-name/output.json
```

---

## Core: Print Mode (-p) + stream-json

**Why**: Single-pass execution, no conversation loop, perfect for autonomous testing.

**Mandatory flags for EVERY test**:
```bash
--output-format stream-json --verbose --debug --no-session-persistence --dangerously-skip-permissions
```

**NDJSON output structure (3 lines)**:
- **Line 1**: System init (`tools`, `skills`, `agents`, `mcp_servers`)
- **Line 2**: Assistant message
- **Line 3**: Result (`num_turns`, `duration_ms`, `total_cost_usd`, `permission_denials`)

---

## Universal Testing Pattern

All tests use same structure. Only `--max-turns` and setup vary.

### Phase 1: Setup (Skills/Agents Creation)

**Create test skills/agents DIRECTLY in project structure**:

```bash
!pwd  # Get actual project path
# Create test folder structure
mkdir -p <project_path>/test_folder/.claude/skills/skill-test-name

# Create skill file
cat > <project_path>/test_folder/.claude/skills/skill-test-name/SKILL.md << 'EOF'
---
name: skill-test-name
description: "Test skill"
---

## TEST_SKILL_COMPLETE

Test completed successfully.
EOF

# If testing subagents, create agent file
mkdir -p <project_path>/test_folder/.claude/agents
cat > <project_path>/test_folder/.claude/agents/test-agent.md << 'EOF'
---
name: test-agent
description: "Test agent"
tools: [Read, Grep]
---
EOF
```

### Phase 2: Pre-flight Checklist

**CRITICAL**: Complete ALL checklist items BEFORE running test:

- [ ] Test folder created at `<project_path>/test_folder/`
- [ ] Test skills created in `<project_path>/test_folder/.claude/skills/`
- [ ] Test agents created in `<project_path>/test_folder/.claude/agents/` (if applicable)
- [ ] Skills/agents have correct YAML frontmatter
- [ ] Win condition markers defined in skills
- [ ] Test-output.json will be saved IN this test folder
- [ ] You will analyze the log using tool-analyzer skill (then read manually if needed)

**ONLY after checklist complete, proceed to Phase 3.**

### Phase 3: Execution (Run Test)

```bash
# Execute test (cd only used here to set claude's working directory)
# Output goes directly into test_folder
cd <project_path>/test_folder && claude --dangerously-skip-permissions -p "test prompt" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > <project_path>/test_folder/test-output.json 2>&1
```

### Phase 4: Verification & Cleanup

```bash
# MANDATORY: Read the FULL test-output.json before deciding pass/fail
cat <project_path>/test_folder/test-output.json

# Analyze the COMPLETE output:
# - Check ALL win condition markers
# - Verify permission_denials array
# - Look for errors or issues

# Archive successful test folder
mv <project_path>/test_folder <project_path>//.attic/test_folder_success

# Or delete after analysis
rm -rf <project_path>/test_folder
```

**CRITICAL**: Never skip the tool-analyzer analysis. Always analyze logs systematically:
1. **First**: Call tool-analyzer skill for automated pattern detection
2. **Then**: Read full log manually if analyzer output is unclear

### Max-Turns Guidelines

| Test Type | --max-turns |
|-----------|-------------|
| Single skill | 10 |
| Skill chain (2-3) | 20 |
| Forked skills | 15 |
| Parallel execution | 25 |
| Complex pipeline | 50+ |

---

## Per-Test Execution Pattern

For long-running tests, you may optionally monitor one test at a time:

### Phase 1: Setup

```bash
!pwd  # Get actual project path

# Create test folder structure
mkdir -p <project_path>/test_folder/.claude/skills/skill-test-name
cat > <project_path>/test_folder/.claude/skills/skill-test-name/SKILL.md << 'EOF'
---
name: skill-test-name
description: "Test skill"
---

## TEST_COMPLETE
EOF
```

### Phase 2: Pre-flight Checklist

- [ ] Test folder created at `<project_path>/test_folder/`
- [ ] Test skill created in `<project_path>/test_folder/.claude/skills/skill-test-name/`
- [ ] Win condition marker present
- [ ] Test output will go to `<project_path>/test_folder/test-output.json`

### Phase 3: Optional Per-Test Monitoring

```bash
# Run ONE test at a time with optional monitoring
cd <project_path>/test_folder && claude --dangerously-skip-permissions -p "test prompt" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > <project_path>/test_folder/test-output.json 2>&1 &

# Monitor this specific test (optional)
sleep 5
tail -f <project_path>/test_folder/test-output.json 2>/dev/null
```

### Phase 4: Log Analysis & Cleanup

**CRITICAL**: Analyze logs systematically:

```bash
# Step 1: Call tool-analyzer skill (MANDATORY FIRST STEP)
# The tool-analyzer will detect patterns, skill invocations, autonomy scores

# Step 2: Read full log manually if needed
cat <project_path>/test_folder/test-output.json

# Decide pass/fail based on:
# - tool-analyzer findings
# - Completion markers present
# - permission_denials array empty
# - No errors in output

# Archive successful tests
mv <project_path>/test_folder <project_path>/.attic/test_folder_success

# Or delete failed tests after analysis
rm -rf <project_path>/test_folder
```

**Next Test**: Create NEW folder for next test

---

## Quick Verification Checklist

After each test, **READ THE FULL** `test-output.json` (from inside the test folder):

**Step 1: Automated Analysis (MANDATORY)**
```bash
# Call tool-analyzer skill FIRST - it will analyze the log and report:
# - Execution patterns detected
# - Skill invocation counts
# - Autonomy scores
# - Completion markers found
# - Any anomalies or issues

# Review tool-analyzer output
```

**Step 2: Manual Verification (if needed)**
```bash
# If tool-analyzer output is unclear, read the full log manually
cat <project_path>/test_folder/test-output.json
```

**Step 2: Verify System Init (Line 1)**:
- [ ] Test skills in `"skills"` array
- [ ] Required MCP servers in `"mcp_servers"`
- [ ] Custom agents in `"agents"` (if applicable)

**Step 3: Verify Result (Last Lines)**:
- [ ] `"num_turns"` within expected range
- [ ] `"permission_denials"` is empty (no questions asked)
- [ ] `"duration_ms"` reasonable (not infinite loop)
- [ ] Completion marker present in `"result"`

**Step 4: Autonomy Score**:
- Count `"permission_denials"` entries
- 0-1 = Excellent (95%)
- 2-3 = Good (85%)
- 4-5 = Acceptable (80%)
- 6+ = Fail (<80%)

**CRITICAL**: If you did NOT read the full log, you cannot conclude pass/fail.

---

## Autonomy Testing Patterns

**CRITICAL**: Forked skills MUST complete without asking questions.

For complete autonomy testing patterns, verification, templates, and scoring:
**See [references/autonomy-patterns.md](references/autonomy-patterns.md)**

## Common Test Scenarios

For detailed patterns, see **[references/patterns.md](references/patterns.md)**:

| Scenario | --max-turns | Key Verification |
|----------|-------------|------------------|
| Skill discovery | 5 | Skills loaded in line 1 |
| Autonomy test | 8 | No permission_denials |
| Context fork | 15 | Isolation confirmed |
| Skill chain (A→B→C) | 20 | All markers present |
| Parallel workers | 25 | All results aggregated |

---

## Failure Diagnosis

For troubleshooting, see **[references/troubleshooting.md](references/troubleshooting.md)**:

| Symptom | NDJSON Indicator | Fix |
|---------|------------------|-----|
| Too many questions | `permission_denials` array >3 | Add decision criteria to skill |
| Missing markers | No `## MARKER` in result | Add WIN CONDITION to skill |
| Context leak | Forked skill accesses main vars | Add `context: fork` to frontmatter |
| Timeout | `stop_reason: "max_turns_reached"` | Increase max-turns or simplify |
| Skills not loading | Missing from line 1 skills array | Fix directory structure |
| Test hangs | (no output) | Missing `--dangerously-skip-permissions` |

---

## Hallucination Detection Framework

**ABSOLUTE CONSTRAINT**: Always verify real execution vs hallucination.

For complete verification framework, automated tool-analyzer usage, and expected patterns:
**See [references/hallucination-detection.md](references/hallucination-detection.md)**

---

## Key CLI Flags (Delta - Expert Only)

Full reference: **[references/cli-flags.md](references/cli-flags.md)**

| Flag | Purpose | Expert Tip |
|------|---------|------------|
| `--output-format stream-json` | NDJSON output (3 lines) | ALWAYS use with `--verbose` |
| `--no-session-persistence` | Don't save sessions | Prevents disk pollution |
| `--dangerously-skip-permissions` | Auto-approve prompts | Required for non-interactive |
| `--max-turns N` | Limit conversation rounds | Prevents infinite loops |
| `--debug` | Debug visibility | Essential for diagnosis |

---

*Use this skill for autonomous, isolated testing of Claude Code capabilities.*
