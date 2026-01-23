# Hook Implementation Patterns

Common patterns for implementing hooks in your project.

## Pattern 1: File Validation Hook

Prevent modification of sensitive files.

**Configuration**:
```yaml
# .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/validate-file.sh"
          }
        ]
      }
    ]
  }
}
```

**Validation Script**:
```bash
#!/bin/bash
# .claude/scripts/validate-file.sh

FILE="$1"
SENSITIVE_FILES=(".env" "*.key" "config/production.yml")

for pattern in "${SENSITIVE_FILES[@]}"; do
  if [[ "$FILE" == $pattern ]]; then
    echo "ERROR: Editing $FILE is not allowed"
    exit 2
  fi
done
```

## Pattern 2: Security Check Hook

Validate operations before execution.

**Configuration**:
```yaml
# In skill frontmatter
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./.claude/scripts/security-check.sh"
```

**Security Check Script**:
```bash
#!/bin/bash
# .claude/scripts/security-check.sh

COMMAND="$1"

# Block dangerous commands
DANGEROUS_PATTERNS=("rm -rf" "sudo" "chmod 777")

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    echo "ERROR: Dangerous command detected: $pattern"
    exit 2
  fi
done
```

## Pattern 3: Formatting Hook

Automatically format code after edits.

**Configuration**:
```yaml
# In skill frontmatter
hooks:
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "./.claude/scripts/format.sh"
          once: true
```

**Format Script**:
```bash
#!/bin/bash
# .claude/scripts/format.sh

# Auto-format based on file type
if [[ "$FILE" == *.js ]]; then
  prettier --write "$FILE"
elif [[ "$FILE" == *.py ]]; then
  black "$FILE"
elif [[ "$FILE" == *.md ]]; then
  markdownlint --fix "$FILE"
fi
```

## Pattern 4: Logging Hook

Log all file operations for audit trail.

**Configuration**:
```yaml
# .claude/settings.local.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|Read",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/log-operation.sh"
          }
        ]
      }
    ]
  }
}
```

**Logging Script**:
```bash
#!/bin/bash
# .claude/scripts/log-operation.sh

TOOL="$1"
FILE="$2"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "$TIMESTAMP - $TOOL - $FILE" >> .claude/audit.log
```

## Pattern 5: Environment Setup Hook

Initialize development environment.

**Configuration**:
```yaml
# In skill frontmatter
hooks:
  PreToolUse:
    - matcher: "*"
      hooks:
        - type: command
          command: "./.claude/scripts/setup-env.sh"
          once: true
```

**Setup Script**:
```bash
#!/bin/bash
# .claude/scripts/setup-env.sh

# Create necessary directories
mkdir -p .claude/scripts
mkdir -p logs
mkdir -p temp

# Set up environment variables
export CLAUDE_PROJECT_DIR="$PWD"
```

## Best Practices

### 1. Use Component-Scoped Hooks
Prefer hooks in skill/agent frontmatter for auto-cleanup:
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
```

### 2. Fail Fast
Use `exit 2` to block dangerous operations:
```bash
if [[ $VIOLATION ]]; then
  echo "ERROR: Operation blocked"
  exit 2
fi
```

### 3. Keep Scripts in .claude/scripts/
Organize hook scripts in a dedicated directory:
```
.claude/
├── scripts/
│   ├── validate.sh
│   ├── format.sh
│   └── log.sh
├── settings.json
└── hooks.json
```

### 4. Use once: true for Setup Hooks
Avoid repeated execution:
```yaml
hooks:
  PreToolUse:
    - matcher: "*"
      hooks:
        - type: command
          command: "./scripts/setup.sh"
          once: true
```

### 5. Log Operations
Maintain audit trail of hook executions:
```bash
echo "$(date): $OPERATION" >> .claude/hook.log
```
