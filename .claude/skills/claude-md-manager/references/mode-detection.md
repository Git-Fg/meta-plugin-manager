# How Each Workflow Works

Detailed explanation of each workflow approach and when to use them.

---

## Overview

The claude-md-manager skill uses automatic workflow selection. This document explains how each workflow operates.

---

## CREATE Workflow

### When to Use

- **Empty project**: No CLAUDE.md exists anywhere
- **New repository**: Freshly cloned or initialized
- **First-time setup**: Team adopting CLAUDE.md for first time

### How It Works

#### Step 1: Investigation

The skill scans the project to understand its structure:

```bash
# Basic file scan
ls -la

# Get project metadata
cat package.json  # Node.js projects
cat pyproject.toml  # Python projects
cat Cargo.toml  # Rust projects

# Find documentation
cat README.md
ls docs/ 2>/dev/null

# Identify tech stack
find . -name "*.config.*"  # Config files
find . -name "requirements.txt" -o -name "Pipfile" -o -name "poetry.lock"
find . -name "*.test.*" -type d  # Test directories
```

**What it learns**:
- Project name and description
- Programming language and framework
- Build system (npm, yarn, pip, etc.)
- Testing framework (Jest, pytest, etc.)
- Architecture structure

#### Step 2: Template Selection

Based on findings, it selects the best template:

| Project Type | Indicators | Template Used |
|--------------|-----------|--------------|
| **Web App** | React/Vue/Angular, package.json | Web App template |
| **API Backend** | Express/FastAPI, no frontend | API template |
| **Library** | package.json with "lib" in name | Library template |
| **CLI Tool** | bin/ directory, commander.js | CLI template |
| **Monorepo** | packages/ or apps/ directories | Monorepo template |

#### Step 3: Generation

It creates CLAUDE.md using actual project data:

```markdown
# {Project Name from package.json}
{Brief description from README}

## Quick Start
```bash
{install command from package.json}
{start command from package.json}
```

## Commands
| Command | Purpose |
|---------|---------|
| {script} | {description} |

## Architecture
{directory structure}
```

#### Step 4: Validation

- Checks score ≥80/100
- Verifies all commands are real
- Ensures no generic content

#### Step 5: Ask Location

**Question**: "Create CLAUDE.md in root (./CLAUDE.md) or .claude directory (.claude/CLAUDE.md)?"

**Recommendation**:
- **Root**: For public projects, team visibility
- **.claude/**: For private/internal projects

### Output

```
## CLAUDE.md Created

### Mode: CREATE
### Project Type: Web Application
### Quality Score: 84/100

### Sections
- Overview
- Commands
- Architecture
- Testing
```

### Success Criteria

- Quality score ≥80/100
- All commands verified
- No generic content
- Actionable instructions

---

## ACTIVE-LEARN Workflow

### When to Use

- **Mid-conversation discoveries**: Insights found during development
- **Problem-solving sessions**: Commands, workarounds, gotchas discovered
- **Learning capture**: Non-obvious knowledge uncovered
- **Session integration**: Want to persist learnings

### How It Works

#### Step 1: Learning Detection

The skill scans conversation for learning indicators:

**Keywords to detect**:
- "discovered", "found", "learned"
- "solution", "workaround", "fix"
- "command that works"
- "issue", "problem", "gotcha"

**Conversation pattern**:
```
User: [Problem description]
Claude: [Solution suggestion]
User: [Success confirmation]
```

#### Step 2: Extraction

For each potential learning:

1. **Identify type**:
   - Command discovery
   - Gotcha/workaround
   - Architecture insight
   - Configuration quirk

2. **Extract components**:
   - What was learned
   - When it applies
   - How to use it
   - Why it matters

#### Step 3: Gap Analysis

Compares learnings against existing CLAUDE.md:

- **Check duplication**: Is this already documented?
- **Find gaps**: Where does this fit?
- **Assess impact**: High/Medium/Low priority

#### Step 4: Integration

Adds learnings to appropriate sections:

```markdown
## Commands
- `npm run clean` - Clear cache when build fails

## Gotchas
- Tests fail in CI → Use `--runInBand` flag
- Build OOM → Set `NODE_OPTIONS="--max-old-space-size=4096"`

## Architecture
Auth depends on crypto initialized first (import order matters)
```

#### Step 5: Validation

- No duplication with existing content
- Delta Standard maintained
- Score improved by ≥10 points

### Example Workflow

```
Conversation:
User: The build is failing with strange errors
Claude: Try `npm run clean` first
User: That worked! What does it do?
Claude: Removes node_modules and reinstalls
User: Super helpful, didn't know about that command

Active-Learning Process:
1. Detected: Command discovery
2. Extracted: npm run clean command
3. Gap: Commands section exists but missing this
4. Integrated: Added to Commands section
5. Validated: Score improved
```

### Output

```
## Active Learning Integration

### Learnings Captured
- Command: npm run clean (cache clearing)
- Impact: Fixes build failures
- Added to: Commands section

### Quality Improvement: 58 → 87/100 (+29 points)
```

### Success Criteria

- Quality score improved ≥10 points
- No duplication
- All additions actionable
- Delta Standard maintained

---

## REFACTOR Workflow

### When to Use

- **Messy files**: >300 lines, poor structure
- **Quality issues**: Score <75/100
- **Generic content**: Tutorials, obvious explanations
- **Maintenance burden**: Hard to update, lots of duplication
- **Modularization needed**: File too large, should split

### How It Works

#### Step 1: Quality Assessment

Scores current CLAUDE.md:

```bash
# Count metrics
wc -l CLAUDE.md
grep -E "^##" CLAUDE.md | wc -l
grep -i "what is\|tutorial" CLAUDE.md | wc -l

# Score against framework
# Delta Compliance
# Structure
# Clarity
# Completeness
# Commands
# Patterns
# Maintainability
```

#### Step 2: Problem Identification

Common issues found:

1. **Kitchen sink**: Generic tutorials mixed with project-specific
2. **Instruction drift**: Rules no longer match codebase
3. **Duplicate content**: Same info in multiple places
4. **Wall of text**: No structure, hard to scan
5. **Missing context**: Commands without explanation

#### Step 3: Delta Standard Application

Removes generic content:

**Before**:
```markdown
## React
React is a JavaScript library for building user interfaces...
[200 lines of tutorial]
```

**After** (removed entirely):
```
[Content deleted - Claude already knows React basics]
```

Keeps project-specific content:

```markdown
## Commands
- `npm start` - Dev server (port 3000)
- `npm test` - Run tests

## Architecture
React SPA with TypeScript
```

#### Step 4: Modularization

If file >300 lines, splits into modules:

```markdown
# CLAUDE.md (core)
@import rules/coding-style
@import rules/testing
@import rules/deployment
```

Creates rule files:

```markdown
# .claude/rules/coding-style.md
- Use TypeScript strict mode
- Max component length: 200 lines
- Prefer hooks over class components
```

#### Step 5: Information Loss Check

Verifies critical knowledge retained:

- [ ] All commands still documented
- [ ] Architecture still explained
- [ ] Gotchas still captured
- [ ] No broken references
- [ ] All paths still valid

#### Step 6: Validation

- Score ≥85/100
- All @imports resolve
- Structure logical

### Example Workflow

```
Initial State:
- File: 580 lines
- Score: 32/100 (F grade)
- Issues: 80% generic content, no structure

Refactoring Process:
1. Assessment: Identified all problems
2. Categorized: Removed tutorials, kept project-specific
3. Condensed: 580 lines → 85 lines
4. Modularized: Extracted to .claude/rules/
5. Validated: Score 91/100 (A grade)

Result:
- Removed: 495 lines (86% reduction)
- Created: 3 modular rule files
- Improved: Score +59 points
```

### Output

```
## CLAUDE.md Refactored

### Quality: 32 → 91/100 (+59 points)

### Changes
- Lines removed: 495
- Generic content: 100% removed
- Modularized: 3 rule files created

### New Structure
.claude/
├── CLAUDE.md (85 lines, core context)
└── rules/
    ├── coding-style.md (135 lines)
    ├── testing.md (110 lines)
    └── deployment.md (95 lines)
```

### Success Criteria

- Quality score ≥85/100
- No information loss
- Delta Standard applied
- Modular structure

---

## AUDIT Workflow

### When to Use

- **Quality check**: Want to know current status
- **Assessment**: Before making changes
- **Monitoring**: Regular health check
- **Documentation**: Understanding what exists

### How It Works

#### Step 1: Read and Analyze

Reads entire CLAUDE.md:

```bash
# Check basic metrics
wc -l CLAUDE.md
grep -c "^##" CLAUDE.md
grep -c "@import" CLAUDE.md

# Validate content
grep -i "what is\|tutorial" CLAUDE.md  # Generic content
grep "@import" CLAUDE.md  # Check if imports resolve
```

#### Step 2: Score Against Framework

Evaluates each dimension:

1. **Delta Compliance** (20 pts)
2. **Structure** (15 pts)
3. **Clarity** (15 pts)
4. **Completeness** (15 pts)
5. **Commands** (10 pts)
6. **Patterns** (10 pts)
7. **Maintainability** (15 pts)

#### Step 3: Generate Report

Provides detailed assessment:

```
Quality: 72/100 (Grade: C)

Issues:
- Generic content: 30% (impact: -8 points)
- No @imports: Modular structure missing (impact: -5 points)
- Commands lack context: Missing port numbers (impact: -3 points)

Recommendations:
1. Apply Delta Standard (remove tutorials)
2. Modularize to .claude/rules/
3. Add context to commands

Suggested Mode: REFACTOR
```

#### Step 4: Suggest Action

Based on score:

| Score | Grade | Action | Mode |
|-------|-------|--------|------|
| 90-100 | A | None | - |
| 75-89 | B | Minor improvements | REFACTOR |
| 60-74 | C | Significant issues | REFACTOR |
| 40-59 | D | Major work needed | REFACTOR |
| <40 | F | Complete overhaul | REFACTOR |

### Output

```
## CLAUDE.md Audit Report

### Quality: 72/100 (Grade: C)

### Breakdown
- Delta Compliance: 12/20
- Structure: 10/15
- Clarity: 12/15
- Completeness: 10/15
- Commands: 7/10
- Patterns: 8/10
- Maintainability: 13/15

### Issues
1. [HIGH] Generic content (tutorials)
2. [MEDIUM] No modular structure
3. [LOW] Commands need more context

### Recommendations
1. Apply Delta Standard
2. Create .claude/rules/ structure
3. Add port numbers to commands

### Suggested Action
Mode: REFACTOR (score <75)
```

### Success Criteria

- Accurate assessment
- Actionable recommendations
- Clear next steps

---

## Decision Matrix

### Quick Selection

| Situation | Mode | Why |
|-----------|------|-----|
| No CLAUDE.md | CREATE | Build from scratch |
| File exists + learnings | ACTIVE-LEARN | Capture discoveries |
| File score <75 | REFACTOR | Optimize quality |
| File score ≥75 | AUDIT | Assess status |

### Edge Cases

**Multiple CLAUDE.md files**:
- Both `./CLAUDE.md` and `.claude/CLAUDE.md` exist
- Action: AUDIT both, ask user which to keep

**Very new conversation**:
- <10 messages, no learnings detected
- Action: Base on project state only

**Stale template**:
- File <50 lines with generic content
- Action: CREATE or REFACTOR (depends on quality)

---

## Performance Notes

### Detection Speed
- **File check**: <10ms
- **Quality score**: 100-500ms
- **Total**: <1 second

### Caching
- Quality scores cached 5 minutes
- Project state cached per directory
- Conversation context cached per session

---

## Success Metrics

| Workflow | Target | Measure |
|----------|--------|---------|
| CREATE | ≥80/100 | Quality score |
| ACTIVE-LEARN | +10 pts | Score improvement |
| REFACTOR | ≥85/100 | Quality score |
| AUDIT | N/A | Accurate assessment |
