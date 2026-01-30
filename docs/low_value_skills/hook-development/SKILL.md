---
name: hook-development
description: "Create, validate, and audit event-driven hooks for intercepting events, enforcing security patterns, and automating interventions. Use when building or reviewing hooks, implementing event handlers, or adding safety guardrails. Includes matcher patterns, action types, timeout configuration, and security enforcement. Not for manual actions, passive knowledge, or non-event-driven automation."
---

<mission_control>
<objective>Create event-driven hooks that intercept operations and enforce security patterns</objective>
<success_criteria>Generated hook has valid matcher, action type, and timeout configuration</success_criteria>
</mission_control>

<interaction_schema>
event_analysis → matcher_design → action_definition → security_review → output</interaction_schema>

# Hook Development

## Quick Start

**Create hook:** Follow matcher + action structure with timeout configuration

**Review hook:** See ## Security Patterns → Apply all checks

**Test matcher:** Verify with Bash examples in ## Implementation Patterns

**Why:** Hooks intercept operations at runtime—prevention is more valuable than post-hoc correction.

**If you're wondering why this skill is so detailed:** Hooks are security-critical—mistakes here expose systems to real harm.

## Navigation

| If you need...         | Read...                            |
| :--------------------- | :--------------------------------- |
| Create hook            | ## Implementation Patterns         |
| Review hook quality    | ## Security Patterns               |
| Test matcher           | ## Implementation Patterns         |
| Event matcher patterns | ## PATTERN: Event Matching         |
| Security anti-patterns | ## ANTI-PATTERN: Common Mistakes   |
| Advanced patterns      | `references/pattern_advanced.md`   |
| Migration guidance     | `references/workflow_migration.md` |

## PATTERN: Meta-Skills

**This skill (hook-development) is a meta-skill**—a skill about creating hooks. Meta-skills warrant full structure because they teach patterns that agents will apply repeatedly.

### When to Use Full Structure

Full structure (examples, anti-patterns, security patterns) is warranted when:

| Hook Type | Why Full Structure |
| :--- | :--- |
| **Security hooks** | Teaching patterns where errors are catastrophic |
| **Complex orchestration** | Multi-phase event handling where agents cut corners |
| **Production hooks** | High-stakes operations where testing is critical |
| **Low-freedom domains** | Precise matchers where deviation breaks things |

### When to Use Light Structure

Simple domain hooks can be much leaner:

```json
{
  "matcher": "tool == \"Bash\" && command matches \"rm -rf\"",
  "hooks": [{
    "type": "prompt",
    "prompt": "Confirm deletion of: $file_path",
    "timeout": 30
  }]
}
```

**8 lines. Complete. Sufficient.**

### The AI Agent Reality

**Agents are smart but lazy.** Without strong guidance:
- They skip reading ("I'll figure it out")
- They cut corners ("This is close enough")
- They miss edge cases ("Normal case works, ship it")

**Strong enforcement is warranted when:**
- The cost of getting it wrong is high (security, data loss)
- The pattern will be applied many times
- Edge cases are non-obvious (matcher syntax, timeout behavior)
- Safety requires explicit patterns

**Otherwise:** Trust the agent. A well-chosen example beats ten rules.

## System Requirements

- **Hook config**: JSON format with `matcher` + `hooks` array
- **Action types**: `prompt` (requires user confirmation) or `command` (silent blocking)
- **Timeout**: Required for `prompt` hooks (prevents blocking operations)
- **Matcher syntax**: `tool == "Bash" && tool_input.command matches "pattern"`
- **Portability**: Use project-relative paths, no hardcoded environment paths

## Operational Patterns

This skill follows these behavioral patterns:

- **Planning**: Switch to planning mode for architectural decisions
- **Discovery**: Locate files matching patterns and search file contents for hook integration points
- **Tracking**: Maintain a visible task list for hook development

<critical_constraint>
Native tools fulfill these patterns automatically. No manual routing needed.
</critical_constraint>

## Implementation Patterns

### Pattern: Destructive Operation Block

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\"",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "rm -rf detected. This cannot be undone. Type 'DELETE' to confirm.",
      "timeout": 30
    }
  ]
}
```

### Pattern: Sudo Confirmation

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"sudo\"",
  "hooks": [
    {
      "type": "command",
      "command": "echo 'Sudo requires explicit confirmation.'"
    }
  ]
}
```

### Pattern: Protected File Guard

```bash
if [[ "$file_path" == *".env"* ]]; then
  echo '{"decision": "deny", "reason": "Protected file"}' >&2
  exit 2
fi
```

## Troubleshooting

| Issue                               | Symptom                             | Solution                                                |
| ----------------------------------- | ----------------------------------- | ------------------------------------------------------- |
| Broad match blocking all operations | Matcher `"*"` or overly generic     | Target specific tool + dangerous args                   |
| User confused why operation failed  | Silent block with no explanation    | Use `prompt` type with clear message                    |
| Hook blocking forever               | Missing timeout on prompt hook      | Add `timeout: 30` or similar                            |
| Hook failing on different machines  | Hardcoded paths like `/home/user/`  | Use project-relative paths with `${CLAUDE_PROJECT_DIR}` |
| Variable injection vulnerability    | Unquoted variables with spaces      | Always quote variables: `"$file_path"`                  |
| Security bypass                     | No confirmation for destructive ops | Add prompt hook with confirmation requirement           |

---

Hooks are event-driven automation that intercept operations before execution. They provide safety mechanisms, enforce patterns, and enable automated intervention based on event matching.

**Core principle**: Hooks must be event-specific, security-conscious, and provide clear intervention logic.

---

## What Hooks Are

Hooks provide:

- **Event interception**: Pre-execution validation and control
- **Safety mechanisms**: Prevent destructive operations
- **Pattern enforcement**: Ensure compliance with standards
- **Automated intervention**: Proactive issue prevention
- **Security controls**: Authentication and authorization checks

### Hook Architecture

**Event-Driven**: Hooks respond to specific events (Bash commands, tool usage, file operations)

**Two-Phase Operation**:

1. **Matcher**: Identifies target events
2. **Action**: Executes intervention logic

---

## Core Structure

### Hook Configuration

```json
{
  "hooks": {
    "[EventName]": [
      {
        "matcher": "Event matching criteria",
        "hooks": [
          {
            "type": "prompt" | "command",
            "prompt": "Intervention message or validation",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Hook Body

- **Event identification**: What events to intercept
- **Matching logic**: How to identify target operations
- **Intervention strategy**: What action to take
- **Security implications**: Safety and risk considerations
- **Timeout handling**: Prevention of blocking operations

---

## PATTERN: XML Tags

XML tags add structure. Use them when structure helps, skip when it adds noise.

### When XML Helps

| Use Case | Why XML Works | Example |
| :--- | :--- | :--- |
| **Mission control** | Objective + success criteria | `<mission_control>` |
| **Non-negotiable rules** | Separates constraints from guidance | `<critical_constraint>` |
| **Interaction schema** | Event → action workflow | `<interaction_schema>` |
| **Pattern wrappers** | Semantic grouping for templates | `<pattern name="...">` |

### When to Skip XML

| Case | Use Instead |
| :--- | :--- |
| Simple examples | JSON or markdown code blocks |
| Pattern descriptions | Plain headers + content |
| General guidance | Direct prose |

### The Judgment Call

Ask: **Does the XML structure communicate something prose cannot?**

- Workflow orchestration? Yes → Use `<interaction_schema>`
- Non-negotiable rules? Yes → Use `<critical_constraint>`
- Simple examples? No → Use JSON/markdown

## ANTI-PATTERN: Common Mistakes

### Mistake 1: The Broad Match

❌ **Wrong:**
```json
"matcher": "*"
```
Generates noise and blocks legitimate operations.

✅ **Correct:**
```json
"matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\""
```

### Mistake 2: The Silent Block

❌ **Wrong:**
```json
"type": "command",
"command": "exit 1"
```
User sees generic failure with no guidance.

✅ **Correct:**
```json
"type": "prompt",
"prompt": "Destructive rm -rf detected. This cannot be undone. Type 'DELETE' to confirm.",
"timeout": 30
```

### Mistake 3: The Missing Timeout

❌ **Wrong:**
```json
"type": "prompt"
```
Operations without timeouts can deadlock the system.

✅ **Correct:**
```json
"type": "prompt",
"prompt": "Confirm destructive operation",
"timeout": 30
```

### Mistake 4: The Hardcoded Path

❌ **Wrong:**
```json
"command": "/home/user/scripts/validate.sh"
```
Fails when team members have different home directories.

✅ **Correct:**
```json
"command": "bash ${CLAUDE_PROJECT_DIR}/.claude/scripts/validate.sh"
```

### Mistake 5: The Unquoted Variable

❌ **Wrong:**
```bash
rm -rf $file_path
```
Injection risk with spaces or special chars.

✅ **Correct:**
```bash
rm -rf "$file_path"
```

---

## Correct Patterns

**Prompt for destructive operations:**

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\"",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "rm -rf detected. This cannot be undone. Type 'DELETE' to confirm.",
      "timeout": 30
    }
  ]
}
```

**Block sudo with clear message:**

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"sudo\"",
  "hooks": [
    {
      "type": "command",
      "command": "echo 'Sudo requires explicit confirmation. Remove this block if needed.'"
    }
  ]
}
```

**Protect sensitive files:**

```bash
# Check for .env before allowing operations
if [[ "$file_path" == *".env"* ]]; then
  echo '{"decision": "deny", "reason": "Protected file"}' >&2
  exit 2
fi
```

---

## Validation Checklist

Before claiming hook development complete:

**Matcher Design:**
- [ ] Matcher targets specific tool + dangerous operation
- [ ] Avoided broad matches like `"*"`
- [ ] Tested to catch intended operations without false positives

**Action Configuration:**
- [ ] Used `prompt` type for destructive operations requiring confirmation
- [ ] Used `command` type for clear blocking with explanation
- [ ] Timeout set on prompt hooks (prevents blocking)

**Security:**
- [ ] Destructive operations require explicit confirmation
- [ ] Protected files (`.env`, credentials) have special handling
- [ ] Variables properly quoted to prevent injection

**Portability:**
- [ ] Used project-relative paths with `${CLAUDE_PROJECT_DIR}`
- [ ] No hardcoded environment paths
- [ ] Works across different team member environments

---

## Team Collaboration Best Practices

### Shared vs Personal Hooks

**Team-wide hooks** (`.claude/settings.json`):

- Committed to version control
- Enforce project standards across team
- Security policies, quality gates
- Build/test requirements

**Personal hooks** (`.claude/settings.local.json`):

- Gitignored (add to `.gitignore`)
- Personal development preferences
- Local debugging tools
- Custom workflow automation

### Hook Independence

Design hooks assuming parallel execution:

- Hooks don't see each other's output
- No ordering guarantees
- Each hook should be independently useful
- Avoid duplicate functionality across team and personal hooks

---

## Best Practices Summary

✅ **DO:**
- Target specific tool + dangerous args in matchers
- Use `prompt` type for destructive operations
- Set `timeout: 30` on all prompt hooks
- Use project-relative paths with `${CLAUDE_PROJECT_DIR}`
- Quote all variables in bash commands
- Explain clearly what was detected and why

❌ **DON'T:**
- Use broad matches like `"*"` that block everything
- Use silent `command` blocks without explanation
- Omit timeout values on prompt hooks
- Hardcode paths like `/home/user/`
- Leave variables unquoted
- Skip confirmation for destructive operations

---

## Advanced Hooks Best Practices

1. **Keep hooks independent**: Don't rely on execution order
2. **Use timeouts**: Set appropriate limits for each hook type
3. **Handle errors gracefully**: Provide clear error messages
4. **Document complexity**: Explain advanced patterns in project README
5. **Test thoroughly**: Cover edge cases and failure modes
6. **Monitor performance**: Track hook execution time
7. **Version configuration**: Commit hook configs to git
8. **Provide escape hatches**: Allow bypass via flag files when needed

---

## Common Pitfalls to Avoid

### ❌ Assuming Hook Order

```bash
# BAD: Assumes hooks run in specific order
# Hook 1 saves state, Hook 2 reads it
# This can fail because hooks run in parallel!
```

### ❌ Long-Running Hooks

```bash
# BAD: Hook takes 2 minutes to run
sleep 120
# This will timeout and block the workflow
```

### ❌ Uncaught Exceptions

```bash
# BAD: Script crashes on unexpected input
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
cat "$file_path"  # Fails if file doesn't exist
```

### ✅ Proper Error Handling

```bash
# GOOD: Handles errors gracefully
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
if [ ! -f "$file_path" ]; then
  echo '{"continue": true, "systemMessage": "File not found, skipping check"}' >&2
  exit 0
fi
```

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
All components work with zero .claude/rules dependencies (portability invariant).
Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session).
Use What-When-Not-Includes format in descriptions (third person).
Progressive disclosure: SKILL.md contains core philosophy; references/ contains detailed content.
Use XML for control (mission_control, critical_constraint), Markdown for data.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

## The Path to High-Quality Hooks

### 1. Precise Matcher Design

Hooks work reliably when matchers target specific operations rather than broad patterns.

- **Target specifically**: Match tool + dangerous args (e.g., `tool == "Bash" && command matches "rm -rf"`)
- **Avoid broad matches**: Generic `"*"` matchers block legitimate operations
- **Test thoroughly**: Verify matchers catch intended operations without false positives

### 2. Clear User Communication

Hooks succeed when users understand why operations are blocked.

- **Prompt type for confirmation**: Use `type: "prompt"` for destructive operations requiring user consent
- **Command type for clear blocks**: Use `type: "command"` with explanation messages
- **Explain clearly**: Describe what was detected and why it matters

### 3. Timeout Protection

Hooks prevent system blocking when timeout values are properly configured.

- **Always set timeouts**: `timeout: 30` or similar prevents indefinite waiting
- **Prevent deadlocks**: Operations without timeouts can hang the entire system
- **Reasonable defaults**: 30 seconds works for most confirmation prompts

### 4. Portability Through Relative Paths

Hooks work across environments when paths are project-relative.

- **Use `${CLAUDE_PROJECT_DIR}`**: Instead of hardcoded paths like `/home/user/`
- **Environment variables**: Externalize configuration for different machines
- **Team compatibility**: Project-relative paths work across different home directories

### 5. Variable Safety

Hooks prevent injection vulnerabilities when variables are properly quoted.

- **Always quote variables**: `"$file_path"` instead of `$file_path`
- **Prevent injection**: Unquoted variables with spaces cause security issues
- **Bash best practices**: Use `[[ ]]` for tests and quote all expansions

### 6. Security-First Design

Hooks protect systems when safety mechanisms are properly implemented.

- **Destructive operation confirmation**: `rm -rf`, `sudo`, and similar commands require explicit approval
- **Protected file guards**: `.env`, credentials, and config files need special handling
- **Escape hatches**: Provide emergency override mechanisms for legitimate operations

---

<critical_constraint>
**System Physics:**

1. Zero external dependencies (portability invariant)
2. Hooks require timeout values to prevent blocking operations
3. Prompt hooks for user confirmation, command hooks for clear blocking
4. Completion claims require verification evidence
   </critical_constraint>
