# Test Execution Guide

Execute and manage tests using the runner script.

## Pre-Execution Validation

**Recognition**: "Will my test structure be found?"

Verify test structure is correct:
```bash
# Check structure
tree tests/<your_test>/

# Verify skills exist
ls tests/<your_test>/.claude/skills/*/SKILL.md

# Verify subagents exist
ls tests/<your_test>/.claude/agents/*.md

# Verify commands exist
ls tests/<your_test>/.claude/commands/*.md
```

**If structure is wrong**: Consult `test-creation.md` for proper structure.

## Test Execution

Execute tests using the runner script. Choose:
- Order (sequential, parallel, targeted)
- Scope (all, changed, failed, specific phase)
- Stop conditions (on failure, after N tests, completion)

### Single Test
```bash
python3 scripts/runner.py execute tests/my_test "Execute the test workflow" --max-turns 15
```

### Batch Execution

Use Glob to find tests:
```bash
# Find existing logs
Glob: "tests/*/raw_log.json"

# Find skill tests
Glob: "tests/*/.claude/skills/*/SKILL.md"

# Find all tests
Glob: "tests/*/.claude/"
```

## Prompt Strategy

### Single-Skill Tests

**Template**: `"[Action verb] the [test-name] autonomous workflow"`

**Examples**:
- "Execute the file-system-access autonomous workflow"
- "Demonstrate the context-isolation test pattern"
- "Perform the autonomous-skill test and report results"

**Recognition**: "Is this triggering autonomous execution?" → Use imperative voice.

### Multi-Skill Orchestration Tests

**Warning**: Multi-skill chains need interactive mode OR different design.

**Option A**: Orchestrator with forked workers
- Create orchestrator skill calling workers via `context: fork`
- Use: `"Execute the orchestrator workflow"`

**Option B**: Separate executions
- Run each skill test independently
- Aggregate results manually

**Recognition**: "Am I creating a skill that just describes calling others?" → This won't execute autonomously.

## Runner Commands

### Execute Test
Run fresh test execution:
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

## Verification Checklist

| Component | Verify Using | Recognition |
|-----------|-------------|-------------|
| **Skills** | `tool_counts`, `permission_denials`, completion markers | "Did skills load and complete successfully?" |
| **Subagents** | Delegation success, `available_agents`, isolation | "Did delegation work?" |
| **Commands** | Trigger behavior, `$ARGUMENTS`, side effects | "Did commands execute?" |
| **Hooks** | Side effects, timing, event matching | "Did hooks fire?" |
| **MCP** | `mcp_servers`, MCP tool availability | "Are MCP servers connected?" |
| **Integration** | Multi-component workflows, context transitions | "Do components interact correctly?" |
