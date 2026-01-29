---
name: planning-guide
description: "Planning philosophy, patterns, and practices for implementation planning. Use when planning features, architectural changes, or refactoring. Provides L'Entonnoir, 2-3 task rule, and verification practice. Not for execution - use native Plan agent with this guide for context."
---

# Planning Guide

**Philosophy and patterns for creating actionable implementation plans**

## What This Provides

This guide contains planning philosophy that the native Plan agent lacks:

- **L'Entonnoir (The Funnel)**: Iterative narrowing through recognition-based questions
- **2-3 Task Rule**: Quality-first planning with aggressive atomicity
- **Verification Practice**: Evidence-based planning with file:line claims
- **Plan Format**: Standard template for executable prompts

## Quick Start

**Apply planning philosophy for actionable implementation plans:**

1. **If you need scope definition:** Use L'Entonnoir → Ask recognition-based questions → Result: Clear boundaries
2. **If you need task breakdown:** Apply 2-3 task rule → Split if exceeds 3 → Result: Atomic, executable tasks
3. **If you need verification:** Trace actual code → Provide file:line evidence → Result: Evidence-based claims

**Why:** Quality-first planning with aggressive atomicity prevents scope creep and maintains peak quality throughout execution.

## L'Entonnoir (The Funnel) Pattern

**Iterative AskUserQuestion with exploration between each round:**

```
EXPLORE → ASK ONE → EXPLORE RESPONSE → NEW QUESTION (if needed) → ...
```

**How it works:**

1. **EXPLORE first** - Read files, analyze codebase, check git history
2. **INFER** - Try to infer answers from exploration
3. **ASK ONE** - ONE focused question with 2-4 recognition-based options
4. **EXPLORE RESPONSE** - Use tools to verify user's answer
5. **REPEAT** - If unclear, explore more, ask next focused question
6. **STOP** - Once scope is clear, execute without more questions

**Sequential focus:** Ask → Explore → Ask → Explore → STOP → Execute. Scattered questions reduce quality.

## Planning Principles

## Navigation

| If you need...        | Read...                                             |
| :-------------------- | :-------------------------------------------------- |
| Scope definition      | ## Quick Start → scope definition                   |
| Task breakdown        | ## Quick Start → task breakdown                     |
| Evidence-based claims | ## Quick Start → verification                       |
| L'Entonnoir pattern   | ## L'Entonnoir (The Funnel) Pattern                 |
| 2-3 task rule         | ## Planning Principles → Quality Over Consolidation |
| Plan format template  | See Plan Format Template section                    |

### Quality Over Consolidation

- Maximum 3 tasks per plan
- Plans are executable prompts, not documentation
- Each task must have clear completion criteria
- Dependencies and risks documented upfront

### The 2-3 Task Rule

**Every plan SHOULD contain 2-3 tasks maximum.**

**Why quality degrades with scope:**

| Context Position | Quality Level                              |
| ---------------- | ------------------------------------------ |
| Task 1 (0-15%)   | Peak quality, comprehensive                |
| Task 2 (15-35%)  | Still peak zone, quality maintained        |
| Task 3 (35-50%)  | Beginning pressure, natural stopping point |
| Task 4+ (50%+)   | DEGRADATION ZONE - quality crash           |

**Split when exceeding:** If a plan exceeds 50% context or has 4+ tasks, break it into multiple plans.

**Examples:**

```
❌ 08-01-PLAN.md: "Complete Authentication" (8 tasks, 80% context)
✅ 08-01-PLAN.md: "Auth Database Models" (2 tasks)
✅ 08-02-PLAN.md: "Auth API Core" (3 tasks)
✅ 08-03-PLAN.md: "Auth UI Components" (2 tasks)
```

**Aggressive atomicity:** More plans, smaller scope, consistent quality.

## Planning Process

### 1. Requirements Analysis

- Understand the feature request completely
- Ask ONE clarifying question if needed
- Identify success criteria
- List assumptions and constraints

### 2. Architecture Review

- Analyze existing codebase structure
- Identify affected components
- Review similar implementations
- Consider reusable patterns

### 3. Step Breakdown

Create detailed steps with:

- Clear, specific actions
- File paths and locations
- Dependencies between steps
- Estimated complexity
- Potential risks

**Multiple plans if needed:** If more than 3 tasks are needed, create multiple plans.

### 4. Implementation Order

- Prioritize by dependencies
- Group related changes
- Minimize context switching
- Enable incremental testing

## Plan Format Template

```markdown
# Implementation Plan: [Feature Name]

## Overview

[2-3 sentence summary]

## Requirements

- [Requirement 1]
- [Requirement 2]

## Architecture Changes

- [Change 1: file path and description]
- [Change 2: file path and description]

## Implementation Steps

### Phase 1: [Phase Name]

1. **[Step Name]** (File: path/to/file.ts)
   - Action: Specific action to take
   - Why: Reason for this step
   - Dependencies: None / Requires step X
   - Risk: Low/Medium/High

2. **[Step Name]** (File: path/to/file.ts)
   ...

### Phase 2: [Phase Name]

...

## Testing Strategy

- Unit tests: [files to test]
- Integration tests: [flows to test]
- E2E tests: [user journeys to test]

## Risks & Mitigations

- **Risk**: [Description]
  - Mitigation: [How to address]

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
```

## Verification Practice

- Always explore codebase before planning
- Trace actual patterns, never assume
- Provide specific file:line evidence for architectural decisions
- Mark claims as VERIFIED/INFERRED/UNCERTAIN

## Refactoring Planning

When planning refactors:

1. Identify code smells and technical debt
2. List specific improvements needed
3. Preserve existing functionality
4. Create backwards-compatible changes when possible
5. Plan for gradual migration if needed

## Red Flags to Check

- Large functions (>50 lines)
- Deep nesting (>4 levels)
- Duplicated code
- Missing error handling
- Hardcoded values
- Missing tests
- Performance bottlenecks

## Operational Patterns

This guide follows these behavioral patterns:

- **Planning**: Switch to planning mode for architectural work
- **Delegation**: Add guide context when delegating to specialized workers
- **Tracking**: Maintain a visible task list for planning phases

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

## Progressive Disclosure

**Tier 1: Quick Planning** (simple changes)

- Basic step breakdown
- File locations
- Testing checklist

**Tier 2: Detailed Planning** (complex features)

- Full architecture review
- Risk assessment
- Dependency mapping
- Rollback strategy

**Tier 3: Comprehensive Planning** (major refactors)

- Migration strategy
- Backwards compatibility
- Performance impact
- Documentation updates

---

<guiding_principles>

## The Path to High-Quality Planning Success

### 1. Sequential Focus Through L'Entonnoir

Focused questions with exploration between each round produce clearer scope than scattered questioning. Sequential focus maintains quality throughout the session.

### 2. Quality Through Aggressive Atomicity

Smaller, more numerous plans maintain peak quality. The 2-3 task rule recognizes that quality naturally degrades past the 50% context mark.

### 3. Evidence-Based Verification

Tracing actual code rather than assuming creates actionable plans. File:line evidence ensures implementation follows existing patterns.

### 4. Sequential Rather Than Scattered

Ask → Explore → Ask → Explore → STOP → Execute. This rhythm maintains focus and prevents quality drift.

</guiding_principles>

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
