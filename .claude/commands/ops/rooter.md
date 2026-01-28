---
description: "Self-maintenance operations router. Use when managing project health, extracting patterns, detecting context drift, or reflecting on session improvements."
argument-hint: [operation: extract, drift, reflect, or help]
---

# Ops Router

<mission_control>
<objective>Route to appropriate self-maintenance operation with minimal context overhead</objective>
<success_criteria>Correct operation identified and invoked, self-maintenance completed</success_criteria>
</mission_control>

## Operations

### /ops:extract

Extract reusable patterns from current conversation and codebase for component creation.

**When**: "Extract patterns from this session" or "What components should we create?"

```
/ops:extract
```

### /ops:drift

Detect and fix context drift - knowledge scattered across files, duplicate documentation, or skills referencing external files.

**When**: "Check for context drift" or "Audit self-containment"

```
/ops:drift
```

### /ops:reflect

Review current conversation for improvement opportunities. Identify patterns, detect drift, suggest patches.

**When**: "Reflect on this session" or "What could we improve?"

```
/ops:reflect
```

### /ops:help

Show available operations with descriptions.

```
/ops:help
```

---

## Usage Patterns

**Direct invocation:**

```
/ops:extract Pattern for new command
/ops:drift Check for context drift
/ops:reflect Review session for improvements
```

**In the void:**

```
/ops:extract
[Asks what pattern to extract]
/ops:drift
[Runs context drift analysis]
/ops:reflect
[Analyzes conversation for improvements]
```

---

<critical_constraint>
MANDATORY: Operations are self-contained and work in isolation
MANDATORY: Use L'Entonnoir pattern for intent narrowing
MANDATORY: No external path references - bundle or invoke directly
No exceptions. Ops commands maintain project health autonomously.
</critical_constraint>
