# Test Creation Guide

Create effective tests for .claude development.

## Quick Start: Create Your First Test

### Directory Setup
```bash
mkdir -p tests/my_first_test/.claude/skills
mkdir -p tests/my_first_test/.claude/agents
mkdir -p tests/my_first_test/.claude/commands
```

### Component Files
```bash
touch tests/my_first_test/.claude/skills/my-test-skill/SKILL.md
touch tests/my_first_test/.claude/agents/my-agent.md
touch tests/my_first_test/.claude/commands/my-command.md
```

### Structure Validation
```bash
tree tests/my_first_test/
```

Expected output:
```
tests/my_first_test/
└── .claude/
    ├── skills/my-test-skill/SKILL.md
    ├── agents/my-agent.md
    └── commands/my-command.md
```

### Execute Test
```bash
python3 scripts/runner.py execute tests/my_first_test "Execute my test" --max-turns 15
```

### Verify Components Loaded
Check telemetry for:
```json
{
  "available_skills": ["my-test-skill"],
  "available_agents": ["my-agent"],
  "available_commands": ["my-command"]
}
```

**Recognition**: "Do my telemetry values match expected components?" → If no, check directory structure.

## Test Creation Principles

### Core Principle: Test Real Conditions

**Tests mirror actual production usage, not artificial scenarios.**

**Good test** (real condition):
```yaml
---
name: file-organizer
description: "Organize project files by type following conventions"
---

Organize a real project with mixed file types.

Execute autonomously:
1. Scan for all source files (*.js, *.ts, *.py, *.go)
2. Scan for test files (*.test.*, *.spec.*)
3. Scan for documentation (*.md, *.txt)
4. Report current organization state
```

**Bad test** (artificial condition):
```yaml
---
name: test-counter
description: "Test file counting"
---

Count the following specific files: file1.txt, file2.txt, file3.txt
```

**Why good**: Tests real-world file organization patterns.
**Why bad**: Tests contrived scenario, not real usage.

### Test Design Checklist

**Recognition questions:**

| Category | Recognition Question |
|----------|---------------------|
| **Real Conditions** | "Could this happen in production?" |
| **Realistic Data** | "Am I using 'test1.txt' or real filenames?" |
| **Autonomous Execution** | "Will this complete without user input?" |
| **Completion** | "Does this skill output a clear completion marker?" |
| **Appropriate Constraints** | "Does this specify WHAT or HOW?" |

### Sandbox Structure

```
tests/<test_name>/
├── .claude/
│   ├── skills/              # Multiple skills allowed
│   │   ├── skill1/SKILL.md
│   │   └── skill2/SKILL.md
│   ├── agents/              # Multiple agents allowed
│   │   ├── agent1.md
│   │   └── agent2.md
│   ├── commands/            # Multiple commands allowed
│   │   ├── command1.md
│   │   └── command2.md
│   ├── settings.json
│   └── .mcp.json
└── test_fixtures/           # Realistic test data
    ├── src/
    ├── tests/
    └── docs/
```

**Key points:**
- Mix and match components as needed
- All components in test folder are available
- Use multiple components for orchestration tests

### Component Strategy

**Single component** (isolation):
- One skill, agent, or command
- Basic validation
- Quick tests

**Multiple components** (orchestration):
- Skill calling subagents
- Command chains
- Hub-and-spoke patterns

**Use cases:**
- **TaskList**: orchestrator skill + worker skills
- **Multi-skill**: main skill + helper skills
- **Subagent composition**: analyzer + reviewer
- **Command automation**: deploy + rollback

### Compliance Verification

Before creating components, consult:
- Skills → `skill-development` (autonomy patterns)
- Agents → `agent-development` (agent patterns)
- Hooks → `hook-development` (event patterns)
- MCP → `mcp-development` (MCP standards)

**Apply autonomous design patterns** for reliable non-interactive execution.

## Common Mistakes

### Mistake 1: Wrong Directory

❌ **Wrong**:
```bash
mkdir -p .claude/skills/my-test-skill
mkdir -p .claude/agents/my-agent
```

✅ **Correct**:
```bash
mkdir -p tests/my_test/.claude/skills/my-test-skill
mkdir -p tests/my_test/.claude/agents/my-agent
mkdir -p tests/my_test/.claude/commands/my-command
```

**Why wrong**: Components in production directory are invisible to test runner.
**Why correct**: Test runner looks in `<test>/.claude/` only.

### Mistake 2: Skipping Validation

❌ **Wrong**: Execute test without structure check
✅ **Correct**: Verify with `tree` or `ls` before execution

**Why**: Fast feedback prevents wasted test runs.

### Mistake 3: Missing Output Structure

❌ **Wrong**: Skill without clear completion marker
✅ **Correct**: Always include structured output

**Why**: Tests need verifiable end states.

### Mistake 4: Wrong Prompt Format

❌ **Wrong**: "Use the my-test-skill skill"
✅ **Correct**: "Execute the my-test-skill autonomous workflow"

**Why**: Imperative prompts trigger autonomous execution.

### Mistake 5: Ignoring Telemetry

❌ **Wrong**: Assume test success
✅ **Correct**: Check `available_skills` and `permission_denials`

**Why**: Telemetry reveals component loading and permission issues.
