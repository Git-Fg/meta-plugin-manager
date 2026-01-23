# Hook Types Reference

Comprehensive guide to hook types, event patterns, and when to use each.

---

## Overview

Claude Code provides multiple hook types for different lifecycle stages. Understanding which hook to use for each scenario is critical for effective guardrail implementation.

---

## Hook Type Hierarchy

```
System Level (Global)
  ├── Session Hooks (lifecycle)
  ├── Tool Hooks (operations)
  ├── Permission Hooks (security)
  └── System Hooks (infrastructure)

Component Level (Scoped to Skill/Agent)
  ├── PreToolUse (validation)
  ├── PostToolUse (processing)
  └── Stop (cleanup)
```

---

## Session Hooks

### SessionStart
**Trigger**: Beginning of conversation

**Use Cases**:
- Initialize session state
- Load project configuration
- Set up environment variables
- Display welcome messages

**Example**:
```yaml
hooks:
  SessionStart:
    - type: command
      command: "./.claude/scripts/init-session.sh"
```

**Script Template** (`/.claude/scripts/init-session.sh`):
```bash
#!/bin/bash
# Initialize session

echo "🚀 Session started for project: $(basename $(pwd))"

# Set session variables
export CLAUDE_SESSION_STARTED=$(date +%s)

# Initialize state file
echo '{"start_time": '$(date +%s)'}' > .claude/session-state.json

exit 0
```

**When to Use**:
- ✅ Setting up project context
- ✅ Initializing state
- ✅ Loading configurations
- ❌ NOT for validation (use PreToolUse)

---

### SessionEnd
**Trigger**: End of conversation

**Use Cases**:
- Cleanup temporary files
- Save session state
- Generate summary report
- Archive logs

**Example**:
```yaml
hooks:
  SessionEnd:
    - type: command
      command: "./.claude/scripts/cleanup-session.sh"
```

**Script Template**:
```bash
#!/bin/bash
# Cleanup session

# Save session summary
cat > .claude/session-summary.md << EOF
# Session Summary

**Duration**: $(($(date +%s) - CLAUDE_SESSION_STARTED)) seconds
**Files Modified**: $(git diff --name-only | wc -l)
**Commands Run**: $(cat .claude/command-log.txt 2>/dev/null | wc -l)

## Files Created/Modified
$(git diff --name-only)

## Key Learnings
- [Add your learnings here]
EOF

# Cleanup temporary files
rm -f .claude/temp-*

exit 0
```

---

## Tool Hooks

### PreToolUse (Most Common)
**Trigger**: Before tool execution

**Use Cases**:
- ✅ Validate inputs
- ✅ Check permissions
- ✅ Block dangerous operations
- ✅ Sanitize paths
- ✅ Verify environment

**Priority**: **Highest** - Most important hook type

**Example Configuration**:
```yaml
hooks:
  PreToolUse:
    # Match by tool type
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-paths.sh"

    # Match by tool + command pattern
    - matcher:
        tool: "Bash"
        command: "npm.*run.*prod"
      hooks:
        - type: command
          command: "./.claude/scripts/validate-prod.sh"
```

**Match Patterns**:

**1. Match by Tool Only**:
```yaml
- matcher: {"tool": "Bash"}
  # Runs before EVERY Bash command
```

**2. Match by Tool + Command**:
```yaml
- matcher:
    tool: "Bash"
    command: "npm.*run.*deploy"
  # Runs before npm run deploy
```

**3. Match by Tool + Path**:
```yaml
- matcher:
    tool: "Read"
    path: "*.env*"
  # Runs before reading .env files
```

**4. Match Multiple Conditions**:
```yaml
- matcher:
    tool: "Bash"
    command: "docker.*build"
    path: "Dockerfile"
  # Runs before docker build
```

**Available Matchers**:
- `tool`: Tool name (Bash, Write, Read, Edit, etc.)
- `command`: Command pattern (regex)
- `path`: File path pattern (glob/regex)
- `args`: Arguments array

---

### PostToolUse
**Trigger**: After tool execution

**Use Cases**:
- Process results
- Log operations
- Update state
- Notify on completion

**Example**:
```yaml
hooks:
  PostToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/log-command.sh"
```

**Script Template**:
```bash
#!/bin/bash
# Log command execution

# Log successful commands
echo "[$(date)] $TOOL_NAME $COMMAND" >> .claude/command-log.txt

# Special handling for specific commands
if [[ "$COMMAND" =~ "npm install" ]]; then
  echo "📦 Dependencies installed: $(date)" >> .claude/activity.log
fi

exit 0
```

**Environment Variables Available**:
- `TOOL_NAME`: Name of tool executed
- `COMMAND`: Command or operation
- `EXIT_CODE`: Exit code of tool
- `OUTPUT`: Tool output (if applicable)

---

## Permission Hooks

### PermissionRequest
**Trigger**: When permission is needed

**Use Cases**:
- Custom permission handling
- Integration with external auth systems
- Permission logging
- Approval workflows

**Example**:
```yaml
hooks:
  PermissionRequest:
    - type: command
      command: "./.claude/scripts/handle-permission.sh"
```

**Script Template**:
```bash
#!/bin/bash
# Handle permission requests

echo "🔐 Permission requested: $PERMISSION_TYPE"
echo "Context: $PERMISSION_CONTEXT"
echo "Reason: $PERMISSION_REASON"

# Log permission request
echo "[$(date)] Permission: $PERMISSION_TYPE - $PERMISSION_CONTEXT" >> .claude/permissions.log

# Auto-approve safe permissions
SAFE_PERMISSIONS=(
  "read"
  "glob"
  "read_file"
)

for safe in "${SAFE_PERMISSIONS[@]}"; do
  if [[ "$PERMISSION_TYPE" == "$safe" ]]; then
    echo "✅ Auto-approved: $PERMISSION_TYPE"
    exit 0  # Approve
  fi
done

# Log for manual review
echo "⚠️  Requires approval: $PERMISSION_TYPE" >> .claude/pending-permissions.log

exit 1  # Ask for approval
```

---

### UserPromptSubmit
**Trigger**: When user submits input

**Use Cases**:
- Validate user input
- Sanitize prompts
- Check for sensitive data
- Rate limiting

**Example**:
```yaml
hooks:
  UserPromptSubmit:
    - type: command
      command: "./.claude/scripts/validate-prompt.sh"
```

---

## System Hooks

### Notification
**Trigger**: System notifications

**Use Cases**:
- Custom notification handling
- Integration with external systems
- Notification logging

**Example**:
```yaml
hooks:
  Notification:
    - type: command
      command: "./.claude/scripts/handle-notification.sh"
```

---

### PreCompact
**Trigger**: Before context compaction

**Use Cases**:
- Persist important state
- Summarize conversation
- Save partial results

**Example**:
```yaml
hooks:
  PreCompact:
    - type: command
      command: "./.claude/scripts/save-state.sh"
```

---

### Setup
**Trigger**: System initialization

**Use Cases**:
- System configuration
- Environment setup
- Initial validation

**Example**:
```yaml
hooks:
  Setup:
    - type: command
      command: "./.claude/scripts/setup-env.sh"
```

---

## Validation Hooks

### PreWrite
**Trigger**: Before file write operations

**Note**: Similar to PreToolUse with Write tool, but more specific

**Example**:
```yaml
hooks:
  PreWrite:
    - type: command
      command: "./.claude/scripts/validate-write.sh"
```

---

### PreEdit
**Trigger**: Before file edit operations

**Example**:
```yaml
hooks:
  PreEdit:
    - type: command
      command: "./.claude/scripts/validate-edit.sh"
```

---

## Agent Hooks

### SubagentStop
**Trigger**: When subagent completes

**Use Cases**:
- Collect subagent results
- Merge state
- Cleanup resources

**Example**:
```yaml
hooks:
  SubagentStop:
    - type: command
      command: "./.claude/scripts/collect-subagent-results.sh"
```

---

### Stop
**Trigger**: Session stop event

**Use Cases**:
- Final cleanup
- Save final state
- Generate reports

**Example**:
```yaml
hooks:
  Stop:
    - type: command
      command: "./.claude/scripts/final-cleanup.sh"
```

---

## Infrastructure Hooks

Used for setting up:
- MCP (Model Context Protocol) configuration
- LSP (Language Server Protocol) setup
- Environment preparation
- Tool initialization

---

## Component-Scoped vs Global Hooks

### Component-Scoped Hooks (Preferred)

**Location**: `.claude/skills/<skill-name>/SKILL.md`

**Advantages**:
- ✅ Scoped to specific skill
- ✅ Easy to understand impact
- ✅ Can be temporary/experimental
- ✅ No global side effects
- ✅ Auto-cleanup when skill removed

**When to Use**:
- Skill-specific validation
- Temporary guardrails
- Testing hook configurations
- Avoid global impact

**Example**:
```yaml
---
name: deploy-skill
description: "Deploy application to production"
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/validate-deploy.sh"
---
```

---

### Global Hooks

**Location**: `.claude/hooks.json`

**Advantages**:
- ✅ Applies to all skills
- ✅ Organization-wide policies
- ✅ Persistent configuration
- ✅ Centralized management

**When to Use**:
- Organization security policies
- Environment validation
- Production safety measures
- Compliance requirements

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
            "command": "./.claude/scripts/guard-paths.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Hook Selection Decision Tree

```
Need to validate before operation?
│
├─ Yes → PreToolUse
│   │
│   ├─ File write → PreToolUse (Write) or PreWrite
│   ├─ File edit → PreToolUse (Edit) or PreEdit
│   ├─ Command execution → PreToolUse (Bash)
│   ├─ File read → PreToolUse (Read)
│   └─ Glob operation → PreToolUse (Glob)
│
└─ No → Continue

Need to process after operation?
│
├─ Yes → PostToolUse
│   │
│   ├─ Log results → PostToolUse
│   ├─ Update state → PostToolUse
│   └─ Send notifications → PostToolUse
│
└─ No → Continue

Need to handle lifecycle events?
│
├─ Session start → SessionStart
├─ Session end → SessionEnd
├─ Permission request → PermissionRequest
├─ Context compaction → PreCompact
└─ System notification → Notification
│
└─ No → Not a hook use case
```

---

## Event Pattern Matching

### Glob Patterns
```yaml
# Match files ending in .env
matcher:
  path: "*.env*"

# Match files in src directory
matcher:
  path: "src/**"

# Match configuration files
matcher:
  path: "*.config.*"
```

### Regex Patterns
```yaml
# Match deploy commands
matcher:
  command: "npm.*run.*deploy"

# Match docker commands
matcher:
  command: "docker.*(build|run)"

# Match production commands
matcher:
  command: "(prod|production)"
```

### Multiple Matchers (AND logic)
```yaml
# Match docker build in production
matcher:
  tool: "Bash"
  command: "docker build"
  environment: "production"
```

---

## Environment Variables in Hooks

### Available Variables
- `CLAUDE_PROJECT_DIR`: Project root directory
- `CLAUDE_SKILL_NAME`: Current skill name (if applicable)
- `CLAUDE_HOOK_NAME`: Name of hook being executed
- `TOOL_NAME`: Tool being executed
- `COMMAND`: Command or operation
- `EXIT_CODE`: Exit code of previous operation
- `ARGS`: Array of arguments

### Setting Variables
```bash
# Set variable for later hooks
export DEPLOY_IN_PROGRESS=true

# Save to state file
echo '{"stage": "deploying"}' > .claude/current-state.json
```

---

## Performance Considerations

### Best Practices
1. **Keep scripts fast** - <100ms execution time
2. **Avoid expensive operations** - No git status checks in hot path
3. **Cache results** - Store validation results
4. **Be specific** - Match only necessary operations
5. **Use component-scoped** - Avoid global performance impact

### What to Avoid
- ❌ Database queries
- ❌ Network calls
- ❌ Git operations
- ❌ File system traversal
- ❌ Long-running processes

### Performance Monitoring
```bash
#!/bin/bash
START=$(date +%s.%N)

# Your validation logic

END=$(date +%s.%N)
DURATION=$(echo "$END - $START" | bc)
echo "⏱️  Hook execution time: ${DURATION}s"

if (( $(echo "$DURATION > 0.1" | bc -l) )); then
  echo "⚠️  Slow hook detected (>100ms)"
fi
```

---

## Common Patterns

### Pattern 1: Path Validation
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/validate-path.sh"
```

### Pattern 2: Command Guard
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-command.sh"
```

### Pattern 3: Environment Check
```yaml
hooks:
  PreToolUse:
    - matcher:
        tool: "Bash"
        command: "npm.*run.*prod"
      hooks:
        - type: command
          command: "./.claude/scripts/check-env.sh"
```

### Pattern 4: Secret Detection
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/detect-secrets.sh"
```

---

## Testing Hooks

### Test Hook Execution
```bash
# Make scripts executable
chmod +x .claude/scripts/*.sh

# Test with dry run
echo "test" | ./.claude/scripts/guard-paths.sh

# Check hook is triggered
# Perform operation and verify hook runs
```

### Verify Hook Coverage
```bash
# List all hooks
grep -r "hooks:" .claude/

# Check for common gaps
grep -r "PreToolUse" .claude/ | grep -v "guard"
```

---

## Troubleshooting

### Hook Not Firing
1. **Check script exists**: `ls -la .claude/scripts/`
2. **Verify executable**: `chmod +x .claude/scripts/*.sh`
3. **Check syntax**: `bash -n .claude/scripts/guard.sh`
4. **Match pattern**: Verify matcher configuration
5. **Log execution**: Add echo to script

### Too Many Hooks Firing
1. **Be more specific**: Use command/path matchers
2. **Use component-scoped**: Move to skill-specific hooks
3. **Add conditions**: Only run when needed

### Performance Issues
1. **Profile scripts**: Add timing
2. **Optimize patterns**: Use exact match vs regex
3. **Cache results**: Store validation state
4. **Remove unnecessary**: Delete unused hooks

---

## Quick Reference

| Use Case | Hook Type | Priority |
|----------|-----------|----------|
| Validate file write | PreToolUse (Write) | High |
| Block dangerous command | PreToolUse (Bash) | High |
| Check environment | PreToolUse (Bash) | Medium |
| Log operations | PostToolUse | Low |
| Session cleanup | SessionEnd | Low |
| Permission handling | PermissionRequest | Medium |

---

## Integration Examples

### Complete Setup
```yaml
# .claude/skills/my-skill/SKILL.md
---
name: my-skill
description: "My custom skill"
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/pre-check.sh"
  PostToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/post-check.sh"
---
```

### Global Security
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": {"tool": "Write"},
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/guard-paths.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Success Criteria

**Effective Hook Configuration**:
- ✅ PreToolUse for all validation needs
- ✅ Component-scoped hooks preferred
- ✅ Specific matchers (not overly broad)
- ✅ Fast execution (<100ms)
- ✅ Clear exit codes (0/1/2)
- ✅ Informative error messages

**Quality Score Target**:
- Component Scope: 20/20 (prefer component-scoped)
- Validation Patterns: 18/20 (comprehensive validation)
- Exit Code Usage: 15/15 (proper codes)
- Script Quality: 15/20 (well-structured)
- Security Coverage: 20/25 (common threats covered)
