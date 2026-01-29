---
description: "Capture project discoveries to CLAUDE.md and .claude/rules/ when users say 'remember this' or 'that worked', or when architectural decisions are made or gotchas found. Not for temporary notes, migration notes, or edit logs."
allowed-tools: Read, Edit, Write, Grep
---

<mission_control>
<objective>Capture project discoveries to CLAUDE.md and .claude/rules/ as permanent project memory; refine and evolve existing rules when patterns emerge</objective>
<success_criteria>Insights archived with context, "why", "when"; rules evolved with preserved history; zero meta-notes or migration markers</success_criteria>
</mission_control>

# Project Discovery Archive

Think of archiving as **building lasting project memory**—capturing permanent insights, architectural decisions, working commands, and gotchas as they emerge during development.

## Current rules state (if exists)

<injected_content>
@CLAUDE.md
@.claude/rules/principles.md
@.claude/rules/architecture.md
@.claude/rules/quality.md
</injected_content>

## Injection Phase

**FIRST**, review the injected context before performing any archival:

1. **Identify existing sections** - Architecture, commands, gotchas, discoveries
2. **Identify rules** - Principles, architecture, quality that may need evolution
3. **Scan conversation** - Extract potential learnings from context
4. **Detect existing patterns** - Avoid redundancy with documented knowledge
5. **Align with conventions** - Ensure proposed content matches project style

## Dual-Mode Operation

### Implicit Mode (Default - No Arguments)

When invoked without explicit content to archive, **infer from conversation**:

| Signal Type      | Detection Pattern                                  | Extraction Action                 |
| ---------------- | -------------------------------------------------- | --------------------------------- |
| Success marker   | `"that worked"`, `"finally"`, `"got it"`           | Capture command + context         |
| Explicit request | `"remember this"`, `"note this"`, `"archive this"` | Extract stated insight            |
| Decision made    | Planning outcome, architecture choice              | Document rationale + alternatives |
| Gotcha found     | Issue description + solution                       | Record problem + workaround       |
| Rule evolution   | Existing guidance updated                          | Evolve the rule, preserve history |

**Inference Process:**

1. Scan last 20 messages for discovery indicators
2. Identify unique insights not already in CLAUDE.md
3. Extract commands with their success context
4. Detect architectural decisions from execution flow
5. Propose specific additions with diffs

### Explicit Mode (Content Provided)

When user specifies what to archive, validate and apply:

1. **Validate delta** - Is this project-specific knowledge?
2. **Check redundancy** - Does similar content already exist?
3. **Add context** - Include "why" and "when"
4. **Format** - Match project style conventions
5. **Propose** - Show diff before applying

## Core Workflow

**Execute this pattern during active work:**

1. **Detect capture triggers** - Listen for key phrases and events
2. **Extract insight** - Identify the permanent knowledge
3. **Align with conventions** - Check CLAUDE.md and rules
4. **Locate section** - Find appropriate CLAUDE.md section
5. **Append with context** - Add insight with "why" and "when"
6. **Report result** - Output action, discovery, location

## Detection Triggers

**Capture when these occur:**

- User says "Remember this" → Extract insight
- User says "That worked!" → Capture working command with context
- User says "Why did that fail" → Document workaround/gotcha
- Rule discovered → Evolution of existing guidance
- Architectural decision made → Document rationale
- Working command discovered → Capture with full context

**Binary test:** "Is this permanent project knowledge?" → If yes, archive it.

## Alignment Check

Before proposing any addition, verify alignment:

| Check             | Question                              | Action if Fail                      |
| ----------------- | ------------------------------------- | ----------------------------------- |
| Delta check       | Would Claude know this from training? | Don't archive                       |
| Convention check  | Does this match project style?        | Format to match                     |
| Redundancy check  | Is this already documented?           | Reference existing, don't duplicate |
| Specificity check | Is this project-specific?             | Remove generic advice               |
| Permanence check  | Will this be relevant in 6 months?    | Archive if yes                      |

## Capture Patterns

**What to Archive:**

- Permanent project knowledge (commands, gotchas, decisions)
- Rule evolution with rationale
- Architectural decisions with context

**What NEVER to Archive:**

- Migration notes ("migrated from X to Y")
- Edit logs ("updated file", "modified section")
- Meta-notes ("this was a refactoring")
- Date-stamped entries
- Version tracking

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

**Rule Evolution:**

```
Previous: Commands must be documented in ## Commands section
Updated: Commands documented in ## Commands with context about when to use each
Reason: Context helps Claude choose appropriate command
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
- Migration notes ("migrated from X to Y")
- Edit notes ("updated file", "refactored section")
- Meta-commentary ("this was a refactoring")
- Version tracking in CLAUDE.md
- Generic best practices already covered in rules

**Archive only: Permanent project knowledge. No meta-notes.**

## Safe Execution

**Validation:**

- Validate CLAUDE.md exists before operations
- Preserve existing structure during updates
- Detect section boundaries before appending
- Back up existing content before major changes

**Security:**

- Validate file paths within project directory
- Preserve YAML frontmatter and structure
- Never delete entire file without explicit request
- Propose before applying (no silent changes)

## Output Format

### Critical: No Changelog Entries

**NEVER propose content that reads like a changelog:**

```
❌ Changelog-style (FORBIDDEN):
- "Resolved contradiction between principles.md and quality.md"
- "Fixed handoff/diagnostic.md to use timestamp naming"
- "Updated toolkit/audit.md to use correct lookup filenames"
- "Resolved contradiction" or "Fixed file X to do Y"

✅ Rule Evolution (REQUIRED):
- "Voice Standard: Use infinitive form in descriptions (bare infinitive like 'Validate', not 'You should'). Applies to all component descriptions."
- "Progressive Disclosure Scope: Tier 1-3 applies ONLY to skills with folder structure. Commands are single-file—no references/ folder."
- "Lookup Reference Naming: All lookup references use `lookup_<concept>.md` pattern, not `<concept>-reference.md`."
```

**The distinction:**

| Changelog (Forbidden)            | Rule Evolution (Required)                   |
| -------------------------------- | ------------------------------------------- |
| "Fixed file X"                   | "Rule: [Principle to follow]"               |
| "Resolved contradiction between" | "Why: [Rationale for future sessions]"      |
| "Updated component to do Y"      | "When: [Trigger condition for application]" |
| Specific file paths              | Abstract principle applicable project-wide  |

**Always ask:** "If I apply this rule in 6 months, will I understand why without needing the session history?"

### Implicit Mode (Infer from Conversation)

After inference, present discoveries with AskUserQuestion:

```
## Inferred Discoveries

Found the following potential rule refinements:

1. **[Rule Domain]** - [The refined principle]
   - Signal: [Detection trigger]
   - Why: [Rationale for future sessions]
   - When: [Trigger condition for application]

2. **[Rule Domain]** - [The refined principle]
   - Signal: [Detection trigger]
   - Why: [Rationale for future sessions]
   - When: [Trigger condition for application]
```

**AskUserQuestion:**

```
I found X rule refinements. What would you like to do?

Options:
- Archive all as refined rules
- Archive only specific ones (tell me which)
- Modify the rule content before archiving
- Skip (nothing worth refining)
```

### Explicit Mode (User-Provided Content)

Validate and present placement options with AskUserQuestion:

````
## Rule Refinement Proposal

**Proposed refinement:**
```diff
+ [The rule principle, abstracted from specific files]
```

**Context:**
- Why: [Rationale for future sessions]
- When: [Trigger condition for application]
- Where: [Appropriate rules section]
````

**AskUserQuestion:**

```
Where should this rule refinement go?

Options:
- Append to ## [Section A] - [Rationale]
- Append to ## [Section B] - [Rationale]
- Create new section ## [Section C]
- Modify the rule content first
- Don't archive this
```

### After Approval

Apply the change and confirm:

```
Action: Refined [rule domain]
Location: [Section/file updated]
Rule: [The abstract principle]
Why: [Rationale captured]
When: [Trigger condition]
```

**Binary test:** "Does this capture a rule principle, not a changelog entry?" → Archive if yes.

---

<critical_constraint>
MANDATORY: Only capture permanent knowledge - never temporary notes
MANDATORY: Never archive migration notes, edit logs, or meta-commentary
MANDATORY: Target both CLAUDE.md and .claude/rules/ for refinement
MANDATORY: Include context (why and when), not just what
MANDATORY: Never create date-stamped sections or update logs
MANDATORY: Validate CLAUDE.md structure before appending
MANDATORY: Propose before applying - no silent changes
MANDATORY: Check for redundancy before proposing additions
MANDATORY: Align with project conventions (CLAUDE.md style)
No exceptions. Archive creates lasting project memory, not transient notes.
</critical_constraint>
