# Implementation Patterns

**Concrete patterns from official examples. Use these for skill creation.**

---

## Writing Style

### Imperative/Infinitive Form (Low Freedom)

Skill content uses strict imperative/infinitive form with NO second person.

**Use this pattern**: Content that requires specific, deterministic execution.

**Examples**:
- Execute before any tool runs
- Parse the YAML frontmatter using sed
- Configure the MCP server with authentication
- Validate file write safety

**Avoid**:
- You should create a hook
- You need to validate settings
- You can use the grep tool

**Recognition**: If writing "you/your", switch to imperative form.

---

## Description Pattern

### Third-Person with Exact Triggers

Descriptions use third-person format with specific trigger phrases users would say.

**Pattern**:
```yaml
description: This skill should be used when the user asks to "specific phrase 1",
"specific phrase 2", "specific phrase 3", or needs guidance on X, Y, Z.
```

**Example from agent-development**:
```yaml
description: This skill should be used when the user asks to "create an agent",
"add an agent", "write a subagent", "agent frontmatter", "when to use description",
"agent examples", "agent tools", "agent colors", "autonomous agent", or needs
guidance on agent structure, system prompts, triggering conditions...
```

**Key elements**:
- Third-person: "This skill should be used when..."
- Exact quotes: Phrases users actually say
- Variety: Multiple ways to phrase the same concept
- Context-specific: Include relevant technical terms

**Recognition**: If description is vague or generic, add exact trigger phrases.

---

## Skill Structure

### Tier Threshold: 400-450 Lines

Move content to `references/` at 400-450 lines, not 500.

**Reality from examples**:
- command-development: 833 lines (should have split earlier)
- hook-development: 711 lines
- skill-development: 636 lines
- agent-development: 414 lines

**Optimal pattern**: Split at 400-450 lines for better progressive disclosure.

### Directory Structure

```
skill-name/
├── SKILL.md              # 400-450 lines max (Tier 2)
├── examples/             # Working code examples (not snippets)
│   ├── working-example.md
│   └── templates/
├── scripts/              # Executable utilities
│   └── validate.sh
└── references/           # Domain-specific organization
    ├── patterns.md       # 8,000-12,000 words
    ├── advanced.md       # 10,000-15,000 words
    └── [domain].md       # Domain-specific deep dives
```

**Key patterns**:
- `examples/` directory with complete, runnable code
- `scripts/` directory with executable utilities
- Domain-specific `references/` organization

---

## Script Patterns

### Quick-Exit Pattern

Early exit when configuration not present reduces overhead.

```bash
# Check if configuration exists
if [[ ! -f ".claude/my-plugin.local.md" ]]; then
  exit 0  # Not configured, skip gracefully
fi
```

**Use when**: Optional functionality that may not be configured.

### Strict Error Handling

Use `set -euo pipefail` for deterministic operations.

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

**Use when**: Script must fail explicitly on errors (hooks, validation).

### Exit Code Conventions

For hooks and validation scripts:

- `0` = approve/success
- `1` = non-blocking error (continue)
- `2` = deny/blocking error

```bash
# Approve operation
echo '{"continue": true}'
exit 0

# Deny operation with reason
echo '{"permissionDecision": "deny"}' >&2
exit 2
```

### JSON Input via stdin

Standard hook input format with jq parsing.

```bash
#!/bin/bash
set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract fields with jq
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Validate required fields
if [ -z "$file_path" ]; then
  echo '{"continue": true}'
  exit 0
fi
```

**Use when**: Writing PreToolUse, PostToolUse, or other event hooks.

---

## Cross-Reference Patterns

### Skill Integration

Skills can reference other skills and use `${CLAUDE_PLUGIN_ROOT}` for portability.

```markdown
See [plugin-dev skills](../../../official_example_skills/) for complete examples.

Use `${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh` for portable script references.
```

### Knowledge-Factory Workflow

1. Load knowledge skills to understand concepts
2. Use factory skills to execute operations

**Example flow**:
```
User: "Create a new skill for X"
→ Load knowledge-skills (understand structure)
→ Load skill-development (learn patterns)
→ Use create-skill factory (execute creation)
```

---

## Recognition Questions

**Writing Style**:
- "Am I using 'you/your'?" → Switch to imperative form
- "Is this instructions or messages?" → Write FOR Claude, not TO user

**Description Quality**:
- "Are these exact user phrases?" → Add specific trigger quotes
- "Would this trigger on the right inputs?" → Test with real phrases

**Skill Structure**:
- "Is SKILL.md approaching 450 lines?" → Move content to references/
- "Do I have working examples?" → Add examples/ directory

**Script Quality**:
- "Does this fail gracefully?" → Add error handling
- "Is this portable?" → Use ${CLAUDE_PLUGIN_ROOT}

---

**Teaching > Prescribing**: Patterns enable intelligent adaptation. Process prescriptions create brittle systems.
