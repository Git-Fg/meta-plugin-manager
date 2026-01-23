---
name: claude-md-manager
description: "Manage CLAUDE.md files with context-aware workflows. Use when CLAUDE.md is missing, messy, or needs updates. Detects project state and conversation context to CREATE new files, ACTIVE-LEARN from sessions, or REFACTOR existing content. Do not use for standalone documentation."
user-invocable: true
---

# CLAUDE.md Manager

## WIN CONDITION

**Called by**: toolkit-architect
**Purpose**: Create, audit, or refactor CLAUDE.md files

**Output**: Must output completion marker with quality score

```markdown
## CLAUDE_MD_MANAGER_COMPLETE

Action: [CREATE|AUDIT|REFACTOR|ACTIVE-LEARN]
Quality Score: XX/100
File: [CLAUDE.md|.claude/CLAUDE.md]
Changes: [Summary]
```

**Completion Marker**: `## CLAUDE_MD_MANAGER_COMPLETE`

Create, audit, and refactor CLAUDE.md files with Delta Standard optimization.

**CRITICAL: Before starting, you MUST:**
1. Read all available workflows to understand your options
2. Understand context engineering and Delta Standard concepts

**Mandatory Reference Files** (read in order):
1. `references/mode-detection.md` - How each workflow operates
2. `references/delta-standard.md` - Content filtering methodology
3. `references/quality-framework.md` - 7-dimensional scoring system

---

## Mandatory Reading Order

**Step 1: Understand Context Engineering**
> "Claude is a senior engineer who knows basics but needs to learn project-specific decisions, non-obvious patterns, and working commands."

**Step 2: Learn the Delta Standard**
> "Good Customization = Expert-only Knowledge − What Claude Already Knows"

**Step 3: Study Each Workflow**
- CREATE: Empty project investigation and template selection
- ACTIVE-LEARN: Mid-conversation discovery capture
- REFACTOR: Delta Standard application and modularization
- AUDIT: Quality assessment and recommendations

**Step 4: Review Quality Framework**
- 7-dimension scoring system (0-100 points)
- Grade thresholds (A: 90-100, B: 75-89, C: 60-74, D: 40-59, F: <40)
- Success criteria for each workflow

**Why Mandatory:** These references contain the complete knowledge needed to make informed decisions about which workflow to use and how to execute it properly. Without this foundation, the skill cannot function autonomously.

## 🚨 MANDATORY: Read Before Managing

**CRITICAL**: You MUST understand these concepts:

### Context Engineering (What Claude Doesn't Know)

Claude is a senior engineer who knows:
- Basic programming concepts
- Common frameworks (React, Express, etc.)
- Standard tools (Git, Docker, etc.)
- Best practices (DRY, testing, etc.)
- Industry conventions

Claude NEEDS to learn:
- **Why** you made specific decisions
- **How** your project works specifically
- **What** patterns are unique to your codebase
- **Which** commands actually work
- **Where** the gotchas are

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

**KEEP**:
- Project-specific commands that work
- Non-obvious gotchas and workarounds
- Architecture decisions and rationale
- "NEVER do X because [specific reason]"

**REMOVE**:
- Generic explanations ("What is X")
- Library tutorials
- Common best practices
- Definitions of industry terms

**Example**:

❌ **Before (200 lines of React tutorial)**:
```
React is a JavaScript library for building user interfaces. Components
are the building blocks of React applications. You can create components
using either classes or functions. Hooks were introduced in React 16.8...
```

✅ **After (Delta)**:
```
React SPA with TypeScript. Dev server: npm start (port 3000)
```

### Memory Hierarchy

```
Enterprise Policy (highest)       # Org-wide rules
       ↓
Project Memory (./CLAUDE.md)     # Project-specific
       ↓
User Memory (lowest)             # Personal preferences
```

Later tiers override earlier ones.

## Context Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_mode(project_state, conversation_context):
    claude_md_exists = exists("CLAUDE.md") or exists(".claude/CLAUDE.md")

    if not claude_md_exists:
        return "CREATE"  # Empty project
    elif conversation_context.has_recent_learnings():
        return "ACTIVE-LEARN"  # Mid-conversation insights
    elif analyze_quality(current_claude_md) < 75:
        return "REFACTOR"  # Needs optimization
    else:
        return "AUDIT"  # Existing good file
```

**Detection Logic**:
1. **No CLAUDE.md found** → **CREATE mode**
2. **Conversation has recent learnings** → **ACTIVE-LEARN mode**
3. **Existing CLAUDE.md with quality issues** → **REFACTOR mode**
4. **Existing good CLAUDE.md** → **AUDIT mode**

---

## When & Why to Use Each Workflow

### CREATE Workflow - Build from Scratch

**Use When:**
- Empty project (no CLAUDE.md exists anywhere)
- New repository being set up
- Team adopting CLAUDE.md for first time
- Project has no existing documentation

**Why:**
- Establishes baseline project memory
- Captures working commands immediately
- Prevents generic content from accumulating
- Sets Delta Standard from the start

**Required References:**
- `references/mode-detection.md#create-workflow` - Detailed CREATE process
- `references/quality-framework.md` - Ensure generated content meets standards

**For detailed examples**: [workflow-examples.md](references/workflow-examples.md)

---

### ACTIVE-LEARN Workflow - Capture Mid-Conversation Discoveries

**Use When:**
- Mid or end of development session
- Conversation revealed non-obvious patterns
- Working commands were discovered
- Gotchas or workarounds were found
- Architecture insights were uncovered
- Team wants to persist learnings

**Why:**
- Transforms ephemeral conversation into persistent memory
- Prevents rediscovering the same solutions
- Builds comprehensive project knowledge over time
- Enhances existing documentation with new insights

**Keywords Detected:**
- "discovered", "found", "learned", "solution", "workaround", "command that works"
- Problem-solution conversation patterns
- Architecture insights and dependencies
- Configuration quirks and gotchas

**For detailed examples**: [workflow-examples.md](references/workflow-examples.md)

---

### REFACTOR Workflow - Optimize Existing Documentation

**Use When:**
- CLAUDE.md score <75/100
- File >300 lines with poor structure
- Contains generic tutorials or obvious content
- Hard to update, lots of duplication
- Kitchen sink approach (everything included)
- Wants modularization to .claude/rules/

**Why:**
- Removes context rot and verbosity
- Applies Delta Standard filtering
- Improves maintainability
- Focuses on expert-level knowledge only
- Reduces cognitive load for future sessions

**Process:**
1. Score current CLAUDE.md against 7-dimension framework
2. Identify violations (generic content, duplication, etc.)
3. Apply Delta Standard (remove tutorials, keep specifics)
4. Modularize to .claude/rules/ if >300 lines
5. Validate no information loss

**Required References:**
- `references/delta-standard.md` - Complete refactoring methodology
- `references/quality-framework.md` - Target score ≥85/100

**For detailed examples**: [workflow-examples.md](references/workflow-examples.md)

---

### AUDIT Workflow - Assess Current State

**Use When:**
- Existing CLAUDE.md appears good (score ≥75)
- Want to understand current quality
- Need actionable recommendations
- Regular health check or monitoring
- Before making changes to understand baseline

**Why:**
- Provides objective quality assessment
- Identifies specific improvement areas
- Suggests optimal next actions
- Establishes baseline for tracking changes

**Score-Based Actions:**
- 90-100 (A): No action needed
- 75-89 (B): Minor improvements (REFACTOR optional)
- 60-74 (C): Significant issues (REFACTOR recommended)
- <60 (D/F): Major overhaul (REFACTOR required)

**For detailed examples**: [workflow-examples.md](references/workflow-examples.md)

---

## Quality Framework (7 Dimensions)

Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Delta Compliance** | 20 | Expert-only knowledge, no generic content |
| **2. Structure** | 15 | Clear organization, modular (@imports) |
| **3. Clarity** | 15 | Unambiguous, copy-paste ready |
| **4. Completeness** | 15 | Covers project-specific needs |
| **5. Commands/Workflows** | 10 | Documented operations |
| **6. Patterns & Gotchas** | 10 | Non-obvious knowledge |
| **7. Maintainability** | 15 | Easy updates, no redundancy |

**Quality Thresholds**:
- **A (90-100)**: Exemplary
- **B (75-89)**: Good
- **C (60-74)**: Adequate
- **D (40-59)**: Poor
- **F (0-39)**: Failing

---

## Quick Reference

### Success Criteria
- **CREATE**: ≥80/100 score
- **ACTIVE-LEARN**: +10 point improvement
- **REFACTOR**: ≥85/100 score
- **No duplication**: Single source of truth
- **Actionable**: Commands work, copy-paste ready
- **Delta Standard**: Project-specific only

### What Makes Great CLAUDE.md
**Key principles**:
- Concise and human-readable
- Actionable commands that can be copy-pasted
- Project-specific patterns, not generic advice
- Non-obvious gotchas and warnings

**Recommended sections** (use only what's relevant):
- Commands (build, test, dev, lint)
- Architecture (directory structure)
- Code Style (project conventions)
- Testing (commands, patterns)
- Gotchas (quirks, common mistakes)
- Workflow (when to do what)

---

## Reference Files

**For detailed guidance**:
- `references/quality-framework.md` - Complete 7-dimension scoring
- `references/mode-detection.md` - Context inference logic
- `references/active-learning.md` - Session integration patterns
- `references/delta-standard.md` - Refactoring methodology
- `references/workflow-examples.md` - Detailed workflow examples and templates
