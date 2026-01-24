---
name: hooks-architect
description: "Configure and audit project guardrails in .claude/ configuration with multi-workflow orchestration. Automatically detects INIT/SECURE/AUDIT/REMEDIATE workflows. Creates component-scoped hooks with PreToolUse/PostToolUse/Stop events."
user-invocable: false
---

# Hooks Domain

## WIN CONDITION

**Called by**: User directly (no intermediate router needed)
**Purpose**: Configure guardrails and hooks in your local project with quality validation

## Core Philosophy: Local Project Autonomy

**This skill teaches the "Project-First Hooks" approach:**

1. **Local Project Default**: Always create hooks in your project's `.claude/` directory
2. **Trust AI Intelligence**: Provide concepts, let AI make intelligent decisions
3. **Autonomous Execution**: Skills work without user interaction
4. **Minimal Prescriptiveness**: Focus on principles, not rigid templates
5. **Clean Architecture**: No deprecated patterns or legacy knowledge

**Output**: Must output completion marker

```markdown
## HOOKS_DOMAIN_COMPLETE

Workflow: [INIT|SECURE|AUDIT|REMEDIATE]
Quality Score: XX/100
Security Improvements: [+XX points]
Guardrails: [Count] created/modified
Context Applied: [Summary]
```

**Completion Marker**: `## HOOKS_DOMAIN_COMPLETE`

## Dependencies

This skill is self-contained and does not depend on other skills for execution. It includes all necessary knowledge for hook configuration, security patterns, and event automation.

**May be called by**:
- User requests for hooks setup, security, or automation
- Other skills seeking hook configuration guidance

**Does not call other skills** - all functionality is self-contained.

## Routing Guidance

**Use this skill when**:
- "I need hooks" or "Configure automation"
- "Set up guardrails" or "Add event hooks"
- "Secure project" or "Add validation"
- Setting up PreToolUse/PostToolUse/Stop events

**Do not use for**:
- Skill creation (use skills-domain)
- MCP configuration (use mcp-domain)
- Subagent creation (use subagents-domain)
- General project setup without hooks focus

## Quality Integration

Apply quality framework during hooks work:

**Validate hook configuration**:
- Proper event matching and triggers
- Security best practices (input validation, output sanitization)
- Appropriate event types (PreToolUse, PostToolUse, Stop)
- Performance and effectiveness

**Check for anti-patterns**:
- Missing security validation
- Over-broad event matching
- Complex nested configurations without need
- Missing error handling

**Report quality in completion**:
```markdown
## HOOKS_DOMAIN_COMPLETE

Workflow: [INIT|SECURE|AUDIT|REMEDIATE]
Quality Score: XX/100
Security Improvements: [+XX points]
Guardrails: [Count] created/modified
Context Applied: [Summary]
```

## Reference Files

Load these as needed:
1. `references/security-patterns.md` - Common security guardrails and validation patterns
2. `references/hook-types.md` - Event types, use cases, and selection criteria
3. `references/script-templates.md` - Validation script patterns and conventions
4. `references/compliance-framework.md` - Quality scoring system

## Quick Reference

**Hooks** automate your local project through event-driven guardrails and validation.

**Use Hooks For**:
- **Guardrails**: Prevent dangerous operations (e.g., `.env` modification)
- **Validation**: Validate file operations before execution
- **Project Automation**: Initialize development environment
- **Quality Gates**: Ensure code meets project standards
- **Session Management**: Persist development decisions
- **Security**: Block unauthorized actions

**Project-First Approach**:
- **Local Configuration**: Hooks in your project's `.claude/` directory
- **Component-Scoped**: Hooks in skill/agent frontmatter (preferred for auto-cleanup)
- **Settings Files**: Use `.claude/settings.json` for team collaboration
- **Fail Fast**: Use `exit 2` to block dangerous operations
- **Trust AI**: Provide concepts, AI handles implementation details

## Model Selection for Security Workflows

When orchestrating security validation with TaskList, select model based on task complexity:

**Simple Security Tasks (haiku)**:
- Individual hook validation
- Basic script syntax checks
- Single hook testing
- Quick security scans
- Routine validation checks

**Default Security Tasks (sonnet)**:
- Security audit workflows
- Standard compliance validation
- Typical remediation projects
- Multi-hook validation
- Balanced performance for most security work

**Complex Security Tasks (opus)**:
- Complex security architecture design
- Multi-phase remediation planning
- Critical vulnerability analysis
- Cross-component dependency resolution
- High-stakes security decisions

**Security Criticality**: Escalate to opus for critical security decisions, use haiku for routine validation.

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

## Hook Configuration Types

### Project Settings (Recommended)
**Location**: `.claude/settings.json`

**Best For**:
- Team-wide automation and policies
- Project-specific security guardrails
- Shared configurations across collaborators

**Configuration**:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "./.claude/scripts/validate-file.sh"
      }]
    }]
  }
}
```

### Component-Scoped Hooks (Preferred for Auto-Cleanup)
**Location**: YAML frontmatter in skills/commands/agents

**Best For**:
- **Skills/Commands**: Preprocessing, validation after edits, one-time setup (with `once: true`)
- **Agents**: Scoped event handling, automatic cleanup, agent-specific validation

**Features**:
- ✅ Auto-cleanup when component finishes
- ✅ Skills/Commands: Support `once: true` for one-time setup
- ❌ Agents: Do NOT support `once` option
- ✅ All events: PreToolUse, PostToolUse, Stop

**Example**:
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./.claude/scripts/security-check.sh"
          once: true
```

### Legacy Global Hooks
**Location**: `.claude/hooks.json`

**Note**: This is the legacy format. Use `settings.json` for better maintainability.

## Hook Events Overview

### Essential Events
- **PreToolUse**: Before tool execution (validation, security)
- **PostToolUse**: After tool succeeds (logging, cleanup)
- **Stop**: Claude finishes responding (final validation)

### Lifecycle Events
- **SessionStart**: Session begins (environment setup)
- **SessionEnd**: Session terminates (cleanup)
- **UserPromptSubmit**: User submits prompt (validation)

### Configuration Structure
```json
{
  "hooks": {
    "EventName": [{
      "matcher": "ToolPattern",
      "hooks": [{
        "type": "command",
        "command": "your-script.sh"
      }]
    }]
  }
}
```

### Key Concepts

**Matchers**: Target specific tools or patterns
- `"Write"` - Exact match
- `"Write|Edit"` - Multiple tools
- `"Bash"` - Shell commands
- `"*.env*"` - File patterns

**Hook Types**:
- `command`: Bash script execution
- `prompt`: LLM-based evaluation (for Stop/SubagentStop)

**Exit Codes**:
- `0`: Success, operation allowed
- `1`: Warning, operation allowed
- `2`: Blocking error, operation denied

## Four Workflows

### INIT Workflow - Fresh Project Setup

**Use When:**
- Empty project (no `.claude/hooks.json` exists)
- No component-scoped hooks in skills
- First-time hook setup

**Why:**
- Establishes baseline security guardrails
- Prevents security issues from accumulating
- Sets up component-scoped hooks by default

**Process:**
1. Investigate project structure
2. Create `.claude/settings.json` template
3. Generate common security scripts in `.claude/scripts/`
4. Configure basic PreToolUse validation

**Configuration Options:**
- **settings.json** (recommended): Modern format, better team collaboration
- **settings.local.json**: For local overrides (gitignored)
- **hooks.json** (legacy): Traditional global hooks format

---

### SECURE Workflow - Enhance Existing Security

**Use When:**
- Hooks already exist (global or component-scoped)
- Want to add more guardrails
- Security coverage incomplete

**Why:**
- Improves security posture incrementally
- Adds specialized guardrails for specific needs
- Complements existing hooks

**Process:**
1. Scan existing hooks and scripts
2. Identify security gaps
3. Suggest additional guardrails based on patterns
4. Generate specialized validation scripts
5. Add to appropriate scope (component-scoped preferred)

---

### AUDIT Workflow - Security Assessment

**Use When:**
- Security assessment requested
- Compliance check needed
- Before making changes to understand baseline

**Why:**
- Provides objective security assessment
- Identifies specific security gaps
- Suggests optimal remediation path

**Process:**
1. Scan all hooks (global and component-scoped)
2. Check script security patterns
3. Validate exit code usage
4. Assess security coverage
5. Generate compliance report

**Score-Based Actions:**
- 90-100 (A): Excellent security, minor enhancements optional
- 75-89 (B): Good security, SECURE workflow recommended
- 60-74 (C): Moderate issues, REMEDIATE workflow required
- <60 (D/F): Critical issues, REMEDIATE workflow mandatory

---

### REMEDIATE Workflow - Fix Security Issues

**Use When:**
- AUDIT found issues (score <75)
- Security vulnerabilities detected
- Non-compliant patterns found

**Why:**
- Fixes critical security issues
- Removes vulnerable patterns
- Improves compliance score

**Process:**
1. Review audit findings
2. Prioritize issues by severity
3. Fix high-priority vulnerabilities
4. Update validation scripts
5. Re-validate security score

## Quality Framework

Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Security Coverage** | 25 | Hooks protect critical operations |
| **2. Validation Patterns** | 20 | Proper input validation and sanitization |
| **3. Exit Code Usage** | 15 | Correct exit codes (0=success, 2=blocking) |
| **4. Script Quality** | 20 | Well-written, maintainable scripts |
| **5. Configuration Hierarchy** | 20 | Modern configuration approach |

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

## TaskList Integration for Complex Hook Workflows

For complex security validation requiring visual progress tracking and dependency enforcement, use TaskList integration:

**When to use**:
- Multi-hook security audit (5+ hooks to validate)
- AUDIT workflow with dependency tracking
- REMEDIATE workflow dependent on AUDIT completion
- Need visual progress tracking (Ctrl+T)

**AUDIT workflow**:

Use TaskCreate to establish a hooks configuration scan task. Then use TaskCreate to set up parallel validation tasks for security patterns, script quality, and hook execution order — configure these to depend on the scan completion. Use TaskCreate to establish a compliance report generation task that depends on all validation phases completing.

**REMEDIATE workflow** (depends on AUDIT):

After the audit report task completes, use TaskCreate to establish a findings review task that depends on the report. Then use TaskCreate to set up security fix prioritization, remediation, and re-validation tasks in sequence, each depending on the previous.

**Critical dependency**: Remediation tasks must be configured to depend on the audit report task completing, ensuring fixes are based on actual security assessment findings.

**Task tracking provides**:
- Visual security audit progression (visible in Ctrl+T)
- Dependency enforcement (remediation tasks blocked by audit completion)
- Persistent security posture tracking across cycles
- Clear phase completion markers

## Best Practices

### Trust AI Intelligence
- Provide concepts and examples
- Let AI make implementation decisions
- Focus on principles, not prescriptive patterns

### Local Project Approach
- Create hooks in your project directory
- Use component-scoped hooks for auto-cleanup
- Trust AI to choose appropriate scope

### Performance Considerations
- Keep scripts fast (<100ms)
- Use specific matchers, not broad patterns
- Avoid expensive operations in hooks

## Environment Variables

Use `CLAUDE_PROJECT_DIR` for portable scripts:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/validate.sh"
      }]
    }]
  }
}
```

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
```

### SECURE Output
```markdown
## Security Enhanced

### Security Score: XX → YY/100 (+ZZ points)
### New Guardrails Added
- [Guardrail 1]: [Purpose]
- [Guardrail 2]: [Purpose]
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
- Configuration Hierarchy: XX/20

### Issues
- [Count] critical issues
- [Count] warnings
```

### REMEDIATE Output
```markdown
## Security Issues Remediated

### Quality Score: XX → YY/100 (+ZZ points)
### Issues Fixed
- [Issue 1]: [Before] → [After]
- [Issue 2]: [Before] → [After]
```

## Common Anti-Patterns

**Configuration Anti-Patterns:**
- ❌ Prescriptive hook patterns - Trust AI to make intelligent decisions
- ❌ Over-complex configuration hierarchies - Start with local project settings
- ❌ Interactive command references in skills - Focus on autonomous capabilities
- ❌ Deprecated legacy format emphasis - Use modern JSON approach (settings.json)

**Setup Anti-Patterns:**
- ❌ Creating hooks in toolkit instead of project - Always configure in project's .claude/
- ❌ Not using component-scoped hooks for auto-cleanup - Missing cleanup benefits
- ❌ Using `once: true` in agents - Agents don't support this option
- ❌ Not detecting security context - Should auto-detect INIT/SECURE/AUDIT/REMEDIATE

**Script Anti-Patterns:**
- ❌ Punting to Claude - Handle error conditions explicitly
- ❌ Missing exit codes - 0=success, 1=input error, 2=system error, 3=blocked
- ❌ No validation - Missing format and checks
- ❌ Brittle paths - Windows-style backslashes or relative cd

**See**: [hooks-knowledge](../hooks-knowledge/SKILL.md) for complete implementation patterns and templates.
