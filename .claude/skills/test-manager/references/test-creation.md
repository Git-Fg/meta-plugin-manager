# Test Creation Guide

Complete guide for creating effective tests for .claude development.

## Quick Start: Create Your First Test

### Step-by-Step Process

**Step 1: Create Test Directory**
```bash
mkdir -p tests/my_first_test/.claude/skills
mkdir -p tests/my_first_test/.claude/agents
mkdir -p tests/my_first_test/.claude/commands
```

**Step 2: Create Component Files**
```bash
# Create skill (optional, can have multiple)
touch tests/my_first_test/.claude/skills/my-test-skill/SKILL.md

# Create subagent (optional, can have multiple)
touch tests/my_first_test/.claude/agents/my-agent.md

# Create command (optional, can have multiple)
touch tests/my_first_test/.claude/commands/my-command.md
```

**Step 3: Verify Structure**
```bash
tree tests/my_first_test/
# Should show:
# tests/my_first_test/
# └── .claude/
#     ├── skills/
#     │   └── my-test-skill/
#     │       └── SKILL.md
#     ├── agents/
#     │   └── my-agent.md
#     └── commands/
#         └── my-command.md
```

**Step 4: Execute Test**
```bash
python3 scripts/runner.py execute tests/my_first_test "Execute my test" --max-turns 15
```

**Step 5: Verify Components Loaded**
Check telemetry for:
```json
{
  "available_skills": ["my-test-skill"],      // Skills found!
  "available_agents": ["my-agent"],           // Subagents found!
  "available_commands": ["my-command"]        // Commands found!
}
```

**If components are missing**: Check your directory structure

## Test Creation Principles

### Core Principle: Test Real Conditions

**Tests should mirror actual production usage**, not artificial scenarios.

**Good test** (represents real condition):
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

## ORGANIZER_COMPLETE
```

**Bad test** (artificial condition):
```yaml
---
name: test-counter
description: "Test file counting"
---

Count the following specific files: file1.txt, file2.txt, file3.txt
```
→ Tests contrived scenarios, not real usage

### Test Design Checklist

Before creating a test, verify:

**Representative of Real Conditions**:
- [ ] Tests actual workflow, not contrived scenario
- [ ] Uses realistic data/fixtures (not "test1", "test2")
- [ ] Mirrors production environment structure
- [ ] Exercises real tool capabilities

**Autonomous Execution**:
- [ ] Skill can complete without user intervention
- [ ] Clear completion marker present
- [ ] No decision points that require user input
- [ ] Self-contained (no external dependencies)

**Appropriate Constraints**:
- [ ] Specifies WHAT to achieve, not HOW
- [ ] Provides context/purpose, not step-by-step
- [ ] Allows Claude's intelligence to work
- [ ] Includes examples for style-dependent tasks

### Sandbox Structure

```
tests/<test_name>/
├── .claude/
│   ├── skills/              # For skill tests (can have multiple)
│   │   ├── skill1/
│   │   │   └── SKILL.md
│   │   └── skill2/
│   │       └── SKILL.md
│   ├── agents/              # For subagent tests (can have multiple)
│   │   ├── agent1.md
│   │   └── agent2.md
│   ├── commands/            # For command tests (can have multiple)
│   │   ├── command1.md
│   │   └── command2.md
│   ├── settings.json        # For configuration tests
│   └── .mcp.json           # For MCP tests
└── test_fixtures/           # Realistic test data (optional)
    ├── src/
    ├── tests/
    └── docs/
```

**Notes**:
- A test can have 0, 1, or multiple of each component type
- All components in a test folder are available during execution
- Use multiple components when testing orchestration, nested workflows, or interactions

### When to Use Multiple Components

**Single Component** (Simple Test):
- Testing one skill in isolation
- Testing basic subagent behavior
- Testing individual commands
- Quick validation tests

**Multiple Components** (Complex Test):
- Testing orchestrator calling workers
- Testing nested workflows (skill → subagent → skill)
- Testing skill-subagent interactions
- Testing command chains
- Testing hub-and-spoke patterns

**Example Use Cases**:
- **TaskList orchestration**: orchestrator skill + worker skills
- **Multi-skill workflows**: main skill + helper skills
- **Subagent composition**: analyzer agent + reviewer agent
- **Command automation**: deploy command + rollback command

### Compliance Verification

Before creating components, invoke knowledge skills:
- Testing/creating skills? → `knowledge-skills` (Agent Skills standard + autonomy patterns)
- Testing/creating subagents? → `knowledge-subagents` (agent patterns)
- Testing/creating hooks? → `knowledge-hooks` (event patterns)
- Testing/creating MCP? → `knowledge-mcp` (MCP standards)

**Always apply autonomous design patterns** from knowledge-skills for reliable non-interactive test execution.

## Common Mistakes to Avoid

### Mistake 1: Wrong Directory
❌ **DON'T**:
```bash
# Creating components in production directory
mkdir -p .claude/skills/my-test-skill
mkdir -p .claude/agents/my-agent
```

✅ **DO**:
```bash
# Creating components in test-specific directory
mkdir -p tests/my_test/.claude/skills/my-test-skill
mkdir -p tests/my_test/.claude/agents/my-agent
mkdir -p tests/my_test/.claude/commands/my-command
```

### Mistake 2: Forgetting to Validate
❌ **DON'T**: Run test without checking structure
✅ **DO**: Verify with `tree` or `ls` before execution

### Mistake 3: Missing Completion Marker
❌ **DON'T**: Create skill without `## SKILL_COMPLETE`
✅ **DO**: Always include completion marker

### Mistake 4: Wrong Prompt Format
❌ **DON'T**: "Use the my-test-skill skill"
✅ **DO**: "Execute the my-test-skill autonomous workflow"

### Mistake 5: Not Checking Telemetry
❌ **DON'T**: Assume test ran correctly
✅ **DO**: Check `available_skills` and `permission_denials`
