# Progressive Disclosure Guide

Tier 1/2/3 structure for skills with autonomy-first design.

---

## Tier Structure

### Tier 1: Metadata (~100 tokens)
**Always loaded** - Critical for auto-discovery

```yaml
---
name: skill-name
description: "Clear, actionable description with triggers"
user-invocable: true
---
```

### Tier 2: SKILL.md (<500 lines)
**Loaded on activation** - Core implementation

```markdown
# Skill Name

## Purpose
Deploys to staging with strict validation.

## When to Use
Trigger: "Deploy to staging"

## Workflows
1. `npm run validate:schema` (CRITICAL: Fast fail)
2. `./scripts/deploy.sh --staging`
3. Verify: `curl -I https://staging.api.com/health`
```

### Tier 3: references/ (on-demand)
**Loaded when needed** - Deep details

```
references/
├── detailed-guide.md
├── examples.md
└── troubleshooting.md
```

---

## Official Progressive Disclosure Patterns

From the official skill-creator, three proven patterns for organizing content:

### Pattern 1: High-level guide with references

```markdown
# PDF Processing

## Quick start
Extract text with pdfplumber:
[python code example]

## Advanced features
- **Form filling**: See [FORMS.md](FORMS.md) for complete guide
- **API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
- **Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
```

**Use when**: Simple quick-start + extensive optional documentation

### Pattern 2: Domain-specific organization

```markdown
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

**Use when**: Skill supports multiple domains or variants. Claude only loads relevant domain file.

### Pattern 3: Conditional details

```markdown
# DOCX Processing

## Creating documents
Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents
For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

**Use when**: Different workflows require different documentation paths.

**Key principles from official**:
- Keep references one level deep from SKILL.md
- Structure longer reference files (>100 lines) with table of contents
- Avoid duplication: Information lives in SKILL.md OR references/, not both
- Move detailed reference material, schemas, and examples to references files
- Keep only essential procedural instructions and workflow guidance in SKILL.md

---

## ASSESS Workflow

**Purpose**: Analyze progressive disclosure needs

**Process**:
1. Evaluate complexity
2. Suggest tier structure
3. Recommend autonomy level

---

## Quality Checklist

**Tier 1**:
- [ ] Name is descriptive
- [ ] Description is actionable
- [ ] Triggers are clear

**Tier 2**:
- [ ] Core knowledge included
- [ ] Step-by-step workflows
- [ ] Examples provided

**Tier 3**:
- [ ] Only loaded when needed
- [ ] Detailed documentation
- [ ] Specific scenarios

See also: autonomy-design.md, extraction-methods.md, quality-framework.md, ../../rules/positive-patterns.md
