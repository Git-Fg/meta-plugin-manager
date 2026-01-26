---
name: test-manager
description: "Verification and testing for .claude development. Use when: testing skills, subagents, commands, hooks, MCP integration, or managing test suites."
---

# Test Manager

Think of test management as a **flight simulator for AI agents**—testing components in a controlled environment before they encounter real-world scenarios, ensuring they perform correctly and safely.

## Recognition Patterns

**When to use test-manager:**
```
✅ Good: "Test skills, subagents, commands"
✅ Good: "Verify MCP integration"
✅ Good: "Manage test suites"
✅ Good: "Validate component behavior"
❌ Bad: Simple unit tests for application code
❌ Bad: Manual testing workflows

Why good: Test manager specializes in .claude component verification.
```

**Pattern Match:**
- User mentions "test skills", "validate components", "MCP testing"
- Need to verify .claude development components
- Testing subagents, commands, hooks, or MCP integration

**Recognition:** "Do you need to test .claude components?" → Use test-manager.

## Critical: Test Skill Structure

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

**Quick check:**
```bash
ls tests/<test_name>/.claude/skills/<skill>/
# Must show: SKILL.md
```

**Contrast:**
```
✅ Good: Skills in tests/<test_name>/.claude/skills/
❌ Bad: Skills in project root .claude/skills/

Why good: Test runner creates isolated sandbox for component verification.
```

**Recognition:** "Are your components in the test directory structure?" → Must be in `tests/<test_name>/.claude/` to be found.

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

**Recognition:** "Which component type needs verification?" → Use appropriate telemetry and markers.

**Contrast:**
```
✅ Good: Verify skills using tool_counts and completion markers
✅ Good: Test MCP using mcp_servers telemetry
❌ Bad: Ignore telemetry output
❌ Bad: Skip validation of component loading

Why good: Telemetry provides objective verification of component behavior.
```

**For detailed testing patterns:**
- `references/test-creation.md` - Quick start and creation principles
- `references/test-patterns.md` - Autonomous patterns and examples
- `references/test-execution.md` - Execution strategies and batch testing

**Recognition:** "Do you need comprehensive testing guidance?" → See reference files for detailed patterns.
