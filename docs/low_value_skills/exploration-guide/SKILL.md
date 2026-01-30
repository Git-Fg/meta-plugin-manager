---
name: exploration-guide
description: "Enable evidence-based codebase exploration through systematic verification. Use PROACTIVELY when exploring unknown codebases, mapping architecture, or discovering patterns. Not for implementation tasks. Keywords: explore, verify, evidence, patterns, architecture."
---

<mission_control>
<objective>Enable evidence-based codebase exploration through systematic verification and structured reporting</objective>
<success_criteria>Exploration complete with verified patterns, documented evidence, and actionable findings</success_criteria>
</mission_control>

## Quick Start

**Pattern discovery:** Glob → Grep → Read → Verify

**Architecture mapping:** Start broad → Drill down → Connect relationships

**Conclusions:** Mark confidence (VERIFIED/INFERRED/UNCERTAIN) → Provide file:line evidence

## Navigation

| If you need... | Read... |
| :--- | :--- |
| Verification practice | ## PATTERN: Verification Practice |
| Tool selection | ## PATTERN: Tool Selection |
| Quality checks | ## PATTERN: Quality Checks |
| Common mistakes | ## ANTI-PATTERN: Common Mistakes |
| Output format | ## Output Format |

## PATTERN: Verification Practice

**Core principle:** Always trace actual logic, never trust grep results alone.

| Marker | Meaning |
| :--- | :--- |
| **✅ VERIFIED** | Read the file, traced the logic |
| **? INFERRED** | Based on grep/search, needs verification |
| **❌ UNCERTAIN** | Haven't checked, must investigate |

**Anti-hallucination rules:**
- Grep ≠ Evidence: Finding pattern ≠ understanding code
- Read before claiming: Always read the actual file
- Mark confidence: VERIFIED/INFERRED/UNCERTAIN
- Provide file:line: Evidence for every conclusion

## PATTERN: Tool Selection

| Task | Tool | Example |
| :--- | :--- | :--- |
| Find files by pattern | Glob | `**/*.test.ts` |
| Find content in files | Grep | `^class\\s+\\w+` |
| Examine specific file | Read | Full content verification |
| Run commands | Bash | Git, npm, system ops |
| Complex multi-step | Task/Explore agent | Architecture mapping |

## PATTERN: Systematic Exploration

1. **Start broad** - Understand overall structure
2. **Identify patterns** - Find recurring structures
3. **Drill down** - Explore specific areas
4. **Connect dots** - Understand relationships
5. **Document findings** - Create comprehensive report

## PATTERN: Quality Checks

Before completing exploration:
- [ ] Directory structure mapped
- [ ] Key patterns identified
- [ ] Conventions documented
- [ ] Questions answered with evidence (file:line)
- [ ] Confidence markers applied (VERIFIED/INFERRED/UNCERTAIN)
- [ ] Report is comprehensive and actionable

## ANTI-PATTERN: Common Mistakes

| Mistake | Wrong | Correct |
| :--- | :--- | :--- |
| Trust grep | "Found 50 matches, pattern exists" | "Read auth.ts:47-89, traced logic" |
| Empty = absence | "No results found" | Check directory/extension variations |
| Wrong naming | "auth.ts not found" | Search alternatives: login.ts, user.ts |
| Comments = code | "Found TODO, feature exists" | "TODO exists, no implementation" |
| No confidence | "Auth is implemented this way" | "✅ VERIFIED: Read file, traced logic" |

## Output Format

```markdown
# Codebase Exploration Report

## Overview
[High-level description]

## Project Structure
[Directory tree or structure description]

## Key Patterns Discovered

### [Pattern Name]
**Purpose:** What this accomplishes
**Locations:** Where it's used
**Example:** [code snippet]

## Conventions
- File naming: [kebab-case|camelCase|PascalCase|snake_case]
- Code style: [indentation, organization]

## Questions Answered

### Q: [Question]
**Answer:** [Detailed answer]
**Evidence:** file:line references
**Confidence:** VERIFIED/INFERRED/UNCERTAIN
```

## Recognition Questions

| Question | Check |
| :--- | :--- |
| Did you trace actual logic? | VERIFIED markers used, no grep-only claims |
| Did you mark confidence levels? | VERIFIED/INFERRED/UNCERTAIN applied |
| Is every claim evidenced? | file:line references for all findings |
| Is the report actionable? | Someone could act on findings |

---

<critical_constraint>
**Portability**: Zero external dependencies. Works standalone.
**Verification**: Always read files before claiming; provide file:line evidence.
</critical_constraint>
