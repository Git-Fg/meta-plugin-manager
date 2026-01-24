---
name: claude-md-archivist
description: "Proactively capture and archive project discoveries during work. Maintains CLAUDE.md by capturing working commands, architectural decisions, gotchas, and insights as they emerge during development. Use during active work sessions."
user-invocable: true
---

# CLAUDE.md Archivist

**Goal**: Proactively capture and archive project discoveries to maintain high-signal, expert-level `CLAUDE.md` as **Project Memory**.

## core_directive
"Trust your intelligence. You are a senior engineer. You know what generic documentation looks like (bad). You know what specific, high-value insights look like (good). Maintain CLAUDE.md as lasting project knowledge."

**NEVER create temporary content**:
- No update logs, changelogs, or date-stamped sections
- No "CLAUDE_MD_UPDATE.md" or similar temporary files
- CLAUDE.md contains ONLY lasting project knowledge
- Each addition should be as permanent as architecture decisions

## detection_patterns

**Detect these triggers in conversation:**

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

## CRITICAL: The "Citing Project Rules" Anti-Pattern

### What Happened

During refactoring, skills were incorrectly modified to reference `.claude/rules/` files. This is a **critical anti-pattern** that breaks skill portability.

### Why It's Wrong

**Skills Must Be Portable**:
- Skills should work in ANY project context
- They cannot depend on project-specific files (`.claude/rules/`)
- Skills are user content that moves between projects
- Project rules are meta-knowledge specific to THIS project only

**The Two-Layer Architecture**:

```
┌─────────────────────────────────────┐
│  PROJECT-SPECIFIC META-KNOWLEDGE     │
│  (.claude/rules/)                    │
│  - Philosophy                       │
│  - Architecture patterns            │
│  - Quality framework                │
│  - Working patterns                 │
│  - Lessons learned                  │
│                                     │
│  ⚠️ ONLY for THIS project          │
└─────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────┐
│  PORTABLE SKILLS (in .claude/skills/)│
│  ✅ Self-contained                  │
│  ✅ No external dependencies        │
│  ✅ Work in any project            │
│  ✅ Embedded knowledge              │
└─────────────────────────────────────┘
```

### Correct Pattern

**For Project Rules** (`.claude/rules/`):
- Capture project-specific knowledge
- Document architectural decisions made during work
- Store working commands and patterns discovered
- **NEVER reference from skills**

**For Skills** (`.claude/skills/*/`):
- Self-contained with all knowledge embedded
- Local `references/` for additional detail
- Document dependencies clearly
- **NEVER reference project rules**

### Red Flags to Watch For

- References to `.claude/` paths in skill content
- "See project rules" or "See architecture guide"
- "Use the framework from rules/"
- Needing external files to execute

### Example of Wrong vs Right

**❌ WRONG** (non-portable):
```markdown
For quality validation, use the framework in
[.claude/rules/quality-framework.md].
```

**✅ CORRECT** (portable):
```markdown
## Quality Integration

Apply dimensional scoring (0-10 scale):
- Structural (30%), Components (50%), Standards (20%)
- Check for anti-patterns
- Target: ≥8/10 for production readiness
```

### Recovery Pattern

If you discover skills referencing project rules:
1. Extract the referenced content
2. Embed it directly in the skill
3. Remove the external reference
4. Verify portability
5. Update rules to reflect lessons learned

**This ensures skills remain portable while preserving project knowledge.**

## What Would Have Helped Contextualize This

### The Critical Questions (Ask These Early)

**1. "What is the responsibility of this file?"**
- `.claude/rules/` → Project-specific meta-knowledge
- Skills → Portable execution logic
- Mixing these = architectural violation

**2. "Can this skill work in isolation?"**
- Self-contained? YES/NO
- Needs external files? → VIOLATION
- Would work in new project? YES/NO

**3. "Where does this knowledge live vs where should it live?"**
- Current location: `____`
- Should location: `____`
- If different → MOVE IT

**4. "Am I building for portability or convenience?"**
- Convenience → References to project files (❌)
- Portability → Embedded knowledge (✅)

### The Mental Model

**"Skills are Libraries, Rules are Notes"**:
- Libraries (skills) → Shared, reusable, self-contained
- Notes (rules) → Project-specific, one-off, contextual
- A library shouldn't need your notes to work
- Your notes can reference libraries, not vice versa

**"Copy-Paste Test"**:
Can you copy the skill to a new project?
- YES → It's portable ✅
- NO → It's broken ❌
- WHY? → References project files

## output_format
```markdown
## CLAUDE_MD_ARCHIVIST_COMPLETE
Action: [What you captured]
Discovery: [What was learned]
Location: [Which section updated]
```
