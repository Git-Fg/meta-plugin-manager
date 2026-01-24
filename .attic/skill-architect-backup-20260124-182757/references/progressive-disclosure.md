# Progressive Disclosure

Organize information across three tiers to manage cognitive load and improve discoverability.

## Three Tiers

### Tier 1: Metadata (~100 tokens)
**Always loaded** - Claude's first impression

**Purpose**:
- Trigger discovery
- Convey WHAT/WHEN/NOT
- Help Claude decide if relevant

**Content**:
```yaml
---
name: skill-name
description: "WHAT + WHEN + NOT formula"
user-invocable: true/false
---
```

**Example**:
```yaml
---
name: database-queries
description: "Database query patterns and performance best practices for PostgreSQL. Use when writing queries, optimizing performance, or reviewing database code."
user-invocable: false
---
```

**Key principle**: ~100 tokens maximum. If longer, it's not Tier 1.

### Tier 2: Core Implementation (<500 lines)
**Loaded when skill is invoked**

**Purpose**:
- Enable task completion
- Provide core knowledge
- Show high-value examples

**Structure**:
```markdown
# Skill Name

## What This Does
[2-3 sentences on core purpose]

## When to Use
[Specific triggers and contexts]

## Key Patterns
[High-value examples]

## Quality Standards
[What good looks like]

## Examples
[Concrete examples when style matters]

See [detailed-reference.md](references/detailed-reference.md) for comprehensive guide.
```

**Rule**: Keep under 500 lines. If approaching limit, move content to Tier 3.

### Tier 3: References (on-demand)
**Loaded when specifically needed**

**Purpose**:
- Deep details without cluttering Tier 2
- Specialized scenarios
- Troubleshooting
- Comprehensive guides

**When to create**:
- SKILL.md + references >500 lines total
- Content used <20% of the time
- Detailed explanations that would bloat Tier 2

**Example structure**:
```
references/
├── advanced-usage.md (specialized scenarios)
├── troubleshooting.md (common issues)
├── examples.md (style guide)
└── integration.md (how it works with other skills)
```

## Implementation Examples

### Example 1: Well-Organized Skill

**Tier 1** (YAML):
```yaml
---
name: security-validator
description: "Validate code for security issues using OWASP patterns. Use when reviewing code, testing, or auditing security."
user-invocable: true
---
```

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

### Example 2: Avoiding Bloat

**Bad** (everything in Tier 2):
```markdown
# Security Validator (800 lines)

## What This Does
[...]

## OWASP Top 10
### A01:2021 - Broken Access Control
[Detailed explanation...]
### A02:2021 - Cryptographic Failures
[Detailed explanation...]
[...10 more detailed sections...]

## Remediation Examples
[50 examples...]

## Testing Strategies
[100 lines...]

## Advanced Patterns
[200 lines...]
```

**Good** (progressive disclosure):
```markdown
# Security Validator (200 lines)

## What This Does
[...]

## Key Patterns
1. **Input Validation** - Check user inputs...
2. **Authentication** - Verify auth requirements...

## Examples
Simple scan example...

See [owasp-guide.md](references/owasp-guide.md) for OWASP Top 10 details.
See [remediation.md](references/remediation.md) for fix examples.
See [advanced.md](references/advanced.md) for complex scenarios.
```

## When to Create Tier 3

### Create Tier 3 When:
- SKILL.md is approaching 500 lines
- Content used <20% of the time
- Detailed explanations clutter core message
- Multiple specialized use cases exist
- Troubleshooting details needed

### Keep in Tier 2 When:
- Content used frequently
- Essential for task completion
- Core patterns and examples
- Quality standards
- Common use cases

## Anti-Patterns

### ❌ Too Much in Tier 1
```yaml
---
name: security-validator
description: "This skill validates code for security issues using OWASP patterns including but not limited to A01 Broken Access Control, A02 Cryptographic Failures, A03 Injection, A04 Insecure Design, A05 Security Misconfiguration, A06 Vulnerable Components, A07 Identity Failures, A08 Software Integrity, A09 Logging Failures, A10 Server-Side Request Forgery..."
---
```
**Problem**: Too long, not scannable

### ❌ Too Much in Tier 2
```markdown
# Security Validator (600 lines)

## OWASP Top 10 Details
[A01 detailed... detailed...]
[10 sections of detailed explanations...]

## Remediation Examples
[100 examples...]

## Testing Strategies
[200 lines of testing details...]
```
**Problem**: Too long, overwhelming

### ❌ Unnecessary Tier 3
```markdown
# Simple Skill (50 lines)

## What This Does
Simple description...

See [basic-usage.md](references/basic-usage.md)
```
**Problem**: Creates unnecessary file, no value

## Quick Decision Tree

**Is content used <20% of the time?**
- Yes → Tier 3
- No → Tier 2

**Is SKILL.md approaching 500 lines?**
- Yes → Move some content to Tier 3
- No → Keep in Tier 2

**Would content help Claude decide if skill is relevant?**
- Yes → Tier 1 (description)
- No → Tier 2 or 3

**Is this essential for task completion?**
- Yes → Tier 2
- Maybe → Tier 3

## Summary

| Tier | When Loaded | Purpose | Size |
|------|-------------|---------|------|
| 1 | Always | Discovery & relevance | ~100 tokens |
| 2 | On invocation | Core implementation | <500 lines |
| 3 | On demand | Deep details | Unlimited |

**Principle**: Reveal complexity progressively, not all at once.
