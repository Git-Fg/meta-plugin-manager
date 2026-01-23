# Hook Examples & Implementation Guide

Complete examples for implementing hooks in your project, including guardrails, quality gates, and session persistence.

---

## Implementation Guide

### Step 1: Identify Your Need

**What guardrail do you need?**
- Block dangerous operations? → PreToolUse + `exit 2`
- Validate before deployment? → PreToolUse + command hook
- Remember decisions? → Stop + state save
- Quality gate? → Stop + prompt hook

### Step 2: Choose Scope

**Component-scoped (Recommended)**:
```yaml
---
name: my-skill
description: "My skill"
hooks:
  PreToolUse:
    - matcher: "Write"
      hooks:
        - type: "command"
          command: "validate.sh"
---
```

**Global (Project-wide)**:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "validate.sh"
      }]
    }]
  }
}
```

### Step 3: Create Hook Configuration

**For your project**:
```bash
# Create hooks directory
mkdir -p .claude

# Create hooks.json with your configuration
cat > .claude/hooks.json << 'EOF'
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "guard-files.sh"
      }]
    }]
  }
}
EOF
```

### Step 4: Test Guardrail

1. Create file that should be blocked
2. Verify hook blocks it
3. Test `exit 2` returns error correctly
4. Validate security pattern

---

## Examples: Project Guardrails

### 1. Environment File Protection

**Blocks accidental `.env` file modifications:**

```bash
# Create in your project: .claude/hooks.json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "guard-env.sh"
      }]
    }]
  }
}
```

```bash
# Create script: guard-env.sh
#!/bin/bash
FILE_PATH="$1"
if [[ "$FILE_PATH" == *".env"* ]]; then
  echo "❌ BLOCKED: .env files require explicit approval"
  exit 2
fi
exit 0
```

### 2. Deployment Quality Gate

**Validates tests before deployment:**

```yaml
---
name: deploy-to-prod
description: "Deploys to production"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: "command"
          command: "run-tests.sh"
---
```

```bash
# Script: run-tests.sh
#!/bin/bash
echo "Running tests..."
npm test
if [ $? -ne 0 ]; then
  echo "❌ BLOCKED: Tests failed"
  exit 2
fi
exit 0
```

### 3. Session Persistence

**Remembers your development decisions:**

```bash
# Create: .claude/hooks.json
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "save-decisions.sh"
    }]
  }]
}
```

```bash
# Script: save-decisions.sh
#!/bin/bash
# Extract decisions from conversation and save to .claude/STATE.md
# See references/session-persistence.md for full implementation
```

---

## Common Guardrail Patterns

### Protection Hook (Fail Fast)

**Block dangerous file operations:**

```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "guard-env-files.sh"
    }]
  }]
}
```

**Script Example** (`guard-env-files.sh`):
```bash
#!/bin/bash
FILE_PATH="$1"
if [[ "$FILE_PATH" =~ \.env$ ]] || [[ "$FILE_PATH" =~ \.aws/credentials$ ]]; then
  echo "❌ BLOCKED: Sensitive file modification requires explicit approval"
  exit 2
fi
exit 0
```

### Quality Gate Hook

**Validate code before deployment:**

```yaml
---
name: deploy-skill
description: "Deploys application"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: "command"
          command: "run-tests.sh"
---
```

### Session Persistence Hook

**Remember development decisions:**

```json
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "save-decisions.sh"
    }]
  }]
}
```

**Reference**: [Session Persistence Pattern](session-persistence.md)

---

## Security Guardrails

### Path Safety (Fail Fast)

**Block dangerous file operations in your project:**

```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "guard-sensitive-paths.sh"
    }]
  }]
}
```

**Script Template** (`guard-sensitive-paths.sh`):
```bash
#!/bin/bash
FILE_PATH="$1"

# Block sensitive files
if [[ "$FILE_PATH" =~ \.env$ ]] || [[ "$FILE_PATH" =~ \.aws/credentials$ ]]; then
  echo "❌ BLOCKED: Sensitive file modification requires explicit approval"
  exit 2
fi

# Block deletion of important directories
if [[ "$FILE_PATH" =~ node_modules/ ]] || [[ "$FILE_PATH" =~ .git/ ]]; then
  echo "❌ BLOCKED: Protected directory modification"
  exit 2
fi

exit 0
```

### Input Validation (Quality Gates)

**Validate operations before execution:**

```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "validate-command.sh"
    }]
  }]
}
```

**Script Template** (`validate-command.sh`):
```bash
#!/bin/bash
COMMAND="$1"

# Block dangerous commands
if [[ "$COMMAND" =~ rm[[:space:]]+-rf ]] || [[ "$COMMAND" =~ sudo.*rm ]]; then
  echo "❌ BLOCKED: Dangerous deletion command"
  exit 2
fi

exit 0
```

---

## Best Practices: Project-First Approach

### DO ✅
- **Prefer component-scoped hooks** over global hooks
- Use `exit 2` to block dangerous operations immediately
- Validate all file paths before writes/edits
- Create scripts in your project's `.claude/scripts/` directory
- Test guardrails with intentionally dangerous operations
- Keep hooks fast (<10 seconds timeout)
- Document what each guardrail protects

### DON'T ❌
- **Don't create plugin-level hooks** (not project-scoped)
- Don't execute untrusted commands without validation
- Don't use hooks for cosmetic messages (SessionStart echo)
- Don't create conflicting hooks across components
- Don't ignore security warnings in your guardrails
- Don't use prompt hooks for non-Stop/SubagentStop events

### Project Configuration Checklist
- [ ] Created `.claude/hooks.json` for global guardrails
- [ ] Added hooks to skill frontmatter where needed
- [ ] All scripts in `.claude/scripts/` directory
- [ ] Tested blocking behavior with `exit 2`
- [ ] Validated path safety in PreToolUse hooks
- [ ] Documented guardrail purposes in README

---

## Troubleshooting

### Hook Not Triggering
1. Verify event name is correct
2. Check matcher syntax
3. Validate JSON format
4. Test with simple hook first

### Invalid JSON
1. Use JSON validator
2. Check for trailing commas
3. Verify quotes are proper
4. Test syntax

### Security Errors
1. Review path safety
2. Check input validation
3. Verify command restrictions
4. Update security policies

---

## Advanced Patterns

### Multi-Hook Chains

Chain multiple hooks for comprehensive validation:

```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [
      { "type": "command", "command": "validate-path.sh" },
      { "type": "command", "command": "check-permissions.sh" },
      { "type": "command", "command": "log-attempt.sh" }
    ]
  }]
}
```

### Conditional Hooks

Use matchers for conditional behavior:

```json
{
  "PreToolUse": [
    {
      "matcher": "Write.*\\.env$",
      "hooks": [{
        "type": "command",
        "command": "block-env-write.sh"
      }]
    },
    {
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "log-write.sh"
      }]
    }
  ]
}
```

### State Management

Combine Stop and PreCompact for state persistence:

```json
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "extract-decisions.sh"
    }]
  }],
  "PreCompact": [{
    "matcher": "auto",
    "hooks": [{
      "type": "command",
      "command": "save-state.sh"
    }]
  }]
}
```

---

## Error Handling Strategies

### Graceful Degradation

```bash
#!/bin/bash
# validation-hook.sh
set +e  # Don't exit on error

RESULT=$(validate-operation.sh "$1" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "⚠️  Validation warning: $RESULT"
  echo "Continuing with caution..."
  exit 0  # Non-blocking for warnings
fi

exit 0
```

### Retry Logic

```bash
#!/bin/bash
# retry-hook.sh
MAX_ATTEMPTS=3
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  if attempt-operation.sh "$1"; then
    exit 0
  fi
  ATTEMPT=$((ATTEMPT + 1))
  sleep 1
done

echo "❌ Failed after $MAX_ATTEMPTS attempts"
exit 2
```

### User Feedback

```bash
#!/bin/bash
# user-notify-hook.sh
OPERATION="$1"

echo "ℹ️  About to: $OPERATION"
echo "Press Ctrl+C to cancel, or wait 3 seconds..."
sleep 3

echo "✅ Proceeding with: $OPERATION"
exit 0
```
