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

### Tier 2: Structure Template

**Seed System recommended structure** (beyond spec basics):

```markdown
# Skill Name

<mission_control>
<objective>[What this achieves]</objective>
<success_criteria>[How to verify]</success_criteria>
</mission_control>

<trigger>When [condition]</trigger>

## Core Content

[Patterns, examples, explanations in Markdown]

## Reasoning Process

<interaction_schema>
thinking → planning → execution → output
</interaction_schema>

---

## Absolute Constraints

<critical_constraint>
[Non-negotiable rules]
</critical_constraint>
```

**Key refinements**:

- UHP header (mission_control, trigger, interaction_schema)
- Semantic anchors (XML tags for control plane)
- Constraints in footer (recency bias)

---

### Tier 3: Seed System Reference Patterns

**Domain-specific organization**:

```
skill-name/
├── SKILL.md (overview and navigation)
└── references/
    ├── domain-1.md (specific use cases)
    ├── domain-2.md (variant workflows)
    └── advanced.md (complex scenarios)
```

**SKILL.md navigation pattern**:

````markdown
## Domain-Specific Guides

**Domain 1**: See [domain-1.md](references/domain-1.md)
**Domain 2**: See [domain-2.md](references/domain-2.md)

## Quick Search

```bash
grep -i "keyword" references/*.md
```
````

````

---

## Implementation Examples

### Example 1: Well-Organized Skill

**Tier 1** (YAML):
```yaml
---
name: security-validator
description: "Validate code for security issues using OWASP patterns. Use when reviewing code, testing, or auditing security."
user-invocable: true
---
````

**Tier 2** (SKILL.md - 200 lines):

```markdown
# Security Validator

## What This Does

Scans code for common security vulnerabilities using OWASP Top 10 patterns.

## When to Use

- Code reviews
- Security audits
- Before deployments
- After adding new features

## Key Patterns

1. **Input Validation**
   - Check all user inputs are validated
   - Look for SQL injection patterns
   - Verify XSS prevention

2. **Authentication & Authorization**
   - Verify all endpoints require auth
   - Check for privilege escalation
   - Validate session management

## Examples

See [security-examples.md](references/security-examples.md) for detailed scan examples.
See [owasp-guide.md](references/owasp-guide.md) for OWASP Top 10 patterns.
```

**Tier 3** (references/):

- `security-examples.md` - Detailed scan examples
- `owasp-guide.md` - OWASP Top 10 reference
- `remediation-guide.md` - How to fix findings

---

### Example 2: Domain-Specific Organization

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

**SKILL.md**:

````markdown
# BigQuery Analytics

## Domain-Specific Guides

**Finance metrics**: See [finance.md](references/finance.md)
**Sales analytics**: See [sales.md](references/sales.md)
**Product data**: See [product.md](references/product.md)
**Marketing campaigns**: See [marketing.md](references/marketing.md)

## Quick Search

```bash
grep -i "revenue" references/*.md
grep -i "pipeline" references/*.md
```
````

````

**Use when**: Skill supports multiple domains or variants. Claude only loads relevant domain file.

---

## Anti-Patterns

### ❌ Too Much in Tier 1
```yaml
---
name: security-validator
description: "This skill validates code for security issues using OWASP patterns including but not limited to A01 Broken Access Control, A02 Cryptographic Failures, A03 Injection, A04 Insecure Design, A05 Security Misconfiguration, A06 Vulnerable Components, A07 Identity Failures, A08 Software Integrity, A09 Logging Failures, A10 Server-Side Request Forgery..."
---
````

**Problem**: Too long, not scannable

**Fix**:

```yaml
---
name: security-validator
description: "Validate code for security issues using OWASP Top 10 patterns. Use when reviewing code, testing, or auditing security."
---
```

---

### ❌ Too Much in Tier 2

```markdown
# Security Validator (600 lines)

## OWASP Top 10 Details

[A01 detailed... detailed...]
[10 sections of detailed explanations...]

## Remediation Examples

[100 examples...]
```

**Problem**: Too long, overwhelming

**Fix**: Move detailed content to Tier 3 references

---

### ❌ Unnecessary Tier 3

```markdown
# Simple Skill (50 lines)

## What This Does

Simple description...

See [basic-usage.md](references/basic-usage.md)
```

**Problem**: Creates unnecessary file, no value

**Fix**: Keep simple content in Tier 2

---

## Seed System Principles

- **One level deep**: References should link directly from SKILL.md, no nested references
- **No duplication**: Information lives in SKILL.md OR references/, not both
- **Structure long files**: Add table of contents for references >100 lines
- **Link clearly**: Describe when to read each reference file
- **UHP compliance**: Use XML tags for control plane, Markdown for data
- **Recency bias**: Place constraints at bottom of files

---

## Summary

| Tier  | When Loaded   | Purpose               | Spec Standard |
| ----- | ------------- | --------------------- | ------------- |
| **1** | Always        | Discovery & relevance | ~100 tokens   |
| **2** | On invocation | Core implementation   | <5000 tokens  |
| **3** | On demand     | Deep details          | Unlimited     |

**Seed System additions**: UHP structure, semantic anchors, domain-specific organization, WHAT+WHEN+NOT formula, recency bias constraints.
