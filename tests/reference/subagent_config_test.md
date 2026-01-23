# Subagent Configuration Test Plan

## Test Matrix

### Test 1: Valid Subagent Fields
Verify all documented fields work correctly:

```yaml
---
name: test-agent-valid
description: "Does X when Y"
tools: [Read, Grep, Glob]
disallowedTools: [Write, Edit]
model: haiku
permissionMode: default
skills: [skills-knowledge]
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

### Test 2: Invalid Fields (Common Mistakes)
Verify these fields DON'T work for subagents:

```yaml
---
name: test-agent-invalid
# ❌ context: fork  - This is for skills, not subagents
# ❌ agent: Explore - This field doesn't exist for subagents
# ❌ user-invocable: true - Subagents aren't skills
---
```

### Test 3: Subagent Tool Restrictions
Verify tools and disallowedTools are enforced:

```yaml
---
name: restricted-agent
description: "Read-only agent"
tools: [Read, Grep]
disallowedTools: [Write, Edit, Bash]
model: haiku
---
```

### Test 4: Model Inheritance
Verify model: inherit vs specific model:

```yaml
---
name: inherit-model-agent
description: "Uses parent model"
model: inherit  # Should use caller's model
---
```

### Test 5: Skills Injection
Verify skills field loads skills into subagent context:

```yaml
---
name: skilled-agent
description: "Agent with access to skills-knowledge"
skills: [skills-knowledge, skills-architect]
---
```

## Comparison: Subagent vs Skill with agent: field

| Aspect | Subagent (.claude/agents/*.md) | Skill with agent: field |
|--------|-------------------------------|-------------------------|
| File location | `.claude/agents/name.md` | `.claude/skills/name/SKILL.md` |
| Can use `context: fork` | ❌ NO | ✅ YES |
| Can use `agent: Explore` | ❌ NO | ✅ YES |
| Can use `user-invocable` | ❌ NO | ✅ YES |
| Tool restrictions | ✅ Yes | ✅ Yes (via agent) |
| Model selection | ✅ Yes | ✅ Yes (via agent) |
| Skills injection | ✅ Yes | ❌ NO |
| Hooks | ✅ Yes | ❌ NO |
| Purpose | Isolation/parallelism | Agent capabilities |

## Execution Commands

```bash
# Phase 1: Setup
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_subagents/.claude/agents
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_subagents/.claude/skills/test-skill

# Phase 2: Create test files
# (Create each subagent variant)

# Phase 3: Test tool restrictions (cd only for working directory)
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_subagents && \
claude -p "Use restricted-agent to edit a file" \
  --output-format stream-json --dangerously-skip-permissions \
  --max-turns 5 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_subagents/test-tool-restriction.json 2>&1

# Phase 4: Verify fields
# Check NDJSON structure (3 lines)
[ "$(wc -l < /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_subagents/test-tool-restriction.json)" -eq 3 ] && \
  echo "✅ NDJSON structure OK"

# Check each invalid field is rejected
# Check each valid field is accepted
```

## Expected Results

### Valid Subagent
- ✅ Loads without errors
- ✅ Tools restricted to specified list
- ✅ disallowedTools blocked
- ✅ Model selection honored
- ✅ Skills loaded into context

### Invalid Subagent
- ⚠️ `context: fork` ignored or warned
- ⚠️ `agent: Explore` ignored or warned
- ⚠️ `user-invocable` ignored or warned

### Subagent vs Skill with agent:
- Subagent: Pure isolation with custom config
- Skill with agent: Agent capabilities + skill instructions
