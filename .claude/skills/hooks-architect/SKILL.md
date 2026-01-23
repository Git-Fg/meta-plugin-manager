---
name: hooks-architect
description: "Configure and audit project guardrails in .claude/ configuration with multi-workflow orchestration. Automatically detects INIT/SECURE/AUDIT/REMEDIATE workflows. Creates component-scoped hooks (skills/commands/agents) with PreToolUse/PostToolUse/Stop events, project settings hooks (settings.json/settings.local.json), or global hooks in .claude/hooks.json. Supports once: true for skills/commands. Routes to hooks-knowledge for patterns and templates. Does not contain active hooks."
---

# Hooks Architect

## WIN CONDITION

**Called by**: toolkit-architect
**Purpose**: Configure guardrails and hooks in .claude/ configuration

**Output**: Must output completion marker

```markdown
## HOOKS_ARCHITECT_COMPLETE

Workflow: [INIT|SECURE|AUDIT|REMEDIATE]
Quality Score: XX/100
Security Improvements: [+XX points]
Guardrails: [Count] created/modified
Context Applied: [Summary]
```

**Completion Marker**: `## HOOKS_ARCHITECT_COMPLETE`

## Reference Files

Load these as needed:
1. `references/security-patterns.md` - Common security guardrails and validation patterns
2. `references/hook-types.md` - Event types, use cases, and selection criteria
3. `references/script-templates.md` - Validation script patterns and conventions
4. `references/compliance-framework.md` - 5-dimensional quality scoring system

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_security_workflow(project_state, conversation_context):
    # Check all possible hook locations
    hooks_exist = (
        exists(".claude/hooks.json") or
        exists(".claude/settings.json") or
        exists(".claude/settings.local.json") or
        has_component_hooks()
    )
    security_mentioned = conversation_context.has_security_keywords()
    audit_requested = "audit" in user_request.lower()

    if not hooks_exist and not security_mentioned:
        return "INIT"  # Fresh project, no security concerns
    elif security_mentioned or audit_requested:
        return "AUDIT"  # Security assessment requested
    elif has_security_issues():
        return "REMEDIATE"  # Fix found security problems
    else:
        return "SECURE"  # Add more guardrails to existing hooks
```

**Detection Logic**:
1. **No hooks found + no security context** → **INIT mode** (fresh project setup)
2. **Security keywords in conversation** → **AUDIT mode** (assess current state)
3. **Audit found issues** → **REMEDIATE mode** (fix security problems)
4. **Hooks exist, no issues** → **SECURE mode** (enhance with more guardrails)

## Core Philosophy

**Project-First Approach**:
- Creates guardrails in YOUR project, not in toolkit
- Prefers component-scoped hooks over global hooks
- Generates scripts in `.claude/scripts/` directory
- Routes to hooks-knowledge for detailed patterns
- Does NOT contain active hooks itself

**Trust in AI Reasoning**:
- Provides context and examples, trusts AI to make intelligent decisions
- Uses clear detection logic instead of asking questions upfront
- Relies on completion markers for workflow verification

## Hook Configuration Types & Events

### Supported Hook Events
- **PreToolUse**: Run before tool execution (validation, security checks)
- **PostToolUse**: Run after tool execution (logging, cleanup, formatting)
- **Stop**: Run when component completes (final validation, state save)

### Component-Scoped Hooks (Preferred)
**Location**: YAML frontmatter in skills/commands/agents

**Best For**:
- **Skills/Commands**: Preprocessing, validation after edits, one-time setup (with `once: true`)
- **Agents**: Scoped event handling, automatic cleanup, agent-specific validation

**Features**:
- ✅ Auto-cleanup when component finishes
- ✅ Skills/Commands: Support `once: true` for one-time setup
- ❌ Agents: Do NOT support `once` option
- ✅ All events: PreToolUse, PostToolUse, Stop

### Settings-Based Hooks
**Location**: `.claude/settings.json`, `.claude/settings.local.json`, or `.claude/hooks.json`

**Best For**:
- Project-wide preprocessing (e.g., filtering logs to reduce context)
- Team-wide automation
- Cross-component policies

**Use Settings-Based When**:
- Need preprocessing across multiple components
- Team-wide automation required
- Project-wide policies needed

## Four Workflows

### INIT Workflow - Fresh Project Setup

**Use When:**
- Empty project (no `.claude/hooks.json` exists)
- No component-scoped hooks in skills
- First-time hook setup
- Team adopting hooks for security

**Why:**
- Establishes baseline security guardrails
- Prevents security issues from accumulating
- Sets up component-scoped hooks by default
- Creates validation script library

**Process:**
1. Investigate project structure
2. Create `.claude/settings.json` template (recommended) or `.claude/hooks.json` (legacy)
3. Generate common security scripts in `.claude/scripts/`
4. Configure basic PreToolUse validation
5. Validate security score ≥80/100

**Configuration Options:**
- **settings.json** (recommended): Modern format, better team collaboration
- **settings.local.json**: For local overrides (gitignored)
- **hooks.json** (legacy): Traditional global hooks format

**Required References:**
- `references/security-patterns.md#init-workflow` - Complete INIT setup guide
- `references/compliance-framework.md` - Ensure baseline security meets standards

**Example:** New project cloned, no hooks exist → INIT automatically

---

### SECURE Workflow - Enhance Existing Security

**Use When:**
- Hooks already exist (global or component-scoped)
- Want to add more guardrails
- Security coverage incomplete
- No critical issues found

**Why:**
- Improves security posture incrementally
- Adds specialized guardrails for specific needs
- Complements existing hooks
- Targets specific security gaps

**Process:**
1. Scan existing hooks and scripts
2. Identify security gaps
3. Suggest additional guardrails based on patterns
4. Generate specialized validation scripts
5. Add to appropriate scope (component-scoped preferred)

**Required References:**
- `references/security-patterns.md#secure-workflow` - Enhancement patterns
- `references/script-templates.md` - Specialized validation scripts

**Example:** Project has basic hooks, user mentions protecting .env files → SECURE adds PreToolUse .env guard

---

### AUDIT Workflow - Security Assessment

**Use When:**
- Security assessment requested
- Compliance check needed
- Before making changes to understand baseline
- Regular security health check

**Why:**
- Provides objective security assessment
- Identifies specific security gaps
- Suggests optimal remediation path
- Establishes baseline for tracking improvements

**Process:**
1. Scan all hooks (global and component-scoped)
2. Check script security patterns
3. Validate exit code usage
4. Assess security coverage
5. Generate compliance report

**Required References:**
- `references/compliance-framework.md` - Understanding scoring dimensions
- `references/hook-types.md#audit-process` - Security validation details

**Score-Based Actions:**
- 90-100 (A): Excellent security, minor enhancements optional
- 75-89 (B): Good security, SECURE workflow recommended
- 60-74 (C): Moderate issues, REMEDIATE workflow required
- <60 (D/F): Critical issues, REMEDIATE workflow mandatory

**Example:** User asks "Audit my security" → AUDIT with detailed report

---

### REMEDIATE Workflow - Fix Security Issues

**Use When:**
- AUDIT found issues (score <75)
- Security vulnerabilities detected
- Non-compliant patterns found
- High-priority security gaps

**Why:**
- Fixes critical security issues
- Removes vulnerable patterns
- Improves compliance score
- Blocks potential security breaches

**Process:**
1. Review audit findings
2. Prioritize issues by severity
3. Fix high-priority vulnerabilities
4. Update validation scripts
5. Re-validate security score

**Required References:**
- `references/compliance-framework.md#remediation` - Fix strategies
- `references/security-patterns.md#fixing-patterns` - Common vulnerability fixes

**Example:** AUDIT found score 45/100 → REMEDIATE to fix issues and reach ≥80/100

## Quality Framework (5 Dimensions)

Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Security Coverage** | 25 | Hooks protect critical operations |
| **2. Validation Patterns** | 20 | Proper input validation and sanitization |
| **3. Exit Code Usage** | 15 | Correct exit codes (0=success, 2=blocking) |
| **4. Script Quality** | 20 | Well-written, maintainable scripts |
| **5. Component Scope** | 20 | Prefer component-scoped over global hooks |

**Quality Thresholds**:
- **A (90-100)**: Exemplary security posture
- **B (75-89)**: Good security with minor gaps
- **C (60-74)**: Adequate security, needs improvement
- **D (40-59)**: Poor security, significant issues
- **F (0-39)**: Failing security, critical vulnerabilities

## Security Keywords Detection

Automatically detects security-related context:

**Conversation Indicators**:
- "security", "protect", "guard", "validate"
- "prevent", "block", "audit", "compliance"
- ".env", "credentials", "secrets", "password"
- "production", "deploy", "safety"

**Project Indicators**:
- `.env` files present
- Database configuration files
- Cloud provider configs (AWS, GCP, Azure)
- CI/CD configuration files
- Docker/Kubernetes configs

## Common Hook Patterns

### Component-Scoped (Preferred)

**Location**: `.claude/skills/<skill-name>/SKILL.md` frontmatter

**Use When**:
- Protecting specific skills
- Skill-specific validation
- Temporary or experimental hooks
- Avoids global impact

**Example**:
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./.claude/scripts/validate-deploy.sh"
```

### Project Settings Hooks

**Location**: `.claude/settings.json` (team-shared) or `.claude/settings.local.json` (local only)

**Use When**:
- Team-wide security policies (settings.json)
- Personal project preferences (settings.local.json)
- Project-scoped automation
- Configuration that benefits from JSON format

**Example** (`.claude/settings.json`):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/guard-sensitive-paths.sh"
          }
        ]
      }
    ]
  }
}
```

**Key Differences**:
- `settings.json`: Committed to git, shared with team
- `settings.local.json`: Gitignored, personal only
- Both support the same hook configuration as `hooks.json`

### Global Hooks (Legacy)

**Location**: `.claude/hooks.json`

**Use When**:
- Traditional global hook configuration
- Organization-wide security policies
- Cross-skill protection
- Environment validation
- Production safety measures

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tool": "Write"},
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/guard-sensitive-paths.sh"
          }
        ]
      }
    ]
  }
}
```

**Note**: `settings.json` is the modern replacement for `.claude/hooks.json`. Both work, but settings.json provides better team collaboration features.

## Quick Reference: Security Guardrails

| Threat | Hook Type | Script Pattern | Exit Code |
|---------|-----------|----------------|-----------|
| **File Overwrite** | PreToolUse (Write) | Check file doesn't exist | 2 (block) |
| **Env Leakage** | PreToolUse (Read) | Validate .env access | 2 (block) |
| **Dangerous Commands** | PreToolUse (Bash) | Command allowlist | 2 (block) |
| **Path Traversal** | PreToolUse (Glob) | Validate path patterns | 2 (block) |
| **Deploy Safety** | PreToolUse (Bash) | Check git status | 1 (warn) |

## Implementation Guidance

**For detailed implementation patterns**: Load: hooks-knowledge

**Security Best Practices**:
- Input validation and sanitization
- Event pattern matching safety
- Error handling and recovery
- Performance impact monitoring

## Workflow Selection Quick Guide

**"I need to set up hooks for a new project"** → INIT
**"Add more security to existing hooks"** → SECURE
**"Check my current security posture"** → AUDIT
**"Fix security issues found"** → REMEDIATE

## Output Contracts

### INIT Output
```markdown
## Hooks Initialized

### Security Score: XX/100
### Created Files
- .claude/settings.json (project settings - recommended)
- .claude/scripts/ (validation scripts)

### Baseline Security
- Path safety: ✅
- Command validation: ✅
- Environment protection: ✅

### Configuration Options
- settings.json: Team-shared hooks (committed to git)
- settings.local.json: Personal hooks (gitignored)
- hooks.json: Legacy global hooks (still supported)
```

### SECURE Output
```markdown
## Security Enhanced

### Security Score: XX → YY/100 (+ZZ points)
### New Guardrails Added
- [Guardrail 1]: [Purpose]
- [Guardrail 2]: [Purpose]

### Security Improvements
- Coverage: XX → YY%
- Validation: XX patterns added
```

### AUDIT Output
```markdown
## Security Audit Complete

### Quality Score: XX/100 (Grade: [A/B/C/D/F])

### Breakdown
- Security Coverage: XX/25
- Validation Patterns: XX/20
- Exit Code Usage: XX/15
- Script Quality: XX/20
- Component Scope: XX/20

### Issues
- [Count] critical issues
- [Count] warnings

### Recommendations
1. [Action] → Expected improvement: [+XX points]
2. [Action] → Expected improvement: [+XX points]
```

### REMEDIATE Output
```markdown
## Security Issues Remediated

### Quality Score: XX → YY/100 (+ZZ points)
### Issues Fixed
- [Issue 1]: [Before] → [After]
- [Issue 2]: [Before] → [After]

### Security Posture
- Critical vulnerabilities: XX → 0
- Warnings: XX → YY
- Recommendations: XX → ZZ
```
