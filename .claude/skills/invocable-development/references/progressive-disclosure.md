# Progressive Disclosure

> <fetch_protocol>
> For standard progressive disclosure → fetch https://agentskills.io/specification.md
>
> **Protocol Flow**:
>
> 1. DETECT: Does task involve skill structure or tier organization?
> 2. FETCH: `curl -s https://agentskills.io/specification.md`
> 3. EXTRACT: Verify current progressive disclosure tiers (Metadata ~100 tokens, Instructions <5000 tokens, Resources as needed)
> 4. IMPLEMENT: Apply current structure to local component
> 5. DISPOSE: Discard fetched content after implementation
>
> **Required from specification**: Three-tier progressive disclosure pattern, directory structure, file reference guidelines.
> </fetch_protocol>

---

This reference contains **Seed System-specific patterns** for progressive disclosure. The generic three-tier concept is covered in the Agent Skills specification.

---

## Seed System Tier Refinements

### Tier 1: Metadata Optimization

**WHAT + WHEN + NOT formula** for descriptions:

```
WHAT: Core capability (verb + object)
WHEN: Specific triggers and contexts
NOT: What this is NOT for (by behavior, not component name)
```

**Examples**:

| Poor               | Better                                                                                                                                        |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| "Helps with PDFs"  | "Extracts text and tables from PDF files. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction." |
| "Build components" | "Create portable, self-contained invocable components. Use when building commands or skills. Not for agents, hooks, or MCP servers."          |

**Key refinement**: Include "NOT" to prevent misuse. Describe by behavior, not by referencing other components.

---

### Tier 2: SKILL.md - Full Philosophy, Not Summaries

**CRITICAL DISTINCTION**: SKILL.md should contain the FULL philosophy and context, not just summaries. The AI needs direct access to the complete domain knowledge.

**What belongs in SKILL.md**:

- **Complete philosophy**: Delegation patterns, TDD requirements, domain principles
- **Full workflows**: End-to-end processes with all steps
- **Complete examples**: Not just links - working examples inline
- **Key patterns**: All important patterns with explanations
- **Why things work**: Rationale and reasoning, not just what

**~500 lines is a rule of thumb** - NOT enforced against contextualization and readability. If the content requires 600+ lines to be complete and readable, that's acceptable.

**Seed System recommended structure**:

```markdown
# Skill Name

<mission_control>
<objective>[What this achieves]</objective>
<success_criteria>[How to verify]</success_criteria>
</mission_control>

<trigger>When [condition]</trigger>

## Core Content

[Full philosophy, patterns, examples, explanations in Markdown]

## Navigation

**Local References**:

| If you need...           | Read...                |
| ------------------------ | ---------------------- |
| Ultra-situational lookup | references/specific.md |

## Genetic Code / Critical Constraints

<critical_constraint>
[Non-negotiable rules]
</critical_constraint>
```

**Key refinements**:

- UHP header (mission_control, trigger, interaction_schema)
- Semantic anchors (XML tags for control plane)
- Constraints in footer (recency bias)
- **Full content in SKILL.md** - Complete philosophy and patterns

---

### Tier 3: References/ - Ultra-Situational Only

**CRITICAL**: References/ is ONLY for ultra-situational information that the AI would need to look up occasionally. NOT for general philosophy.

**What belongs in references/**:

- **API specifications**: Endpoint details, field definitions, error codes
- **Code examples**: Ready-to-copy snippets for specific languages
- **Lookup tables**: Configuration options, flag values
- **Edge cases**: Detailed troubleshooting for specific scenarios
- **Domain-specific guides**: When skill supports multiple distinct domains

**What does NOT belong in references/**:

- General philosophy or principles
- Delegation patterns
- TDD requirements or methodology
- Best practices that apply generally
- "How to think about X" explanations

**Target 2-3 reference files** - This is a rule of thumb. Big libraries/APIs can have more, but prefer fewer organized files.

**Each reference MUST have "Use when" context** - Clear trigger at the top without spoiling the content:

```markdown
# Reference Title

Ultra-situational reference for X. Use when you need to look up Y.

---

[Detailed content starts immediately - no summary/intro]
```

**SKILL.md navigation pattern**:

```markdown
## Navigation

**Local References**:

| If you need...                   | Read...                       |
| -------------------------------- | ----------------------------- |
| API endpoint details, field defs | references/api-reference.md   |
| Ready-to-copy Python/Bash code   | references/code-examples.md   |
| Debugging stuck sessions         | references/troubleshooting.md |
```

---

## Implementation Examples

### Example 1: Philosophy in SKILL.md

**Tier 2** (SKILL.md - 400+ lines with full philosophy):

```markdown
# Jules API Integration

## Delegation Philosophy

**KEY PRINCIPLE**: Use Jules for async tasks to free Claude for strategic work.

### When to Delegate

Claude should proactively suggest Jules for:

| Task         | Example                                             |
| ------------ | --------------------------------------------------- |
| Code Reviews | "Review authentication changes in feature/auth"     |
| Refactoring  | "Refactor parser to use Polars for 10x performance" |

### Effective Delegation Patterns

**Pattern 1: Implement → Review**

1. Claude implements feature
2. Push branch to remote
3. Create Jules session: "Review and improve feature X"
4. Jules creates PR with improvements
5. Claude integrates feedback

[Full patterns with complete explanations...]

## TDD Requirement (Critical)

**IMPORTANT**: Always instruct Jules to use Test-Driven Development.

### Why TDD with Jules

- Ensures correctness before implementation
- Creates behavior-relevant tests (not implementation tests)
- Prevents regressions and edge cases

### What Are Behavior-Relevant Tests

Behavior-relevant tests validate **what** the code does, not **how** it does it.

[Complete TDD philosophy with examples...]

## Navigation

**Local References**:

| If you need...                   | Read...                     |
| -------------------------------- | --------------------------- |
| API endpoint details, field defs | references/api-reference.md |
| Ready-to-copy Python/Bash code   | references/code-examples.md |
```

**Tier 3** (references/):

- `api-reference.md` - Complete API specification, endpoints, fields
- `code-examples.md` - Working Python/Bash code snippets

**Key point**: The SKILL.md contains the FULL delegation philosophy, TDD requirements, and patterns. The references/ are ONLY for lookup material (API specs, code snippets).

---

### Example 2: Ultra-Situational Reference

**Reference file** (references/troubleshooting.md):

````markdown
# Troubleshooting

Debugging and resolving issues with Jules sessions. Use when a session is stuck in `AWAITING_USER_FEEDBACK` or `AWAITING_PLAN_APPROVAL` for an extended time, or when you need to understand what's blocking a session.

---

## Debugging Workflow

### Step 1: Check Session State

```python
response = httpx.get(
    f"{BASE_URL}/sessions/{session_id}",
    headers=headers
)
session = response.json()

print(f"State: {session['state']}")
print(f"Created: {session['createTime']}")
print(f"Updated: {session['updateTime']}")
```
````

**What to look for**:

- How long has session been in current state?
- When was last activity (`updateTime`)?

[Detailed troubleshooting content - no summaries, just actionable material...]

````

**Key point**: Clear "Use when" context, then immediately into detailed actionable content. No philosophy or general explanations.

---

## Anti-Patterns

### ❌ Philosophy in References

```markdown
# references/delegation-patterns.md

## Delegation Philosophy

Jules API enables asynchronous coding task delegation...
[300 lines of philosophy...]
````

**Problem**: This is general philosophy that belongs in SKILL.md. AI needs this every time.

**Fix**: Move to SKILL.md. Use references/ only for ultra-situational lookup.

---

### ❌ "Use when" Spoils Content

```markdown
# API Reference

Use when you need to look up the following endpoints:

- POST /sessions - Creates a new session
- GET /sessions/{id} - Gets session status
- DELETE /sessions/{id} - Deletes a session

## Session Resource

[Details...]
```

**Problem**: Lists all endpoints in "Use when", spoiling the content.

**Fix**:

```markdown
# API Reference

Complete reference for Jules API resources, endpoints, and operations. Use when you need to look up specific endpoint details, resource field definitions, or error codes.

---

## Base Configuration

[Details start immediately...]
```

---

### ❌ SKILL.md as Summary Only

```markdown
# SKILL.md (150 lines)

## Overview

Jules API enables async delegation. See [delegation-patterns.md](references/delegation-patterns.md) for details.

## TDD

Use TDD approach. See [tdd-guide.md](references/tdd-guide.md) for methodology.

[Only summaries, all content in references/]
```

**Problem**: AI must load multiple files to get full context. Defeats purpose of progressive disclosure.

**Fix**: Put full philosophy in SKILL.md. Use references/ only for ultra-situational lookup.

---

### ❌ Hard 500-Line Limit

```markdown
**Problem**: SKILL.md is 520 lines, exceeds 500 line limit.

**Fix**: Move content to references/ to get under 500 lines.
```

**Problem**: Enforces arbitrary limit against contextualization.

**Fix**:

```markdown
**Guideline**: SKILL.md is 520 lines, which is acceptable. The ~500 line target is a rule of thumb - readability and completeness take priority.
```

---

## Seed System Principles

- **Full philosophy in SKILL.md** - Complete patterns, workflows, rationale
- **References/ for ultra-situational** - API specs, code snippets, lookup tables
- **~500 lines is guideline** - Not enforced against contextualization
- **2-3 reference files typical** - Big libraries can have more
- **Each reference has "Use when"** - Clear context without spoiling content
- **One level deep** - References link directly from SKILL.md, no nesting
- **No duplication** - Information lives in SKILL.md OR references/, not both
- **UHP compliance** - XML for control, Markdown for data
- **Recency bias** - Constraints at bottom of files

---

## Summary

| Tier  | Purpose                              | Content                                   | Guideline                         |
| ----- | ------------------------------------ | ----------------------------------------- | --------------------------------- |
| **1** | Discovery & relevance                | What-When-Not description                 | ~100 tokens                       |
| **2** | Full philosophy, patterns, workflows | Complete domain knowledge                 | ~500 lines (flexible for context) |
| **3** | Ultra-situational lookup material    | API specs, code snippets, troubleshooting | 2-3 files (rule of thumb)         |

**Seed System additions**: UHP structure, semantic anchors, full philosophy in Tier 2, ultra-situational Tier 3 only, flexible line counts, clear "Use when" contexts.
