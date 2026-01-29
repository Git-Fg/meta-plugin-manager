---
name: exploration-guide
description: "Exploration philosophy, verification practice, and tool selection patterns. Use when exploring codebases, discovering patterns, or mapping architecture. Provides evidence-based conclusions and output standards. Not for execution - use native Explore agent with this guide for context."
---

# Exploration Guide

**Philosophy and patterns for systematic codebase exploration**

## What This Provides

This guide contains exploration philosophy that the native Explore agent lacks:

- **Verification Practice**: Trace logic, mark claims, provide evidence
- **Output Standards**: Structured reports with file:line evidence
- **Tool Selection Heuristics**: When to use Glob vs Grep vs Read
- **Quality Checks**: Pre-completion checklist for thorough exploration

## Quick Start

**Apply exploration philosophy for evidence-based codebase analysis:**

1. **If you need pattern discovery:** Use Glob for files → Grep for content → Read for verification → Result: Verified patterns
2. **If you need architecture mapping:** Start broad → Drill down → Connect relationships → Result: Complete map
3. **If you need conclusions:** Mark confidence (VERIFIED/INFERRED/UNCERTAIN) → Provide file:line evidence → Result: Actionable report

**Why:** Verification practice prevents hallucination—always trace actual logic, never trust grep results alone.

## Native Exploration Agent

Claude Code includes a native exploration specialist. Delegate investigation work with context from this guide:

```
Delegate to exploration specialist with [question] + exploration-guide.md
```

**Use native Explore for:**

- Pattern discovery across codebase
- Architecture mapping
- File location queries
- Convention identification

**Use this guide for:**

- Philosophy of verification practice
- Output quality standards
- Evidence-based conclusions
- Tool selection heuristics

## Navigation

| If you need...             | Read...                                           |
| :------------------------- | :------------------------------------------------ |
| Pattern discovery          | ## Quick Start → pattern discovery                |
| Architecture mapping       | ## Quick Start → architecture mapping             |
| Evidence-based conclusions | ## Quick Start → conclusions                      |
| Verification practice      | ## What This Provides → Verification Practice     |
| Tool selection             | ## What This Provides → Tool Selection Heuristics |
| Native Explore usage       | ## Native Exploration Agent                       |

## Verification Practice

The core principle: **always trace actual logic, never trust grep results alone.**

### Confidence Markers

Use these markers to signal certainty:

| Marker          | Meaning                                          |
| --------------- | ------------------------------------------------ |
| **✓ VERIFIED**  | Read the file, traced the logic. Safe to assert. |
| **? INFERRED**  | Based on grep/search. Needs verification.        |
| **✗ UNCERTAIN** | Haven't checked. Must investigate.               |

### Anti-Hallucination Rules

1. **Grep ≠ Evidence**: Finding a pattern in search ≠ understanding the code
2. **Read before claiming**: Always read the actual file
3. **Mark confidence**: VERIFIED/INFERRED/UNCERTAIN
4. **Provide file:line**: Evidence for every conclusion

### Common Failure Modes

- Trusting grep results without reading files
- Finding patterns in comments ≠ finding implementations
- Empty search = wrong directory/extension, not absence
- Different naming conventions hide matches

## Exploration Principles

### Systematic Approach

1. **Start broad** - Understand overall structure
2. **Identify patterns** - Find recurring structures
3. **Drill down** - Explore specific areas
4. **Connect dots** - Understand relationships
5. **Document findings** - Create comprehensive report

### Tool Selection Heuristics

| Task                  | Tool               | Reason                    |
| --------------------- | ------------------ | ------------------------- |
| Find files by pattern | Glob               | Faster, permission-aware  |
| Find content in files | Grep               | Line numbers, context     |
| Examine specific file | Read               | Full content, line ranges |
| Run commands          | Bash               | Git, npm, system ops      |
| Specialized search    | Task/Explore agent | Complex multi-step        |

### Targeted Questions

Good exploration questions:

- "Where is authentication implemented?"
- "How are tests organized?"
- "What database layer exists?"
- "How are APIs structured?"
- "What build tools are used?"

## Tool Usage Patterns

### Glob

Use for finding files and directories:

```
Glob: "**/*.test.ts"        // All test files
Glob: "src/**/*"            // All files in src
Glob: "**/{component,service}/*"  // Component and service directories
Glob: "**/package.json"     // Package.json files
```

### Grep

Use for finding patterns in code:

```
Grep: "^class\\s+\\w+"       // Class definitions
Grep: "^interface\\s+\\w+"   // Interface definitions
Grep: "^function\\s+\\w+"    // Function definitions
Grep: "^import\\s+.*from"    // Import statements
Grep: "^export\\s+\\w+"      // Export statements
```

Use options:

- `-n` for line numbers
- `-A` for after context
- `-B` for before context

### Read

Use for examining specific files:

- Read full files for understanding
- Use line ranges for focused analysis
- Trace logic flow, don't skim

### Bash

Use for:

- Git operations (log, diff, status)
- File counting and statistics
- System commands unavailable via MCP

## Output Format

Structure exploration findings as:

````markdown
# Codebase Exploration Report

## Overview

[High-level description of project structure and purpose]

## Project Structure

[Directory tree or structure description]

## Key Patterns Discovered

### [Pattern Name]

**Purpose:** What this pattern accomplishes
**Locations:** Where it's used
**Example:**

```typescript
// Code example here
```
````

## Conventions

### File Naming

- Pattern: [kebab-case|camelCase|PascalCase|snake_case]
- Examples: [file1, file2, file3]

### Code Style

- Indentation: [spaces|tabs]
- Naming: [convention used]
- Organization: [how code is structured]

## Questions Answered

### Q: [Question]

**Answer:** [Detailed answer with evidence]
**Evidence:**

- File: `path/to/file.ts:line`
- Pattern found: [what was found]
- Location: [where it is]
- Confidence: [VERIFIED|INFERRED|UNCERTAIN]

## Architecture

### Layers Identified

1. **[Layer Name]** - [purpose]
   - Location: `path/`
   - Key files: `file1`, `file2`

2. **[Layer Name]** - [purpose]
   - Location: `path/`
   - Key files: `file1`, `file2`

### Dependencies

- **External:** [list key external dependencies]
- **Internal:** [list key internal modules]

## Quality Checklist

- [ ] Directory structure mapped
- [ ] Key patterns identified
- [ ] Conventions documented
- [ ] Specific questions answered
- [ ] Evidence provided for claims
- [ ] Confidence markers applied
- [ ] Report is comprehensive and actionable

```

## Quality Checks

Before completing exploration:

- [ ] Directory structure mapped
- [ ] Key patterns identified
- [ ] Conventions documented
- [ ] Specific questions answered
- [ ] Evidence provided for claims (file:line)
- [ ] Confidence markers applied (VERIFIED/INFERRED/UNCERTAIN)
- [ ] Report is comprehensive and actionable

## Operational Patterns

This guide follows these behavioral patterns:

- **Discovery**: Locate files matching patterns and search file contents for exploration
- **Delegation**: Add guide context when delegating to specialized workers
- **Tracking**: Maintain a visible task list for exploration questions
- **Examination**: Examine file contents for detailed analysis

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

---

## Genetic Code

This component carries essential Seed System principles for context fork isolation:

<critical_constraint>
**System Physics:**

1. Zero external dependencies for portable components
2. Description uses What-When-Not-Includes format in third person
3. Progressive disclosure - core in SKILL.md, details in references/
4. XML for control (mission_control, critical_constraint), Markdown for data
</critical_constraint>

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

<critical_constraint>
PHASE 1: Execute this phase first. Rename agents to guides before other changes.
```
