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

See also: autonomy-design.md, extraction-methods.md, quality-framework.md
