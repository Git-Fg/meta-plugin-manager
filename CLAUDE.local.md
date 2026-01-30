# Personal Project Rules: Permissions and Security

**Note**: These rules apply specifically to this personal project environment and are not intended as general-purpose security guidelines for professional or team settings.

## Context: Personal Project Environment

This is a **personal development project**, not a professional or enterprise deployment. While permission fields like `allowed-tools` and `disable-model-invocation` are critical for security in multi-user or production environments, in this personal context they serve a different purpose: **improving tool behavior and performance**.

## When to Use Permission Constraints

Use permission settings **reactively**, not proactively. The default should be maximum freedom—only add constraints when specific issues arise.

### Reactive-First Principle

**Don't add permission constraints "just in case."** Only add them when:
1. A specific misbehavior has been observed
2. The constraint directly solves the identified problem
3. The alternative (no constraint) causes repeated failures

## Practical Use Cases

### For Agents: Solving Misbehavior

When an agent repeatedly calls inappropriate tools or ignores its intended scope, constrain its permissions:

```yaml
# agent/.claude/frontmatter
allowed-tools:
  - Read
  - Write
  - Bash
  # Exclude Task to prevent unwanted subagent spawning
```

**Use when**: Agent spawns unnecessary subagents or calls tools outside its domain.

### For Skills/Commands: Performance Improvement

Permission constraints can guide skills toward correct tool usage patterns.

**Example: Teaching a skill to invoke other skills**

A skill might fail to understand it should use the `Skill` tool to invoke another command/skill. Instead, it might attempt to spawn subagents via `Task` or use other inappropriate methods.

**Solution**: Constrain permissions to guide behavior:

```yaml
# .claude/skills/my-skill/SKILL.md
---
allowed-tools:
  - Skill(subskill-name)
  - Read
  - Write
---
```

**Why this works**:
- Restricts the skill to specific tools
- Prevents random subagent spawning
- Forces use of the `Skill` tool for delegation
- Reduces cognitive overhead (fewer options to consider)

**When to apply**:
- ✅ After observing the skill repeatedly calling wrong tools
- ✅ When a skill delegates to subagents instead of using Skill tool
- ❌ NOT as a default pattern
- ❌ NOT before observing issues

## Key Guidelines

1. **No proactive complexity**: Default to maximum permissions. Add constraints only when needed.
2. **Solve observed problems**: Each constraint should address a specific, repeated issue.
3. **Performance over security**: In this personal context, permissions guide behavior, not enforce security boundaries.
4. **Document the reason**: When adding constraints, explain what problem they solve.

## Anti-Patterns to Avoid

**❌ Don't** add permission constraints as a default pattern
**❌ Don't** constrain permissions "for safety" in a personal project
**❌ Don't** add permissions that haven't been tested against a real problem
**❌ Don't** copy permission constraints from other contexts without understanding the reason

**✅ Do** start with no constraints
**✅ Do** add constraints only after observing specific issues
**✅ Do** use constraints to teach correct tool usage patterns
**✅ Do** remove constraints if they no longer serve a purpose
