---
name: skill-architect
description: "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills with progressive disclosure and autonomy-first design. Not for general programming tasks."
user-invocable: true
---

# Skill Architect

## Core Philosophy

### The Delta Standard
> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

**Trust Your Intelligence**: You understand skill architecture. These are high-value patterns from successful implementations, not rigid rules.

## Skill Structure Patterns

### Pattern 1: Auto-Discoverable Skills
Claude uses these when relevant. User can invoke via `/name`.

**Example**:
```yaml
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing API endpoints, modifying existing endpoints, or reviewing API changes."
---

# API Conventions

## Location
API endpoints: `src/api/{resource}.ts`

## Naming Pattern
- Routes: `/api/{resource}` (plural)
- Methods: get{Resource}, create{Resource}, update{Resource}, delete{Resource}
- Parameters: interface based, validated

## Response Format
Standard: `{ data, error, meta }`

See [api-response-format.md](references/api-response-format.md) for complete guide.
```

### Pattern 2: User-Triggered Workflows
Only user can invoke via `/name`. Use for side-effects, timing-critical, or destructive actions.

**Example**:
```yaml
---
name: deploy
description: "Deploy application to production"
disable-model-invocation: true
argument-hint: [environment]
---

# Deploy

Deploy current branch to specified environment.

**Environments**:
- staging: Deploys to staging.example.com
- production: Deploys to example.com (requires approval)

**Process**:
1. Verify all tests pass
2. Build production artifacts
3. Deploy with zero-downtime
4. Verify deployment health
```

### Pattern 3: Background Context Skills
Only Claude uses. Hidden from `/` menu. Use for context that enhances understanding.

**Example**:
```yaml
---
name: legacy-system-context
description: "Explains the legacy authentication architecture"
user-invocable: false
---

# Legacy Authentication System

This system uses JWT tokens with RSA-256 signatures.

**Key Points**:
- Tokens expire after 24 hours
- Refresh tokens valid for 30 days
- Legacy API uses different token format

**Migration Path**: See [auth-migration.md](references/auth-migration.md)
```

## Progressive Disclosure Patterns

### Tier 1: Metadata (~100 tokens)
**Purpose**: Trigger discovery, convey WHAT/WHEN/NOT

**Example**:
```yaml
---
name: database-queries
description: "Database query patterns and performance best practices for PostgreSQL. Use when writing queries, optimizing performance, or reviewing database code."
user-invocable: false
---
```

### Tier 2: Core Implementation (<500 lines)
**Purpose**: Enable task completion

**Example Structure**:
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

### Tier 3: References (on-demand)
**Purpose**: Deep details without cluttering Tier 2

**When to create**: SKILL.md + references >500 lines total

**Example**:
```
references/
├── advanced-usage.md (specialized scenarios)
├── troubleshooting.md (common issues)
├── examples.md (style guide)
└── integration.md (how it works with other skills)
```

## High-Value Examples

### Example 1: What-When-Not Descriptions

**Good** (signals purpose):
```yaml
description: "API design patterns for this codebase. Use when writing API endpoints, modifying existing endpoints, or reviewing API changes."
```

**Avoid** (describes implementation):
```yaml
description: "Use to CREATE APIs by following these steps..."
```

### Example 2: Autonomy-First Design

**High autonomy** (completes 80-95% without questions):
```yaml
---
name: security-validator
description: "Validate code for security issues using OWASP patterns"
---

# Security Validator

Scan code for common security vulnerabilities:

1. **Input Validation**
   - Check all user inputs are validated
   - Look for SQL injection patterns
   - Verify XSS prevention

2. **Authentication & Authorization**
   - Verify all endpoints require auth
   - Check for privilege escalation
   - Validate session management

3. **Data Protection**
   - Verify encryption at rest
   - Check for hardcoded secrets
   - Validate secure transmission

Generate security report with findings and remediation steps.
```

**Pattern**: Provide the "what" and examples, let Claude execute intelligently.

### Example 3: Context Fork Skills

**When isolation is beneficial**:

```yaml
---
name: codebase-analyzer
description: "Analyze codebase for architectural patterns and quality metrics"
context: fork
agent: Explore
---

Analyze $ARGUMENTS:
1. Scan all source files
2. Identify architectural patterns
3. Calculate complexity metrics
4. Generate comprehensive report

This creates noise, but isolation prevents context bloat.
```

### Example 4: Hub-and-Spoke Orchestration

**Hub skill** (orchestrates):
```yaml
---
name: project-auditor
description: "Orchestrate comprehensive project audit"
disable-model-invocation: true
---

# Project Auditor

Coordinate multi-phase audit:

1. Scan architecture
2. Validate security
3. Check performance
4. Generate report

See individual audit skills for detailed patterns.
```

**Worker skills** (isolated execution):
```yaml
---
name: security-audit
description: "Deep security analysis in isolated context"
context: fork
agent: Explore
---

Conduct security audit of $ARGUMENTS:
1. Analyze authentication patterns
2. Check for vulnerabilities
3. Review permissions
4. Generate security report
```

## Quality Patterns

### Excellence Indicators

**A-grade skills**:
- Clear What-When-Not description
- Self-sufficient (80-95% autonomy)
- Progressive disclosure implemented
- High knowledge delta (expert-only)
- Concrete examples where style matters

**Anti-patterns to avoid**:
- Command wrapper anti-pattern
- Non-self-sufficient (requires constant hand-holding)
- Context fork misuse
- Over-prescriptive workflows
- Generic tutorials mixed with specific patterns

### Autonomy Testing

**How to assess**:
```bash
# Test skill execution
claude --dangerously-skip-permissions -p "Use skill-name" \
  --output-format stream-json \
  > test-output.json

# Check for permission denials
grep '"permission_denials":\s*\[\]' test-output.json && echo "100% autonomy"
```

**Target**: 0-3 questions (85-100% autonomy)

## High-Value Learning Examples

### Example: Transforming Prescriptive to Example-Based

**Instead of** (prescriptive):
```markdown
Step 1: Create directory
Step 2: Write YAML frontmatter
Step 3: Add description
Step 4: Write implementation
Step 5: Add examples
```

**Use** (example-based):
```markdown
## Skill Creation Pattern

**Location**: `.claude/skills/{name}/`

**Required**:
- SKILL.md with YAML frontmatter (name, description)

**Optional**:
- references/ for detailed content (create only when >500 lines total)

**Example Structure**:
```
.skill-name/
├── SKILL.md (required)
└── references/ (optional)
    ├── detailed.md
    └── examples.md
```

Trust your judgment on organization and structure.
```

## Trust Your Intelligence

You understand:
- How to structure projects
- When to use progressive disclosure
- How to write clear descriptions
- When isolation (context: fork) helps
- How to design for autonomy

**Focus on**: Expert knowledge specific to this domain, not generic instructions.

## Reference Files

Load these as needed:

- **[skill-types.md](references/skill-types.md)** - Skill types with examples
- **[progressive-disclosure.md](references/progressive-disclosure.md)** - Tier structure patterns
- **[autonomy-design.md](references/autonomy-design.md)** - High-autonomy examples
- **[quality-framework.md](references/quality-framework.md)** - Quality assessment patterns
- **[description-guidelines.md](references/description-guidelines.md)** - What-When-Not examples
- **[patterns.md](references/patterns.md)** - Common patterns and anti-patterns

## Official Documentation

**Primary reference** (verify when accuracy matters):
- https://code.claude.com/docs/en/skills - Claude Code Skills
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview - Agent Skills API
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices - Best Practices

**See**: best-practices guide for complete authoring guidance including naming conventions, workflows, and anti-patterns.

## SKILL_ARCHITECT_COMPLETE

**What was accomplished**:
- Skill architecture guidance provided
- High-value patterns demonstrated
- Examples showed excellence
- Anti-patterns identified

**Your turn**: Apply these patterns intelligently to create, evaluate, or enhance skills.
