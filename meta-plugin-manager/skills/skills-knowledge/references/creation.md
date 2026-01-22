# Skill Creation Guide

## Table of Contents

- [Overview](#overview)
- [Step 1: Design the Skill](#step-1-design-the-skill)
- [Step 2: Create Directory Structure](#step-2-create-directory-structure)
- [Step 3: Write SKILL.md](#step-3-write-skillmd)
- [What This Skill Does](#what-this-skill-does)
- [When to Use](#when-to-use)
- [Key Concepts](#key-concepts)
- [Implementation](#implementation)
- [Examples](#examples)
- [Additional Resources](#additional-resources)
- [Step 4: Add Supporting Files](#step-4-add-supporting-files)
- [Step 5: Test the Skill](#step-5-test-the-skill)
- [Step 6: Refine and Improve](#step-6-refine-and-improve)
- [Example: Creating API Review Skill](#example-creating-api-review-skill)
- [Checklist](#checklist)
- [Best Practices](#best-practices)
- [Example 1: Good REST Design](#example-1-good-rest-design)
- [Example 2: Error Response Format](#example-2-error-response-format)
- [Common Mistakes to Avoid](#common-mistakes-to-avoid)
- [Example](#example)
- [Progressive Disclosure Implementation](#progressive-disclosure-implementation)
- [Evaluation-Driven Development](#evaluation-driven-development)
- [Best Practices Summary](#best-practices-summary)
- [Next Steps](#next-steps)

Step-by-step guide for creating high-quality skills following 2026 best practices.

## Overview

Creating a skill involves:
1. **Design**: Define purpose, triggers, and structure
2. **Create**: Set up directory and write SKILL.md
3. **Enhance**: Add supporting files (references, scripts)
4. **Test**: Verify auto-discovery and functionality
5. **Refine**: Improve based on usage

## Step 1: Design the Skill

### Define Purpose
Answer these questions:
- What capability will this skill provide?
- What problem does it solve?
- Who will use it and when?

### Choose Type
- **Auto-discoverable**: For domain expertise
- **User-triggered**: For side-effect operations
- **Background**: For contextual knowledge

### Plan Triggers
What keywords will users say that should activate this skill?
- Include in description
- Make them natural and specific
- Avoid generic terms

### Structure Content
- What goes in SKILL.md (essentials)?
- What goes in references/ (detailed docs)?
- What goes in scripts/ (utilities)?

## Step 2: Create Directory Structure

### Basic Structure
```bash
mkdir -p .claude/skills/skill-name
```

### Full Structure (Optional)
```bash
mkdir -p .claude/skills/skill-name
mkdir -p .claude/skills/skill-name/references
mkdir -p .claude/skills/skill-name/scripts
```

### Directory Naming
- Use lowercase
- Use hyphens (not underscores)
- Match skill name in SKILL.md
- Keep concise but descriptive

**Good**: `api-review`, `security-audit`
**Bad**: `api_review_skill`, `SecurityReview`

## Step 3: Write SKILL.md

### YAML Frontmatter

Required fields:
```yaml
---
name: skill-name              # Lowercase, hyphens, ≤64 chars
description: "WHAT + WHEN + NOT"  # ≤1024 chars
---
```

Optional fields:
```yaml
---
name: skill-name
description: "WHAT + WHEN + NOT"
disable-model-invocation: true    # User-triggered only
user-invocable: false             # Background only
argument-hint: [arg1] [arg2]      # If accepting arguments
allowed-tools: Read, Bash(git:*)  # Restrict tools
context: fork                     # Use subagent
agent: Explore                    # Subagent type
---
```

### Description Formula

**WHAT + WHEN + NOT**

```yaml
# Good example
description: "Extract text and tables from PDF files. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction. Do not use for scanned images without OCR."

# Bad example
description: "Helps with PDFs"
```

### Body Structure

Recommended sections:
```markdown
# Skill Name

## What This Skill Does
[Clear description of capability]

## When to Use
[Triggers and conditions]

## Key Concepts
[Core concepts]

## Implementation
[Step-by-step instructions]

## Examples
[Usage examples]

## Additional Resources
- [Link to reference files]
```

### Writing Style

**Use imperative form**:
```markdown
# Good
Extract text from the PDF

# Bad
You should extract text from the PDF
```

**Use third-person description**:
```yaml
# Good
description: "Extracts text from PDF files"

# Bad
description: "I can help you extract text from PDFs"
```

## Step 4: Add Supporting Files

### References Directory
For detailed documentation:

```bash
# Create reference file
echo "# Detailed Reference" > references/detailed.md

# Link from SKILL.md
See [references/detailed.md](references/detailed.md) for complete guide.
```

### Scripts Directory
For executable utilities:

```bash
# Create script
cat > scripts/validate.sh << 'EOF'
#!/bin/bash
# Validation script
echo "Validating..."
EOF

chmod +x scripts/validate.sh
```

Link from SKILL.md:
```markdown
Run validation script:
```bash
./scripts/validate.sh
```
```

## Step 5: Test the Skill

### Test Auto-Discovery
1. Invoke skill directly: `/skill-name`
2. Test with trigger keywords
3. Verify it appears in `/help`

### Test with Arguments (if applicable)
```bash
/skill-name argument1 argument2
```

### Test User-Triggered Skills
```bash
/skill-name
# Should work even if auto-discovery doesn't trigger
```

## Step 6: Refine and Improve

### Checklist for Refinement

#### Structural
- [ ] SKILL.md under 500 lines
- [ ] Description follows WHAT+WHEN+NOT formula
- [ ] Tier 3 content moved to references/
- [ ] All links work correctly

#### Content
- [ ] Clear purpose and scope
- [ ] Specific triggers and conditions
- [ ] Actionable instructions
- [ ] Concrete examples
- [ ] Complete coverage of use cases

#### Quality
- [ ] Autonomy: Completes 80-95% without questions
- [ ] Discoverability: Clear description triggers
- [ ] Standards: Follows Agent Skills specification
- [ ] Security: Appropriate tool restrictions

## Example: Creating API Review Skill

### Step 1: Design
- **Purpose**: Help review API designs
- **Type**: Auto-discoverable
- **Triggers**: "API design", "REST endpoints", "API review"
- **Structure**: Main checklist in SKILL.md, examples in references/

### Step 2: Create Structure
```bash
mkdir -p .claude/skills/api-review
mkdir -p .claude/skills/api-review/references
```

### Step 3: Write SKILL.md
```yaml
---
name: api-review
description: "API design review patterns for this codebase. Use when designing, reviewing, or modifying API endpoints. Do not use for GraphQL or gRPC APIs."
---

# API Review

When reviewing API endpoints:

## Checklist
- [ ] RESTful naming conventions
- [ ] Consistent error formats
- [ ] Request validation implemented
- [ ] Response schemas documented
- [ ] Authentication documented
- [ ] Rate limiting in place
- [ ] Pagination for lists

## Best Practices
1. Use nouns for resources
2. Pluralize resource names
3. Use HTTP verbs appropriately
4. Return meaningful status codes
5. Include pagination for lists

See [references/examples.md](references/examples.md) for detailed examples.
```

### Step 4: Add References
```bash
cat > references/examples.md << 'EOF'
# API Review Examples

## Example 1: Good REST Design

```http
GET /api/users
POST /api/users
GET /api/users/{id}
PUT /api/users/{id}
DELETE /api/users/{id}
```

## Example 2: Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Email format is invalid",
    "details": {
      "field": "email",
      "value": "invalid-email"
    }
  }
}
```
EOF
```

### Step 5: Test
```bash
# Test auto-discovery
/API design for user management
# Should trigger api-review skill

# Test manual invocation
/api-review
# Should work
```

## Common Mistakes to Avoid

### 1. Too Generic Descriptions
```yaml
# Bad
description: "Helps with coding"

# Good
description: "API design review patterns for REST endpoints"
```

### 2. No Clear Triggers
```yaml
# Bad
description: "Security best practices"

# Good
description: "Security review checklist for web applications. Use when reviewing code for OWASP Top 10 vulnerabilities."
```

### 3. Too Much Content in SKILL.md
```yaml
# Bad
# SKILL.md contains 800 lines of detailed documentation

# Good
# SKILL.md has essentials (100 lines)
# references/detailed.md has full documentation
```

### 4. Missing Examples
```markdown
# Bad
Follow best practices for API design.

# Good
## Example
GET /api/users - List all users
POST /api/users - Create a new user
```

### 5. No Testing
Always test:
- Auto-discovery with trigger keywords
- Manual invocation
- Argument handling (if applicable)
- Link validity

## Progressive Disclosure Implementation

### Tier 1: Metadata (~100 tokens)
```yaml
---
name: skill-name
description: "WHAT + WHEN + NOT"
---
```

### Tier 2: SKILL.md (<500 lines)
- Quick reference
- Key concepts
- Essential workflows
- Links to detailed docs

### Tier 3: references/ and scripts/
- Detailed documentation
- Examples
- Troubleshooting
- Utilities

### Example Structure
```
api-review/
├── SKILL.md (150 lines) - Quick reference
├── references/
│   ├── examples.md (200 lines) - Detailed examples
│   ├── common-issues.md (150 lines) - Troubleshooting
│   └── patterns.md (100 lines) - Advanced patterns
└── scripts/
    └── validate-api.sh - Validation utility
```

## Evaluation-Driven Development

### Create Evaluations First
Before writing extensive documentation:

1. **Identify gaps**: Run Claude without skill, note failures
2. **Create evaluations**: Build 3 scenarios that test gaps
3. **Establish baseline**: Measure performance without skill
4. **Write minimal instructions**: Address gaps directly
5. **Iterate**: Execute evaluations, refine

### Evaluation Structure
```json
{
  "skills": ["api-review"],
  "query": "Review this API design for best practices",
  "files": ["api/design.md"],
  "expected_behavior": [
    "Checks RESTful naming conventions",
    "Validates error response format",
    "Verifies authentication documentation"
  ]
}
```

## Best Practices Summary

### DO ✅
- Use WHAT+WHEN+NOT in descriptions
- Include specific trigger keywords
- Keep SKILL.md under 500 lines
- Move details to references/
- Test auto-discovery
- Use concrete examples
- Follow progressive disclosure
- Write in imperative form

### DON'T ❌
- Don't use generic descriptions
- Don't skip testing
- Don't put everything in SKILL.md
- Don't forget examples
- Don't ignore progressive disclosure
- Don't use vague triggers
- Don't skip validation

## Next Steps

After creating your skill:
1. See **[audit.md](audit.md)** for quality evaluation
2. See **[patterns.md](patterns.md)** for refinement patterns
3. Test with real usage scenarios
4. Gather feedback and iterate
