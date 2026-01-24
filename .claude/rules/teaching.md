# Teaching Skills Effectively

**How to Structure Knowledge for AI Agents**

This document teaches HOW to teach. Before writing a skill, understand these principles of effective knowledge transfer.

---

## What-When-Not Framework

Skill descriptions must signal WHAT/WHEN/NOT, not prescribe HOW.

### Component Parts

**WHAT**: What the skill does (core function)
**WHEN**: When to use it (triggers, contexts)
**NOT**: What it doesn't do (boundaries)

### Anti-Patterns

**❌ "Use to" language** (describes implementation):
```yaml
description: "Use to CREATE (new projects), REFACTOR (cleanup), or AUDIT (check quality)"
```

**❌ "How" language** (prescribes process):
```yaml
description: "This skill helps you CREATE skills by following a 6-step process..."
```

**❌ Vague triggers** (unclear when to activate):
```yaml
description: "A helpful skill for managing CLAUDE.md files"
```

### Best Practice

**✅ Describes WHAT + WHEN** (signals purpose):
```yaml
description: "Maintain CLAUDE.md project memory. Use when: new project setup, documentation is messy, conversation revealed insights"
```

**✅ Clear boundaries** (defines NOT):
```yaml
description: "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills. Not for general programming tasks or non-Claude contexts."
```

**✅ Specific triggers** (contextual activation):
```yaml
description: "API design patterns for this codebase. Use when writing API endpoints, modifying existing endpoints, or reviewing API changes."
```

### Recognition

**Bad description signals**:
- "Use to CREATE/REFACTOR/AUDIT" → Contains "how" language
- "This skill helps you..." → Describes process, not purpose
- "A tool for..." → Too vague, lacks context

**Good description signals**:
- Describes what + when → Core function + triggers
- Includes "NOT" or "Not for" → Defines boundaries
- Specific contexts → Clear activation scenarios

---

## Progressive Disclosure Patterns

From skill-creator: Three patterns for organizing complex knowledge.

### Pattern 1: High-Level Guide with References

**Use when**: Skill has basic usage + advanced features.

```markdown
# PDF Processing

## Quick start
Extract text with pdfplumber:
```python
import pdfplumber
pdfplumber.open('file.pdf').extract_text()
```

## Advanced features
- **Form filling**: See [FORMS.md](FORMS.md) for complete guide
- **API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
- **Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
```

**Benefit**: Claude loads FORMS.md, REFERENCE.md, or EXAMPLES.md only when needed.

### Pattern 2: Domain-Specific Organization

**Use when**: Skill supports multiple domains, frameworks, or variants.

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

**Benefit**: When user asks about sales metrics, Claude only loads sales.md.

**Similarly for framework variants**:
```
cloud-deploy/
├── SKILL.md (workflow + provider selection)
└── references/
    ├── aws.md (AWS deployment patterns)
    ├── gcp.md (GCP deployment patterns)
    └── azure.md (Azure deployment patterns)
```

### Pattern 3: Conditional Details

**Use when**: Basic content + advanced/situational features.

```markdown
# DOCX Processing

## Creating documents
Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents
For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

**Benefit**: Claude reads REDLINING.md or OOXML.md only when those features are needed.

### Guidelines

- **Avoid deeply nested references**: Keep references one level deep from SKILL.md
- **Structure longer files**: Include table of contents at top for >100 line reference files
- **Link clearly**: Describe when to read each reference file

---

## Example vs Principle Balance

### When to Use Examples

**Use examples when**:
- Output quality depends on seeing concrete patterns
- Style matters more than logic
- Format is non-obvious
- Multiple valid approaches exist

**Example format**:
```markdown
## Commit message format

Generate commit messages following these examples:

**Example 1:**
Input: Added user authentication with JWT tokens
Output:
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Example 2:**
Input: Fixed bug where dates displayed incorrectly in reports
Output:
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```
```

### When to Use Principles

**Use principles when**:
- Logic matters more than style
- Multiple approaches are valid
- Adaptation to context is important
- "How" is obvious, "why" is not

**Example format**:
```markdown
## Script Implementation

**When to include scripts**:
- Complex operations (>3-5 lines) needing determinism
- Reusable utilities called multiple times
- Performance-sensitive operations

**When to avoid scripts**:
- Simple 1-2 line operations (use native tools)
- Highly variable tasks (Claude's adaptability is valuable)
- One-time operations (don't automate the rare)

**Core principles**:
- **Solve, Don't Punt**: Handle errors explicitly
- **Avoid Magic Numbers**: Document configuration constants with rationale
- **Self-Contained**: Validate dependencies, document prerequisites
```

### Recognition

**Too prescriptive** (anti-pattern):
- "Step 1: Create directory. Step 2: Write file. Step 3: Add content."
- "Always use this exact template structure."

**Balanced** (best practice):
- "Location: .claude/skills/{name}/"
- "This pattern works well, but adapt to your context."
- "Trust your judgment based on the task complexity."

---

## Recognition: Over-Prescription

### Signs of Over-Prescription

**"How" heavy content**:
- "How to create X" in titles
- Numbered step sequences for obvious tasks
- "Always use this exact..."
- Detailed explanations of basic operations

**Recipe-style documentation**:
- First do X, then do Y, then do Z
- Follow these 7 steps
- Complete walkthrough of obvious workflows

**Micromanagement language**:
- "You must", "You shall", "Required"
- Blocking rules for non-critical operations
- Extensive validation of common patterns

### Convert to Principles

**From prescriptive**:
```markdown
## How to Create a Skill
1. Create .claude/skills/my-skill/ directory
2. Create SKILL.md with frontmatter
3. Add description with name and what it does
4. Write the skill content
5. Test the skill
6. Package the skill
```

**To principle-based**:
```markdown
## Skill Creation

**Location**: `.claude/skills/{name}/`

**Required**: SKILL.md with YAML frontmatter (name, description)

**Optional**: references/ for detailed content (create only when >500 lines total)

**Process**: Understand the domain → Plan content → Implement → Test

**You know**: How to create directories, write markdown, structure files. Focus on the WHAT (domain knowledge) not the HOW (file operations).
```

### Recognition Questions

**Ask yourself**:
- "Am I teaching WHAT or HOW?"
- "Is this obvious to an intelligent agent?"
- "Am I providing a recipe or principles?"
- "Could Claude infer this from context?"

**If the answer is "I'm teaching HOW" for obvious operations**: Convert to principles.

---

## Skill Evolution Guidance

Skills should evolve based on real usage, not hypothetical needs.

### Evolution Phases

**Phase 1: Initial Creation**
- Focus on core functionality
- Keep it minimal
- Trust AI intelligence for adaptation
- Don't over-engineer for hypothetical use cases

**Phase 2: Real Usage Feedback**
- Observe where struggles occur
- Note inefficient patterns
- Identify missing context
- Discover what users actually need

**Phase 3: Targeted Enhancement**
- Add examples for confusing areas
- Clarify ambiguous descriptions
- Add decision trees for complex choices
- Split content to references/ when >500 lines

**Phase 4: Iteration**
- Continue based on real usage
- Remove what doesn't help
- Simplify over time
- Trust principles, not plans

### Recognition

**Over-planning** (anti-pattern):
- Creating "for future use" content
- Adding features for hypothetical scenarios
- Building complex frameworks for simple needs
- "Just in case" documentation

**Evolutionary** (best practice):
- Start minimal, enhance based on evidence
- Remove what doesn't work
- Simplify as understanding grows
- "Just in time" documentation

---

## Learning Path Design

Structure knowledge for progressive understanding, not information dump.

### Learning Path Principles

**Start with WHY**: Philosophy before process
**Then WHAT**: Core concepts and purpose
**Then WHEN**: Contexts and triggers
**Then HOW**: Implementation details (when needed)
**Finally EXAMPLES**: Concrete illustrations (when style matters)

### Bad Learning Path

```markdown
# API Documentation

## Introduction
Welcome to the API documentation...

## How to Install
First, install Node.js...

## How to Configure
Edit the config file...

## How to Use
Call the endpoint like this...
```

**Problem**: Buries the WHY in HOW. User must read everything to understand purpose.

### Good Learning Path

```markdown
# API Conventions

## Overview (WHY)
This codebase uses RESTful API patterns with consistent response formats for reliability and client compatibility.

## Core Patterns (WHAT)
- Routes: `/api/{resource}` (plural)
- Methods: get{Resource}, create{Resource}, update{Resource}
- Response: `{ data, error, meta }` format

## When to Use (WHEN)
- New resources: Follow the resource template
- Modifying: Maintain existing patterns
- Breaking changes: Use versioning

## Response Format (HOW)
See [response-formats.md](references/response-formats.md)

## Examples (WHEN STYLE MATTERS)
See [examples.md](references/examples.md)
```

**Benefit**: User can stop after understanding WHAT/WHEN. HOW is available only when needed.

---

## Summary: Teaching Checklist

Before creating or updating a skill, verify:

### Description (Tier 1)
- [ ] Describes WHAT the skill does
- [ ] Describes WHEN to use it (specific contexts)
- [ ] Describes what it NOT does (boundaries)
- [ ] No "Use to CREATE/REFACTOR" language
- [ ] No "how to" in description

### Structure (Tier 2)
- [ ] Under 500 lines (or split to references/)
- [ ] Starts with WHY/WHAT (purpose)
- [ ] Then WHEN (contexts/triggers)
- [ ] Then HOW (only when non-obvious)
- [ ] Uses principles, not recipes

### References (Tier 3)
- [ ] Created only when SKILL.md + references >500 lines
- [ ] Linked from SKILL.md with clear "when to read"
- [ ] One level deep from SKILL.md (no nested references)
- [ ] Structured with table of contents if >100 lines

### Content Style
- [ ] Examples provided when style matters
- [ ] Principles provided when logic matters
- [ ] No step-by-step for obvious operations
- [ ] "Trust your judgment" language used appropriately
- [ ] Claude-obvious content removed

### Evolution
- [ ] Minimal initial version
- [ ] Enhanced based on real usage
- [ ] Over-engineering avoided
- [ ] Hypothetical features not included

**Remember**: You're teaching an intelligent agent. Provide principles, not prescriptions. Trust intelligence, don't micromanage.
