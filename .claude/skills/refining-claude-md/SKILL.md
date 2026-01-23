---
name: refining-claude-md
description: "Optimize and streamline CLAUDE.md memory files. Use when files are too long, contain redundant content, or need restructuring. Applies Delta Standard filtering and modularization. Triggers: 'CLAUDE.md too long', 'remove redundant content', 'CLAUDE.md optimization', 'memory cleanup', 'refactor memory', 'CLAUDE.md streamlining', 'reduce file size'."
user-invocable: true
---

# Refining CLAUDE.md

Optimize project memory files using the Delta Standard and Context Engineering 2026 best practices.

## 🚨 MANDATORY: Read Before Refining

### Primary Documentation (MUST READ)
- **[MUST READ] Claude Code Memory**: https://code.claude.com/docs/en/memory
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  
- **[MUST READ] Context Engineering**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** without understanding memory hierarchy
- **DO NOT remove** content without analysis first

---

## Quick Start

### 1. Audit Current State
```bash
wc -l CLAUDE.md .claude/CLAUDE.md .claude/rules/*.md 2>/dev/null
grep -E "^##" CLAUDE.md | sort | uniq -c | sort -rn
```

### 2. Apply Delta Standard
For each section, ask:
- "Does Claude really need this explanation?" → Remove if obvious
- "Can I assume Claude knows this?" → Remove if basic
- "Does this paragraph justify its token cost?" → Condense if verbose

### 3. Restructure
- Move reusable rules to `.claude/rules/`
- Use `@imports` for modularity
- Keep CLAUDE.md focused on project-specific context

---

## Actions

### audit

**Analyzes CLAUDE.md** for optimization opportunities

**Workflow**:
1. Read CLAUDE.md and .claude/rules/*.md
2. Count lines, sections, redundancies
3. Identify deprecated references, dead code
4. Score against quality framework
5. Generate audit report

**Concrete Example**:
```bash
# User says: "Audit my CLAUDE.md"
# Skill automatically:
# 1. Reads CLAUDE.md (500 lines found)
# 2. Scans for redundancies (found 150 lines of generic content)
# 3. Identifies issues:
#    - Generic React tutorial (80 lines)
#    - Duplicate command documentation (30 lines)
#    - Outdated URL references (2 links)
# 4. Scores quality: 52/100
# 5. Generates report with actionable recommendations
```

**Output Contract**:
```
## CLAUDE.md Audit Report

### Metrics
- Total lines: {count}
- Sections: {count}
- Potential redundancies: {count}

### Issues Found
| Priority | Issue | Location | Recommendation |
|----------|-------|----------|----------------|
| HIGH | {issue} | Line {n} | {fix} |

### Quality Score: {score}/100
- Delta Compliance: {score}/20
- Structure: {score}/20
- Clarity: {score}/20
- Completeness: {score}/20
- Maintainability: {score}/20

### Next Steps
1. {action_1}
2. {action_2}
```

---

### refine

**Applies refinements** based on audit findings

**Workflow**:
1. Review audit findings (run audit first if needed)
2. Apply Delta Standard to each section
3. Condense verbose explanations
4. Remove deprecated content
5. Validate no information loss
6. Present diff for approval

**Autonomy Pattern**:
- Explore: Read all memory files before questions
- Apply: Standard refinements without asking
- Ask only when: Content removal could lose critical info

**Concrete Example**:
```bash
# Audit found: 52/100, needs refinement
# Skill automatically:
# 1. Removes 80 lines of generic React tutorial
# 2. Condenses 30 lines of duplicate commands to 8 lines
# 3. Fixes 2 outdated URLs
# 4. Creates diff for review:
#    - "React SPA with TypeScript"
#    - "Dev server: npm start (port 3000)"
# 5. Presents changes for approval
```

**Output Contract**:
```
## Refinement Applied: CLAUDE.md

### Changes Summary
- Lines removed: {count}
- Sections condensed: {count}
- Content moved to rules/: {count}

### Diff Preview
```diff
- [verbose section]
+ [concise version]
```

### Validation
- [ ] All sections still present
- [ ] No broken references
- [ ] Token reduction: {percentage}%
```

---

### modularize

**Extracts content** to `.claude/rules/` structure

**Workflow**:
1. Identify reusable rules (coding style, security, testing)
2. Create modular rule files with path-specific frontmatter
3. Update CLAUDE.md with `@imports`
4. Validate structure

**Concrete Example**:
```bash
# User says: "Modularize my 400-line CLAUDE.md"
# Skill automatically:
# 1. Identifies 3 modular sections:
#    - Coding standards (120 lines)
#    - Security policies (80 lines)
#    - Testing practices (60 lines)
# 2. Creates .claude/rules/ directory
# 3. Extracts sections to individual files
# 4. Updates CLAUDE.md with:
#    @import rules/coding-style
#    @import rules/security
#    @import rules/testing
# 5. Reduces CLAUDE.md from 400 to 140 lines
```

**Output Contract**:
```
## Modularization Complete

### Files Created
- .claude/rules/coding-style.md
- .claude/rules/security.md
- .claude/rules/testing.md

### CLAUDE.md Updated
- Added @imports for new rule files
- Reduced from {old} to {new} lines

### Structure
.claude/
├── CLAUDE.md (core context)
└── rules/
    ├── coding-style.md
    ├── security.md
    └── testing.md
```

---

## The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

### What to KEEP
- Project-specific decisions and rationale
- Non-obvious trade-offs
- Domain-specific patterns unique to this project
- "NEVER do X because [non-obvious reason]"
- Decision trees for complex choices

### What to REMOVE
- Generic explanations ("What is X")
- Standard library tutorials
- Common best practices ("write clean code")
- Definitions of industry terms
- Step-by-step for obvious operations

### Before → After Examples

❌ **Before (verbose)**:
```markdown
## PDF Processing
PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available for PDF processing, but we
recommend pdfplumber because it's easy to use and handles most cases well.
```

✅ **After (delta)**:
```markdown
## PDF Processing
Use pdfplumber for text extraction. For scanned PDFs, fall back to pytesseract OCR.
```

---

## Memory Hierarchy

```
┌────────────────────────────────────────┐
│  1. Enterprise Policy (highest)        │
│     /Library/Application Support/...   │
├────────────────────────────────────────┤
│  2. Project Memory                     │
│     ./CLAUDE.md OR ./.claude/CLAUDE.md │
├────────────────────────────────────────┤
│  3. User Memory (lowest)               │
│     ~/.claude/CLAUDE.md                │
└────────────────────────────────────────┘
```

**Key**: Later tiers override earlier ones.

---

## Detailed Guidance

**For best practices**: See [references/best-practices.md](references/best-practices.md)
**For refactoring steps**: See [references/refactoring-methodology.md](references/refactoring-methodology.md)
**For quality scoring**: See [references/quality-framework.md](references/quality-framework.md)
