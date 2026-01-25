---
name: test-manager
description: "Verification and testing for .claude development. Use when: testing skills, subagents, commands, hooks, MCP integration, or managing test suites."
---

# Test Manager

Testing specialist for `.claude/` development. Create, execute, analyze, and manage tests autonomously.

## ⚠️ CRITICAL: Test Skill Structure

**Recognition**: "Can the test runner find my components?"

### Directory Structure

**Production directory** (skills not found):
```
/path/to/project/.claude/skills/
```

**Test directory** (skills properly isolated):
```
/path/to/project/tests/<test_name>/
└── .claude/
    ├── skills/
    │   ├── skill1/SKILL.md
    │   └── skill2/SKILL.md
    ├── agents/
    │   ├── agent1.md
    │   └── agent2.md
    ├── commands/
    │   ├── command1.md
    │   └── command2.md
    ├── settings.json
    └── .mcp.json
```

**Key points:**
- Runner creates sandbox at `tests/<test_name>/`
- Skills must live in `<sandbox>/.claude/skills/`
- Root `.claude/skills/` is invisible to test runner

**Quick check**:
```bash
ls tests/<test_name>/.claude/skills/<skill>/
# Must show: SKILL.md
```

**Validation**: Check `available_skills` in telemetry after execution.

## Runner Tools

### Execute Test
```bash
python3 scripts/runner.py execute <sandbox_path> "<prompt>" --max-turns 15
```

### Analyze Log
```bash
python3 scripts/runner.py summarize <path_to_raw_log.json>
```

### Telemetry Output
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

| Component | Verify Using | Recognition |
|-----------|-------------|-------------|
| **Skills** | `tool_counts`, `permission_denials`, completion markers | "Did skills load and complete successfully?" |
| **Subagents** | Delegation success, `available_agents`, isolation | "Did delegation work?" |
| **Commands** | Trigger behavior, `$ARGUMENTS`, side effects | "Did commands execute?" |
| **Hooks** | Side effects, timing, event matching | "Did hooks fire?" |
| **MCP** | `mcp_servers`, MCP tool availability | "Are MCP servers connected?" |
| **Integration** | Multi-component workflows, context transitions | "Do components interact correctly?" |

## References

- **[test-creation.md](references/test-creation.md)**: Quick start, creation principles, common mistakes
- **[test-patterns.md](references/test-patterns.md)**: Autonomous patterns, degrees of freedom, examples
- **[test-execution.md](references/test-execution.md)**: Execution strategies, prompt patterns, batch testing

## TEST_MANAGER_COMPLETE
