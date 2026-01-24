# Subagent Configuration Guide

Complete guide to subagent frontmatter fields, valid configurations, and anti-patterns.

---

## Overview

Subagents are configured using YAML frontmatter in `.md` files. This guide covers all valid fields, proper usage patterns, and common mistakes to avoid.

---

## Valid Frontmatter Fields

### name (Required)
**Purpose**: Unique identifier for the subagent

**Requirements**:
- Must be unique across all subagents
- No spaces (use hyphens)
- Descriptive of agent's purpose

**Valid Examples**:
```yaml
---
name: code-review-agent
name: deploy-automation
name: database-migration-helper
```

**Invalid Examples**:
```yaml
# ❌ Spaces not allowed
name: "code review agent"

# ❌ Too generic
name: "agent"

# ❌ Duplicate
name: "code-review-agent"  # Already exists
```

---

### description (Required)
**Purpose**: When to delegate to this subagent

**Requirements**:
- Clear, actionable description
- Specific use cases
- Trigger conditions

**Template**:
```
description: "[Purpose] when [situation]. Use for [specific tasks]."
```

**Valid Examples**:
```yaml
---
description: "Reviews code changes for security vulnerabilities when PRs are created. Analyzes diffs for common security issues, hardcoded secrets, and unsafe patterns."
---
description: "Automates deployment workflow when deploying to production. Handles build verification, environment checks, and deployment execution."
---
description: "Migrates database schemas when schema changes are detected. Generates migration scripts and validates schema compatibility."
---
```

**Invalid Examples**:
```yaml
# ❌ Too vague
description: "Helps with code"

# ❌ Just repeats name
description: "Code review agent for reviewing code"

# ❌ No use case
description: "Uses advanced AI to analyze things"
```

---

### model (Optional)
**Purpose**: Specify which Claude model to use

**Valid Values**:
- `sonnet` - For complex reasoning tasks
- `opus` - For most advanced capabilities
- `haiku` - For fast, simple tasks
- `inherit` - Use same model as parent

**Valid Examples**:
```yaml
---
model: haiku  # Fast for simple tasks
model: sonnet  # Good balance for most tasks
model: opus  # For complex analysis
model: inherit  # Use parent's model
---
```

**Usage Guidelines**:
- Use `haiku` for routine automation
- Use `sonnet` for code review, analysis
- Use `opus` for complex reasoning
- Use `inherit` to save costs

---

### tools (Optional)
**Purpose**: Restrict which tools the subagent can use (allowlist)

**Valid Syntax**:
```yaml
---
tools:
  - Read
  - Grep
  - Bash
---
```

**Available Tools**:
- Read, Write, Edit, Glob
- Bash, WebSearch, WebFetch
- Grep, FileSearch
- And others

**Valid Examples**:
```yaml
# Security-focused agent (read-only)
---
tools:
  - Read
  - Grep
---

# Deployment agent (build and execute)
---
tools:
  - Bash
  - Read
  - Glob
---

# Analysis agent (search and read)
---
tools:
  - Read
  - Grep
  - Glob
  - WebSearch
---
```

---

### disallowedTools (Optional)
**Purpose**: Explicitly deny specific tools (denylist)

**Valid Syntax**:
```yaml
---
disallowedTools:
  - Write
  - Edit
  - Bash
---
```

**Valid Examples**:
```yaml
# Read-only agent
---
disallowedTools:
  - Write
  - Edit
---

# No system modifications
---
disallowedTools:
  - Bash
  - Write
  - Edit
---

# Analysis only
---
disallowedTools:
  - Write
  - Edit
  - Bash
  - None
---
```

---

### permissionMode (Optional)
**Purpose**: Control permission handling

**Valid Values**:
- `default` - Standard permission handling
- `safe` - Enhanced permission checking
- `unsafe` - Bypass permission prompts (not recommended)

**Valid Examples**:
```yaml
---
permissionMode: default  # Standard
permissionMode: safe  # Enhanced safety
---

# Inherit from parent
permissionMode: inherit
```

**Usage Guidelines**:
- Use `default` for most cases
- Use `safe` for security-critical agents
- Avoid `unsafe` unless absolutely necessary

---

### skills (Optional)
**Purpose**: Inject skill content into subagent's context

**Valid Syntax**:
```yaml
---
skills:
  - skills-knowledge
  - claude-md-manager
---

# With specific version
---
skills:
  - skills-knowledge@latest
  - hooks-knowledge@v2.0
---
```

**Valid Examples**:
```yaml
# Agent that needs skill knowledge
---
skills:
  - skills-knowledge
---

# Agent with multiple skills
---
skills:
  - skills-knowledge
  - hooks-knowledge
  - mcp-knowledge
---

# Custom skill path
---
skills:
  - ../skills/custom-skill
---
```

**Usage Guidelines**:
- Use for subagents that need skill expertise
- List only necessary skills
- Use latest versions

---

### hooks (Optional)
**Purpose**: Lifecycle hooks for subagent execution

**Valid Syntax**:
```yaml
---
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate.sh"
  PostToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./scripts/log-write.sh"
---
```

**Valid Examples**:
```yaml
# Validate commands before execution
---
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/guard-commands.sh"
---

# Log all operations
---
hooks:
  PostToolUse:
    - matcher: {"tool": "Read"}
      hooks:
        - type: command
          command: "./scripts/log-read.sh"
---

# Cleanup after execution
---
hooks:
  SubagentStop:
    - type: command
      command: "./scripts/cleanup.sh"
---
```

---

## Complete Configuration Examples

### Example 1: Code Review Agent
```yaml
---
name: code-review-agent
description: "Reviews code changes for security vulnerabilities when PRs are created. Analyzes diffs for common security issues, hardcoded secrets, and unsafe patterns."
model: sonnet
disallowedTools:
  - Write
  - Edit
  - None
permissionMode: safe
skills:
  - skills-knowledge
---
```

**Use Case**: Analyzes pull requests for security issues without modifying code

---

### Example 2: Deployment Agent
```yaml
---
name: deploy-automation
description: "Automates deployment workflow when deploying to production. Handles build verification, environment checks, and deployment execution."
model: haiku
tools:
  - Bash
  - Read
  - Grep
permissionMode: safe
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate-env.sh"
---
```

**Use Case**: Automates deployment with environment validation

---

### Example 3: Database Migration Agent
```yaml
---
name: db-migration-helper
description: "Generates and validates database migrations when schema changes are detected. Creates safe migration scripts with rollback support."
model: sonnet
tools:
  - Read
  - Grep
  - Bash
disallowedTools:
  - Write
permissionMode: safe
skills:
  - skills-knowledge
---
```

**Use Case**: Generates migration scripts without executing them

---

### Example 4: Log Analysis Agent
```yaml
---
name: log-analyzer
description: "Analyzes application logs for errors and anomalies when logs are provided. Identifies patterns, error rates, and potential issues."
model: haiku
disallowedTools:
  - Write
  - Edit
  - Bash
---

# Simple, read-only log analysis
```

**Use Case**: Analyzes logs without making changes

---

## Invalid Fields (Don't Use)

### context: fork
**Why Invalid**: This is for **skills**, not subagents
```yaml
# ❌ WRONG
---
name: my-agent
context: fork  # This field doesn't exist
---

# ✅ CORRECT - Use subagent properly
---
name: my-agent
description: "Does X when Y"
---
```

---

### agent: Explore
**Why Invalid**: This field doesn't exist
```yaml
# ❌ WRONG
---
name: my-agent
agent: Explore  # This field doesn't exist
---

# ✅ CORRECT - Use model instead
---
name: my-agent
model: haiku  # Or sonnet/opus/inherit
---
```

---

### user-invocable
**Why Invalid**: Subagents aren't directly user-invocable
```yaml
# ❌ WRONG
---
name: my-agent
user-invocable: true  # This field doesn't exist

# Subagents are invoked by skills, not directly by users
---

# ✅ CORRECT - Subagents are for delegation
---
name: my-agent
description: "Use this when you need X"
---
```

---

### disable-model-invocation
**Why Invalid**: Not a subagent field
```yaml
# ❌ WRONG
---
name: my-agent
disable-model-invocation: true  # This field doesn't exist
---

# ✅ CORRECT - Let subagent use model
---
name: my-agent
model: haiku  # Or inherit to use parent's model
---
```

---

## Anti-Patterns

### Anti-Pattern 1: All Tools Allowed
```yaml
# ❌ BAD - No restrictions
---
name: powerful-agent
description: "Can do everything"
# No tools or disallowedTools specified
---

# ✅ GOOD - Restrict appropriately
---
name: code-review-agent
disallowedTools:
  - Write
  - Edit
---
```

### Anti-Pattern 2: Vague Description
```yaml
# ❌ BAD - Not actionable
---
name: helper-agent
description: "Helps with various tasks"
---

# ✅ GOOD - Specific use case
---
name: deploy-verifier
description: "Verifies deployment readiness when deploying to production"
---
```

### Anti-Pattern 3: Wrong Field Names
```yaml
# ❌ BAD - Using skill fields
---
name: my-agent
user-invocable: true
context: fork
---

# ✅ GOOD - Subagent fields only
---
name: my-agent
description: "Use when you need X"
model: haiku
---
```

### Anti-Pattern 4: Missing Required Fields
```yaml
# ❌ BAD - Missing description
---
name: my-agent
model: sonnet
---

# ✅ GOOD - All required fields present
---
name: my-agent
description: "Use when you need X"
model: sonnet
---
```

---

## Best Practices

### 1. Be Specific
```yaml
# ✅ GOOD - Specific description
---
name: security-scanner
description: "Scans code for OWASP Top 10 vulnerabilities when security review is requested"
---

# ❌ BAD - Too general
---
name: security-agent
description: "Helps with security"
---
```

### 2. Restrict Tools Appropriately
```yaml
# ✅ GOOD - Read-only for analysis
---
name: log-analyzer
disallowedTools:
  - Write
  - Edit
  - Bash
---

# ✅ GOOD - Minimal tools for deployment
---
name: deploy-agent
tools:
  - Bash
  - Read
---
```

### 3. Use Appropriate Model
```yaml
# ✅ GOOD - Fast for routine tasks
---
name: log-aggregator
model: haiku
---

# ✅ GOOD - Complex reasoning for analysis
---
name: security-analyzer
model: sonnet
---
```

### 4. Add Hooks for Safety
```yaml
# ✅ GOOD - Validate before execution
---
name: deploy-agent
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate-env.sh"
---
```

### 5. Document Complex Workflows
```yaml
# ✅ GOOD - Clear description with workflow
---
name: migration-orchestrator
description: "Orchestrates database migrations when schema changes detected. Workflow: 1) Generate migration, 2) Review with team, 3) Execute in staging, 4) Deploy to production"
model: sonnet
---

# Include workflow steps in description for clarity
```

---

## Field Combinations

### Safe Read-Only Agent
```yaml
---
name: analyzer-agent
description: "Analyzes [X] when [situation]"
disallowedTools:
  - Write
  - Edit
  - Bash
  - None
permissionMode: safe
---
```

### Deployment Automation
```yaml
---
name: deploy-agent
description: "Deploys [X] when deployment requested"
model: haiku
tools:
  - Bash
  - Read
permissionMode: safe
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/guard-deploy.sh"
---
```

### Code Review Specialist
```yaml
---
name: code-review-agent
description: "Reviews [X] for [Y] when PR created"
model: sonnet
disallowedTools:
  - Write
  - Edit
permissionMode: safe
skills:
  - skills-knowledge
---
```

### Complex Task Agent
```yaml
---
name: workflow-orchestrator
description: "Orchestrates [complex workflow] when [trigger]"
model: sonnet
tools:
  - Read
  - Grep
  - Bash
permissionMode: safe
skills:
  - skills-knowledge
  - hooks-knowledge
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

---

## Validation Checklist

Before creating a subagent, verify:

- [ ] **name** is unique and descriptive
- [ ] **description** clearly states when to use
- [ ] **model** is appropriate for task complexity
- [ ] **tools** or **disallowedTools** restricts appropriately
- [ ] **permissionMode** is set (default/safe)
- [ ] **skills** are injected if needed
- [ ] **hooks** are configured for safety
- [ ] No invalid fields used
- [ ] All required fields present
- [ ] YAML syntax is valid

---

## Common Mistakes

### Mistake 1: Copying Skill Patterns
```yaml
# ❌ WRONG - Using skill fields
---
name: my-agent
user-invocable: true
context: fork
---

# ✅ CORRECT - Subagent pattern
---
name: my-agent
description: "Use this when you need X"
model: haiku
---
```

### Mistake 2: No Tool Restrictions
```yaml
# ❌ WRONG - No restrictions
---
name: powerful-agent
description: "Can do anything"
---

# ✅ CORRECT - Appropriate restrictions
---
name: analysis-agent
disallowedTools:
  - Write
  - Edit
---
```

### Mistake 3: Unclear Purpose
```yaml
# ❌ WRONG - Unclear
---
name: helper
description: "Helps with things"
---

# ✅ CORRECT - Clear
---
name: deployment-verifier
description: "Verifies deployment readiness before production deployment"
---
```

### Mistake 4: Wrong Model Choice
```yaml
# ❌ WRONG - Overpowered for simple task
---
name: simple-log-reader
model: opus  # Too expensive for simple reading
---

# ✅ CORRECT - Appropriate model
---
name: simple-log-reader
model: haiku  # Fast and cheap for simple tasks
---
```

---

## Quick Reference

| Field | Required | Purpose | Example |
|-------|----------|---------|---------|
| name | ✅ | Unique identifier | `code-review-agent` |
| description | ✅ | When to delegate | `Reviews code when PR created` |
| model | ❌ | Claude model | `haiku`, `sonnet`, `opus`, `inherit` |
| tools | ❌ | Allowlist tools | `["Read", "Grep"]` |
| disallowedTools | ❌ | Denylist tools | `["Write", "Edit"]` |
| permissionMode | ❌ | Permission handling | `default`, `safe` |
| skills | ❌ | Inject skills | `["skills-knowledge"]` |
| hooks | ❌ | Lifecycle hooks | Valid hook configuration |

**Remember**:
- Only use valid fields
- Be specific and actionable
- Restrict tools appropriately
- Use appropriate model
- Add hooks for safety
