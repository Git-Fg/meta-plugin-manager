# Test Execution Guide

Guide for executing and managing tests using the runner script.

## Before Executing Tests

⚠️ **CRITICAL**: Verify test structure is correct:

```bash
# Check structure
tree tests/<your_test>/

# Verify skills exist (if any)
ls tests/<your_test>/.claude/skills/*/SKILL.md

# Verify subagents exist (if any)
ls tests/<your_test>/.claude/agents/*.md

# Verify commands exist (if any)
ls tests/<your_test>/.claude/commands/*.md
```

**If structure is wrong**: See `test-creation.md` for proper structure.

## Test Execution

**Execute** tests using the runner script. Decide:
- Order of execution (sequential, parallel, targeted)
- Which tests to run (all, changed, failed, specific phase)
- When to stop (on failure, after N tests, completion)

### Single Test Execution

```bash
python3 scripts/runner.py execute tests/my_test "Execute the test workflow" --max-turns 15
```

### Batch Execution

Use Glob to find tests, then iterate:

```bash
# Find existing logs
Glob: "tests/*/raw_log.json"

# Find skill tests
Glob: "tests/*/.claude/skills/*/SKILL.md"

# Find all tests
Glob: "tests/*/.claude/"
```

## Prompt Strategy for Test Execution

### Single-Skill Tests

**Prompt template**: `"[Action verb] the [test-name] autonomous workflow"`

**Examples**:
- `"Execute the file-system-access autonomous workflow"`
- `"Demonstrate the context-isolation test pattern"`
- `"Perform the autonomous-skill test and report results"`

### Multi-Skill Orchestration Tests

**Warning**: Multi-skill chains require interactive mode OR different design.

**Option A**: Single orchestrator skill with forked workers
- Create orchestrator skill that calls workers via `context: fork`
- Use imperative prompts: `"Execute the orchestrator workflow"`

**Option B**: Separate test executions
- Run each skill test independently
- Aggregate results manually

**Do NOT**: Create skills that just describe calling other skills - they won't execute autonomously.

## Runner Commands

### Execute Test

Run a fresh test execution:
```bash
python3 scripts/runner.py execute <sandbox_path> "<prompt>" --max-turns 15
```

### Analyze Log

Analyze existing test log (offline):
```bash
python3 scripts/runner.py summarize <path_to_raw_log.json>
```

### Output Format

Both commands output JSON telemetry:
```json
{
  "status": "ANALYZED" | "EXECUTED",
  "telemetry": {
    "available_tools": [...],
    "available_skills": [...],
    "available_agents": [...],
    "mcp_servers": [...],
    "tool_counts": {"Skill": 3, "Bash": 1},
    "tool_usage_sequence": ["Skill", "Bash"],
    "permission_denials": 0,
    "duration_ms": 12345,
    "num_turns": 5,
    "is_error": false
  }
}
```

## What to Verify

| Component | Verify Using |
|-----------|-------------|
| **Skills** | `tool_counts`, `permission_denials`, completion markers |
| **Subagents** | Delegation success, `available_agents`, isolation |
| **Commands** | Trigger behavior, `$ARGUMENTS`, side effects |
| **Hooks** | Side effects, timing, event matching |
| **MCP** | `mcp_servers`, MCP tool availability |
| **Integration** | Multi-component workflows, context transitions |
