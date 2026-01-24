---
name: claude-md-manager
description: "Maintain CLAUDE.md as lasting project memory capturing expert-level knowledge, working commands, architectural decisions, and project-specific patterns. Use when: new project setup, documentation is messy, conversation revealed insights, or working commands were discovered."
user-invocable: true
---

# CLAUDE.md Manager

**Goal**: Maintain a high-signal, expert-level `CLAUDE.md` that captures **Project Memory**.

## core_directive
"Trust your intelligence. You are a senior engineer. You know what generic documentation looks like (bad). You know what specific, high-value insights look like (good). Maintain CLAUDE.md as lasting project knowledge."

**NEVER create temporary content**:
- No update logs, changelogs, or date-stamped sections
- No "CLAUDE_MD_UPDATE.md" or similar temporary files
- CLAUDE.md contains ONLY lasting project knowledge
- Each addition should be as permanent as architecture decisions

## detection_patterns

**Detect these triggers in conversation:**

### Explicit Documentation Requests
- "Create CLAUDE.md" / "Setup documentation" / No CLAUDE.md exists
- "Fix documentation" / "Clean up" / "Messy docs"
- "Check quality" / "Audit" / "Review documentation"

### Knowledge Discovery Patterns
- **User says "Remember this"** → Extract insight, add to CLAUDE.md
- **User says "That worked!"** → Capture working command with context
- **User says "Why did that fail"** → Document workaround/gotcha
- **Rule discovered during work** → Evolution of existing guidance
- **Architectural decision made** → Document rationale

### When Multiple Sessions Exist
- Review prior conversation for: working commands, discovered patterns, errors encountered, new rules learned
- Update CLAUDE.md based on discoveries (no explicit request needed)

## quality_standard

**Aim for A (90-100)**:
- **Delta (40 pts)**: 100% project-specific. Zero tutorials.
- **Utility (30 pts)**: Commands are actionable, specific, tested.
- **Structure (15 pts)**: Clean headers. Modular if >200 lines.
- **Context (15 pts)**: Explains "Why" and "When", not just "What".

## conversational_patterns

**Working Command Capture**:
- Trigger: User says "That worked!" or celebrates success
- Action: Append to CLAUDE.md with context (why it works, when needed)
- Example: `npm run dev -- --host 0.0.0.0` → Required for Docker/WSL2 networking

**Gotcha Discovery**:
- Trigger: User discovers something that "fails without X"
- Action: Add to appropriate section with pattern
- Example: Build OOM → Node 18+ needs NODE_OPTIONS="--max-old-memory-size=4096"

**Rule Evolution**:
- Trigger: User learns new constraint or pattern
- Action: Update existing section, preserve structure
- Example: TaskList requires natural language only → Update that section

**Architectural Decision**:
- Trigger: Major decision made during work
- Action: Document with rationale (why, alternatives considered)
- Example: "Chose X over Y because..."

## safe_execution

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

## output_format
```markdown
## CLAUDE_MD_MANAGER_COMPLETE
Action: [What you did]
```
