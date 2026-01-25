---
name: test-manager
description: "Verification and testing for .claude development. Use when: testing skills, subagents, commands, hooks, MCP integration, or managing test suites."
---

# Test Manager

Testing specialist for `.claude/` development. Create, execute, analyze, and manage tests autonomously.

## ⚠️ CRITICAL: Test Skill Structure

**BEFORE CREATING ANY TEST SKILLS, READ THIS:**

### ❌ WRONG - Skills placed here:
```
/path/to/project/.claude/skills/          # Production skills directory
```

### ✅ CORRECT - Skills placed here:
```
/path/to/project/tests/<test_name>/
└── .claude/
    ├── skills/              # For skill tests (can have multiple)
    │   ├── skill1/
    │   │   └── SKILL.md
    │   └── skill2/
    │       └── SKILL.md
    ├── agents/              # For subagent tests (can have multiple)
    │   ├── agent1.md
    │   └── agent2.md
    ├── commands/            # For command tests (can have multiple)
    │   ├── command1.md
    │   └── command2.md
    ├── settings.json        # For configuration tests
    └── .mcp.json           # For MCP tests
```

### Why This Matters
- Test runner creates sandbox at `tests/<test_name>/`
- Runner looks for skills in `<sandbox>/.claude/skills/`
- Skills in root `.claude/skills/` won't be found
- **Always verify**: Check `available_skills` in telemetry

### Quick Validation
Before executing any test:
```bash
ls tests/<test_name>/.claude/skills/<skill>/
# Should show: SKILL.md
```

## Runner Tools

### Execute Test
```bash
python3 scripts/runner.py execute <sandbox_path> "<prompt>" --max-turns 15
```

### Analyze Log
```bash
python3 scripts/runner.py summarize <path_to_raw_log.json>
```

### Output Telemetry
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

## What to Test

| Component | Verify Using |
|-----------|-------------|
| **Skills** | `tool_counts`, `permission_denials`, completion markers |
| **Subagents** | Delegation success, `available_agents`, isolation |
| **Commands** | Trigger behavior, `$ARGUMENTS`, side effects |
| **Hooks** | Side effects, timing, event matching |
| **MCP** | `mcp_servers`, MCP tool availability |
| **Integration** | Multi-component workflows, context transitions |

## References

- **[test-creation.md](references/test-creation.md)**: Quick start guide, test creation principles, common mistakes
- **[test-patterns.md](references/test-patterns.md)**: Autonomous test patterns, degrees of freedom, examples
- **[test-execution.md](references/test-execution.md)**: Execution strategies, prompt patterns, batch testing

## Test Manager Complete

## TEST_MANAGER_COMPLETE
