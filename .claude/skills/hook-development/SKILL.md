---
name: hook-development
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse/PostToolUse/Stop hook", "validate tool use", "implement prompt-based hooks", "set up event-driven automation", "block dangerous commands", or mentions hook events (PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, Stop, SubagentStop, SubagentStart, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Setup, Notification). Provides comprehensive guidance for creating and implementing hooks in local .claude/ configuration with focus on project-level automation and security.
---

# Hook Development: Architectural Refiner

**Role**: Transform intent into portable, event-driven hooks
**Mode**: Architectural pattern application (ensure output has specific traits)

---

## Architectural Pattern Application

When building a hook, apply this process:

1. **Analyze Intent** - What type of hook and what traits needed?
2. **Apply Teaching Formula** - Bundle condensed philosophy into output
3. **Enforce Portability Invariant** - Ensure works in isolation
4. **Verify Traits** - Check event-driven automation, security patterns, Success Criteria

---

## Core Understanding: What Hooks Are

**Metaphor**: Hooks are "event-driven sentries"—they stand guard at specific points in the execution flow and respond to events automatically.

**Definition**: Hooks are event-driven automation scripts that execute in response to Claude Code events. They validate operations, enforce policies, and integrate external tools into workflows.

**Key insight**: Hooks bundle their own event logic and validation philosophy. They don't depend on external documentation to enforce security.

✅ Good: Hook includes bundled validation patterns with specific event handlers
❌ Bad: Hook references external documentation for event logic
Why good: Hooks must self-validate without external dependencies

Recognition: "Would this hook work if moved to a project with no rules?" If no, bundle the philosophy.

---

## Hook Traits: What Portable Hooks Must Have

### Trait 1: Portability (MANDATORY)

**Requirement**: Hook works in isolation without external dependencies

**Enforcement**:
- Bundle condensed Seed System philosophy (Delta Standard, Event-Driven Automation, Teaching Formula)
- Include Success Criteria for self-validation
- Provide complete event handler examples
- Never reference .claude/rules/ files

**Example**:
```
## Core Philosophy

Think of hooks like event-driven sentries: they guard specific execution points.

✅ Good: Include specific event validation logic with examples
❌ Bad: Vague event handlers without concrete patterns
Why good: Specific patterns enable consistent enforcement

Recognition: "Could this hook enforce policies without external documentation?" If no, add validation patterns.
```

### Trait 2: Teaching Formula Integration

**Requirement**: Every hook must teach through metaphor, contrast, and recognition

**Enforcement**: Include all three elements:
1. **1 Metaphor** - For understanding (e.g., "Think of X like a Y")
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Template**:
```
Metaphor: [Understanding aid]

✅ Good: [Concrete example]
❌ Bad: [Concrete example]
Why good: [Reason]

Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
```

### Trait 3: Self-Containment

**Requirement**: Hook owns all its content

**Enforcement**:
- Include all validation examples directly
- Provide complete hook configuration
- Bundle necessary security philosophy
- Never reference external files

✅ Good: Complete hook configuration with embedded validation logic
❌ Bad: "See external scripts for validation logic"
Why good: Self-contained hooks work without external references

Recognition: "Does hook reference files outside itself?" If yes, inline the content.

### Trait 4: Event-Driven Automation

**Requirement**: Hook responds to specific events with defined logic

**Enforcement**:
- Specific event type (PreToolUse, PostToolUse, Stop, etc.)
- Clear validation logic
- Defined response format (JSON for prompt hooks)
- Security patterns included

**Example**:
```json
{
  "type": "prompt",
  "prompt": "Validate file write safety. Check: system paths, credentials, path traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

### Trait 5: Success Criteria Invariant

**Requirement**: Hook includes self-validation logic

**Template**:
```
## Success Criteria

This hook is complete when:
- [ ] Valid JSON configuration in settings.json
- [ ] Specific event type with clear validation logic
- [ ] Teaching Formula: 1 Metaphor + 2 Contrasts + 3 Recognition
- [ ] Portability: Works in isolation, bundled philosophy, no external refs
- [ ] Security: Event validation patterns included
- [ ] Response format: Correct JSON structure for prompt hooks

Self-validation: Verify each criterion without external dependencies. If all checked, hook meets Seed System standards.
```

**Recognition**: "Could a user validate this hook using only its content?" If no, add Success Criteria.

---

## Anatomical Requirements

### Required: Hook Configuration

**Location:** `.claude/settings.json` (team-wide) or `.claude/settings.local.json` (personal)

**Structure**:
```json
{
  "hooks": {
    "EventType": [
      {
        "matcher": "ToolName|*",
        "hooks": [
          {
            "type": "prompt|command",
            "prompt|command": "[validation logic]",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Required: Hook Types

**Prompt-Based Hooks** (recommended):
- LLM-driven decision making
- Context-aware validation
- JSON response format required

**Command Hooks**:
- Bash command execution
- Deterministic checks
- Fast validation

### Required: Event Types

**PreToolUse**: Validate before tool execution
**PostToolUse**: React to tool results
**PostToolUseFailure**: Handle tool failures
**PermissionRequest**: Validate permission requests
**Stop**: Enforce completion standards
**SubagentStart/Stop**: Track subagent lifecycle
**SessionStart/End**: Load/cleanup context
**UserPromptSubmit**: Validate user input
**Setup**: Initialize project context

**Recognition**: "Which event type matches the validation need?" Select specific event for targeted enforcement.

---

## Pattern Application Framework

### Step 1: Analyze Intent

**Question**: What type of hook and what traits needed?

**Analysis**:
- Security validation? → PreToolUse with prompt-based logic
- Policy enforcement? → Stop hook with validation
- Context loading? → SessionStart with command hook
- Tool integration? → PostToolUse with command hook

**Example**:
```
Intent: Build hook for file write validation
Analysis:
- Security focus → Need PreToolUse event
- Complex validation → Use prompt-based hook
- JSON response → Required format
Output traits: Portability + Teaching Formula + Event-Driven + Success Criteria
```

### Step 2: Apply Teaching Formula

**Requirement**: Bundle condensed Seed System philosophy

**Elements to include**:
1. **Metaphor**: "Hooks are event-driven sentries..."
2. **Delta Standard**: Good Component = Expert Knowledge - What Claude Knows
3. **Event-Driven Automation**: Specific event types explained
4. **2 Contrast Examples**: Good vs Bad hook configuration
5. **3 Recognition Questions**: Binary self-checks for quality

**Template integration**:
```markdown
## Core Philosophy

Metaphor: "Think of hooks like [metaphor]..."

✅ Good: type: "prompt" with specific validation logic
❌ Bad: type: "command" without validation patterns
Why good: Specific logic enables consistent enforcement

Recognition: "Does hook include specific event validation?" → If no, add event patterns
Recognition: "Is validation logic self-contained?" → If no, bundle philosophy
Recognition: "Could this work without external documentation?" → If no, include examples
```

### Step 3: Enforce Portability Invariant

**Requirement**: Ensure hook works in isolation

**Checklist**:
- [ ] Condensed philosophy bundled (Delta Standard, Event-Driven, Teaching Formula)
- [ ] Success Criteria included
- [ ] Complete event handler examples
- [ ] No external .claude/rules/ references
- [ ] Security patterns embedded

**Verification**: "Could this hook survive being moved to a fresh project with no .claude/rules?" If no, fix portability issues.

### Step 4: Verify Traits

**Requirement**: Check all mandatory traits present

**Verification**:
- Portability Invariant ✓
- Teaching Formula (1 Metaphor + 2 Contrasts + 3 Recognition) ✓
- Self-Containment ✓
- Event-Driven Automation ✓
- Success Criteria Invariant ✓

**Recognition**: "Does hook meet all five traits?" If any missing, add them.

---

## Architecture Patterns

### Pattern 1: Prompt-Based Validation

**Trait**: LLM-driven context-aware decisions

**Application**: Use prompt hooks for complex validation

**Example**:
```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

**Response format**: `{ "ok": true|false, "reason": "explanation" }`

### Pattern 2: Command Hooks

**Trait**: Deterministic bash validation

**Application**: Use command hooks for fast checks

**Example**:
```json
{
  "type": "command",
  "command": "bash .claude/scripts/validate.sh",
  "timeout": 60
}
```

**Use cases**: File system checks, external tools, performance-critical validation

### Pattern 3: Multi-Hook Composition

**Trait**: Multiple hooks per event

**Application**: Stack validation hooks

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {"type": "command", "command": ".claude/scripts/check1.sh"},
          {"type": "command", "command": ".claude/scripts/check2.sh"},
          {"type": "prompt", "prompt": "Validate..."}
        ]
      }
    ]
  }
}
```

**Recognition**: "Does hook design account for independence?" Hooks don't see each other's output.

---

## Security Patterns

### Pattern 1: File Write Validation

**Use PreToolUse** for Write/Edit operations:

```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate file write safety. Check: system paths, credentials, path traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
    }
  ]
}
```

### Pattern 2: Completion Enforcement

**Use Stop** for code completion validation:

```json
{
  "matcher": "*",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "If code was modified, verify tests were run. If not, respond with JSON: {\"decision\": \"block\", \"reason\": \"Tests must be run after code changes\"}. Otherwise respond: {\"decision\": \"allow\"}."
    }
  ]
}
```

### Pattern 3: Permission Validation

**Use PermissionRequest** for security checks:

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate bash command safety. Check: destructive operations, system commands, credential access. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
    }
  ]
}
```

---

## Common Transformations

### Transform Tutorial → Architectural

**Before** (tutorial):
```
Step 1: Understand hook types
Step 2: Configure event handlers
Step 3: Add validation logic
...
```

**After** (architectural):
```
Analyze Intent → Apply Teaching Formula → Enforce Portability → Verify Traits
```

**Why**: Architectural patterns ensure output has required traits, not just follows steps.

### Transform Reference → Bundle

**Before** (referenced):
```
"See security patterns documentation"
```

**After** (bundled):
```
## Core Philosophy

Bundle security patterns directly in hook:

Think of hooks like event-driven sentries...

✅ Good: [example]
❌ Bad: [example]
Why good: [reason]
```

**Why**: Hooks must work in isolation.

---

## Quality Validation

### Portability Test

**Question**: "Could this hook work if moved to a project with zero .claude/rules?"

**If NO**:
- Bundle condensed philosophy
- Add Success Criteria
- Remove external references
- Include complete event examples

### Teaching Formula Test

**Checklist**:
- [ ] 1 Metaphor present
- [ ] 2 Contrast Examples (good/bad) with rationale
- [ ] 3 Recognition Questions (binary self-checks)

**If any missing**: Add them using Teaching Formula Arsenal

### Event Validation Test

**Question**: "Does hook include specific event validation logic?"

**If NO**: Add concrete event handler patterns

### Security Test

**Question**: "Does hook enforce security patterns?"

**If NO**: Include validation patterns for the event type

---

## Success Criteria

This hook-development guidance is complete when:

- [ ] Architectural pattern clearly defined (Analyze → Apply → Enforce → Verify)
- [ ] Teaching Formula integrated (1 Metaphor + 2 Contrasts + 3 Recognition)
- [ ] Portability Invariant explained with enforcement checklist
- [ ] All five traits defined (Portability, Teaching Formula, Self-Containment, Event-Driven Automation, Success Criteria)
- [ ] Pattern application framework provided
- [ ] Security patterns included
- [ ] Quality validation tests included
- [ ] Success Criteria present for self-validation

Self-validation: Verify hook-development meets Seed System standards using only this content. No external dependencies required.

---

## Reference: The Five Mandatory Traits

Every hook must have:

1. **Portability** - Works in isolation
2. **Teaching Formula** - 1 Metaphor + 2 Contrasts + 3 Recognition
3. **Self-Containment** - Owns all content
4. **Event-Driven Automation** - Responds to specific events
5. **Success Criteria** - Self-validation logic

**Recognition**: "Does this hook have all five traits?" If any missing, add them.

---

**Remember**: Hooks are event-driven sentries. They guard execution points and enforce policies automatically. Bundle the philosophy. Enforce the invariants. Verify the traits.
