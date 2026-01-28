---
description: "Capture project discoveries to CLAUDE.md when users say 'remember this' or 'that worked', or when architectural decisions are made or gotchas found. Not for temporary notes or logs."
allowed-tools: Read, Edit, Write, Grep
---

<mission_control>
<objective>Capture project discoveries to CLAUDE.md as permanent project memory</objective>
<success_criteria>Insights archived with context, "why", "when", and location in CLAUDE.md</success_criteria>
</mission_control>

# Project Discovery Archive

Think of archiving as **building lasting project memory**—capturing permanent insights, architectural decisions, working commands, and gotchas as they emerge during development.

## Core Workflow

**Execute this pattern during active work:**

1. **Detect capture triggers** - Listen for key phrases and events
2. **Extract insight** - Identify the permanent knowledge
3. **Locate section** - Find appropriate CLAUDE.md section
4. **Append with context** - Add insight with "why" and "when"
5. **Report result** - Output action, discovery, location

## Detection Triggers

**Capture when these occur:**

- User says "Remember this" → Extract insight
- User says "That worked!" → Capture working command with context
- User says "Why did that fail" → Document workaround/gotcha
- Rule discovered → Evolution of existing guidance
- Architectural decision made → Document rationale
- Working command discovered → Capture with full context

**Binary test:** "Is this permanent project knowledge?" → If yes, archive it.

## Capture Patterns

**Working Command:**

```
Command: `npm run dev -- --host 0.0.0.0`
Context: Required for Docker/WSL2 networking
```

**Gotcha Discovery:**

```
Issue: Build OOM on Node 18+
Solution: NODE_OPTIONS="--max-old-memory-size=4096"
```

**Architectural Decision:**

```
Decision: Use PostgreSQL over MongoDB
Rationale: ACID compliance required for transactions
Alternatives considered: MongoDB (rejected due to lack of transactions)
```

## Quality Standards

**Target: A (90-100 points)**

- **Delta (40 pts):** 100% project-specific. Zero tutorials.
- **Utility (30 pts):** Commands actionable, specific, tested.
- **Structure (15 pts):** Clean headers. Modular if >200 lines.
- **Context (15 pts):** Explains "Why" and "When", not just "What".

## Anti-Patterns

**Never create:**

- Update logs or changelogs
- Date-stamped sections ("Updated on [date]")
- Temporary files like "CLAUDE_MD_UPDATE.md"
- Version tracking in CLAUDE.md

**CLAUDE.md contains only lasting project knowledge.**

## Safe Execution

**Validation:**

- Validate CLAUDE.md exists before operations
- Preserve existing structure during updates
- Detect section boundaries before appending

**Security:**

- Validate file paths within project directory
- Preserve YAML frontmatter and structure
- Never delete entire file without explicit request

## Output Format

```
Action: [What captured]
Discovery: [What learned]
Location: [Which section updated]
```

**Binary test:** "Does this capture permanent project knowledge?" → Archive if yes.

---

<critical_constraint>
MANDATORY: Only capture permanent knowledge - never temporary notes
MANDATORY: Include context (why and when), not just what
MANDATORY: Never create date-stamped sections or update logs
MANDATORY: Validate CLAUDE.md structure before appending
No exceptions. Archive creates lasting project memory, not transient notes.
</critical_constraint>
