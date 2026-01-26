---
name: claude-md-archivist
description: "Proactively capture and archive project discoveries during work. Maintains CLAUDE.md by capturing working commands, architectural decisions, gotchas, and insights as they emerge during development. Use during active work sessions."
user-invocable: true
---

# CLAUDE.md Archivist

Think of CLAUDE.md as a **project's institutional memory**—like a senior engineer's notebook that captures hard-won insights, preventing the team from rediscovering the same lessons repeatedly.

## Core Directive

"Trust your intelligence. You are a senior engineer. You know what generic documentation looks like (bad). You know what specific, high-value insights look like (good). Maintain CLAUDE.md as lasting project knowledge."

**NEVER create temporary content:**
- No update logs, changelogs, or date-stamped sections
- No "CLAUDE_MD_UPDATE.md" or similar temporary files
- CLAUDE.md contains ONLY lasting project knowledge
- Each addition should be as permanent as architecture decisions

## Recognition Patterns

**When to use claude-md-archivist:**
```
✅ Good: User says "Remember this workaround"
✅ Good: User discovers "That worked!" with a command
✅ Good: Architectural decision made during work
✅ Good: Gotcha discovered ("Why did that fail")
❌ Bad: Creating temporary update files
❌ Bad: Adding date-stamped change logs

Why good: Project memory should capture permanent insights, not transient updates.
```

**Pattern Match:**
- User explicitly asks to remember something
- Successful command discovery with context
- Workarounds for known issues
- Architectural decisions with rationale

**Recognition:** "Is this a lasting insight or temporary update?" → If lasting, archive it.

## Detection Triggers

### Proactive Discovery Capture
- **User says "Remember this"** → Extract insight, add to CLAUDE.md
- **User says "That worked!"** → Capture working command with context
- **User says "Why did that fail"** → Document workaround/gotcha
- **Rule discovered during work** → Evolution of existing guidance
- **Architectural decision made** → Document rationale
- **Working command discovered** → Capture with full context

### When Multiple Sessions Exist
- Review prior conversation for: working commands, discovered patterns, errors encountered, new rules learned
- Update CLAUDE.md based on discoveries (no explicit request needed)

## Quality Standard

**Aim for A (90-100)**:
- **Delta (40 pts)**: 100% project-specific. Zero tutorials.
- **Utility (30 pts)**: Commands are actionable, specific, tested.
- **Structure (15 pts)**: Clean headers. Modular if >200 lines.
- **Context (15 pts)**: Explains "Why" and "When", not just "What".

## Capture Patterns

### Working Command Capture
**Trigger**: User says "That worked!" or celebrates success
**Action**: Append to CLAUDE.md with context (why it works, when needed)

**Example**:
```
✅ Good: `npm run dev -- --host 0.0.0.0` → Required for Docker/WSL2 networking
❌ Bad: `npm run dev` → Just the command without context

Why good: Context explains when and why to use this command.
```

### Gotcha Discovery
**Trigger**: User discovers something that "fails without X"
**Action**: Add to appropriate section with pattern

**Example**:
```
✅ Good: Build OOM → Node 18+ needs NODE_OPTIONS="--max-old-memory-size=4096"
❌ Bad: "Node build fails sometimes"

Why good: Specific pattern with exact solution.
```

### Rule Evolution
**Trigger**: User learns new constraint or pattern
**Action**: Update existing section, preserve structure

**Example**: "TaskList requires natural language only" → Update that section

### Architectural Decision
**Trigger**: Major decision made during work
**Action**: Document with rationale (why, alternatives considered)

**Example**: "Chose X over Y because..."

## Safe Execution

**Validation Rules**:
- Validate CLAUDE.md exists before READ operations
- Preserve existing structure during updates
- Detect section boundaries before appending

**Anti-Pollution Rules**:
- NEVER create update logs, changelogs, or date-stamped sections
- NEVER create temporary files like "CLAUDE_MD_UPDATE.md"
- NEVER add "Update on [date]" or version tracking to CLAUDE.md
- CLAUDE.md contains ONLY lasting project knowledge

**Security Checks**:
- Validate file paths are within project directory
- Preserve YAML frontmatter and existing structure
- Never delete entire file without explicit user request

## Output Format

```markdown
Action: [What you captured]
Discovery: [What was learned]
Location: [Which section updated]
```

**Recognition:** "Does this capture permanent project knowledge?" → If yes, archive it. If temporary, don't add to CLAUDE.md.
