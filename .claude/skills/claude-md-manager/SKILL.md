---
name: claude-md-manager
description: "Maintain CLAUDE.md + .claude/rules/ as unified project memory capturing expert-level knowledge, working commands, architectural decisions, and project-specific patterns. Use when: new project setup, documentation is messy, conversation revealed insights, rules evolved, or working commands were discovered."
user-invocable: true
---

# CLAUDE.md Manager

**Goal**: Maintain a high-signal, expert-level `CLAUDE.md` that captures **Project Memory**.

## core_directive
"Trust your intelligence. You are a senior engineer. You know what generic documentation looks like (bad). You know what specific, high-value insights look like (good). Manage CLAUDE.md + .claude/rules/ as a unified project memory system."

## critical_rule
**ALWAYS review and update CLAUDE.md AND .claude/rules/ together.**
- They are a single unit — never update one without checking the other
- Rules in .claude/rules/ may need updating when CLAUDE.md changes
- CLAUDE.md may reference .claude/rules/ that no longer exist
- Synchronization prevents drift between documentation layers

## decision_logic

### 0. DEFAULT: Conversation Context (Highest Priority)
**If there is ANY prior conversation in this session → Default to INCREMENTAL-UPDATE**
- Conversation exists = knowledge has been generated = capture it
- No explicit request needed — prior conversation is the trigger
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned
- Update CLAUDE.md AND .claude/rules/ together (see critical_rule)

### 1. Detect Mode (Explicit Requests Override Default)
- **"Create new" / "Setup" / No CLAUDE.md exists** → `CREATE` (Scan project, pick template, generate valid commands)
- **"Fix documentation" / "Clean up" / "Messy"** → `REFACTOR` (Apply Delta Standard, cut tutorials, move to .claude/rules/)
- **"Check quality" / "Audit" / "Review"** → `AUDIT` (Rate quality, report findings)
- **Explicit update request** → `ACTIVE-LEARN` (Extract specific findings, update file)

### 2. Detect Conversational Context (For INCREMENTAL-UPDATE)
**Pattern recognition for ACTIVE-LEARN mode:**
- **User says "Remember this"** → Extract insight, append to appropriate section
- **User says "That worked!"** → Capture working command/pattern
- **User says "Why did that fail"** → Document workaround
- **Multiple similar errors** → Suggest adding to "Known Issues" section
- **Rule discovered during work** → Evolution of existing guidance

### 3. Apply Quality Standards (The Scorecard)
Aim for **A (90-100)**.

| Criteria | Points | Target |
|----------|--------|--------|
| **Delta** | 40 | **CRITICAL**: 100% Project Specific. Zero tutorials. |
| **Utility** | 30 | Commands are actionable, specific, and tested. |
| **Structure**| 15 | Clean headers. Modular if >200 lines (`.claude/rules/`). |
| **Context** | 15 | Explains "Why" and "When", not just "What". |

## conversational_active_learning

**CRITICAL**: Each pattern below MUST review BOTH CLAUDE.md AND .claude/rules/ for updates.

**Pattern 1: Working Command Capture**
```
User: "That `npm run dev -- --host 0.0.0.0` command finally worked!"
Action: Append to CLAUDE.md under "## Commands" with context
Result:
## Commands
| Command | Context |
|---------|---------|
| `npm run dev -- --host 0.0.0.0` | Required for Docker/WSL2 networking |
```

**Pattern 2: Gotcha Discovery**
```
User: "Oh, the build fails without NODE_OPTIONS=--max-old-space-size=4096"
Action: Add to "## Known Issues" with reproduction pattern
Result:
## Known Issues
- **Build OOM**: Node 18+ needs NODE_OPTIONS="--max-old-space-size=4096"
```

**Pattern 3: Rule Evolution**
```
User: "I learned that TaskList requires natural language only"
Action: Update relevant section, preserve existing structure
Result: Updated guidance with new constraint information
```

**Pattern 4: INCREMENTAL-UPDATE Mode**
```
Context: User discovers pattern mid-conversation
Action: Update specific section without full refactor
Detection: Content type determines section (Commands/Known Issues/Decisions)
```

## safe_execution

**Validation Rules:**
- Validate CLAUDE.md exists before READ operations
- Use Write (not Edit) for CREATE mode
- Preserve existing structure during ACTIVE-LEARN
- Detect section boundaries before appending
- Use Edit for INCREMENTAL-UPDATE to preserve formatting

**Security Checks:**
- Validate file paths are within project directory
- Preserve YAML frontmatter and existing structure
- Never delete entire file without explicit user request

## reference_library
- [references/principles.md](references/principles.md) (The Core Philosophy)
- [references/workflow-examples.md](references/workflow-examples.md) (Inspiration Patterns)

## output_format
```markdown
## CLAUDE_MD_MANAGER_COMPLETE
Mode: [CREATE|REFACTOR|ACTIVE-LEARN|INCREMENTAL-UPDATE|AUDIT]
Score: [0-100]
Action: [What you did]
```
