# Common Hook Patterns

This reference provides common, proven patterns for implementing hooks in local projects. Use these patterns as starting points for typical hook use cases.

## Pattern 1: Security Validation

Block dangerous file writes using prompt-based hooks in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "File path: $TOOL_INPUT.file_path. Verify: 1) Not in /etc or system directories 2) Not .env or credentials 3) Path doesn't contain '..' traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ]
  }
}
```

**Response format for prompt-based hooks:** `{ "ok": true|false, "reason": "explanation" }`

**Use for:** Preventing writes to sensitive files or system directories.
**Configuration:** Add to `.claude/settings.json` for team-wide enforcement.

## Pattern 2: Test Enforcement

Ensure tests run before stopping:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Review transcript at $TRANSCRIPT_PATH. If code was modified (Write/Edit tools used), verify tests were executed. If no tests were run, respond: {\"ok\": false, \"reason\": \"Tests must be run after code changes\"}."
          }
        ]
      }
    ]
  }
}
```

**Use for:** Enforcing quality standards and preventing incomplete work.

## Pattern 3: Context Loading

Load project-specific context at session start:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/load-context.sh"
          }
        ]
      }
    ]
  }
}
```

**Example script (.claude/scripts/load-context.sh):**

```bash
#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 1

# Detect project type
if [ -f "package.json" ]; then
  echo "export PROJECT_TYPE=nodejs" >> "$CLAUDE_ENV_FILE"
elif [ -f "Cargo.toml" ]; then
  echo "export PROJECT_TYPE=rust" >> "$CLAUDE_ENV_FILE"
elif [ -f "pyproject.toml" ]; then
  echo "export PROJECT_TYPE=python" >> "$CLAUDE_ENV_FILE"
fi
```

**Use for:** Automatically detecting and configuring project-specific settings.

## Pattern 4: Notification Logging

Log all notifications for audit or analysis:

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/log-notification.sh"
          }
        ]
      }
    ]
  }
}
```

**Use for:** Tracking user notifications or integration with external logging systems.

## Pattern 5: MCP Tool Monitoring

Monitor and validate MCP tool usage:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__.*__delete.*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Deletion operation detected. Verify: Is this deletion intentional? Can it be undone? Are there backups? Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ]
  }
}
```

**Use for:** Protecting against destructive MCP operations.

## Pattern 6: Build Verification

Ensure project builds after code changes:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check if code was modified. If Write/Edit tools were used, verify the project was built (npm run build, cargo build, etc). If not built, respond with JSON: {\"decision\": \"block\", \"reason\": \"Project must be built before stopping\"}."
          }
        ]
      }
    ]
  }
}
```

**Use for:** Catching build errors before committing or stopping work.

## Pattern 7: Permission Confirmation

Ask user before dangerous operations:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Command: $TOOL_INPUT.command. If command contains 'rm', 'delete', 'drop', or other destructive operations, respond with JSON: {\"ok\": false, \"reason\": \"Destructive command requires user confirmation\"}. Otherwise respond: {\"ok\": true}."
          }
        ]
      }
    ]
  }
}
```

**Use for:** User confirmation on potentially destructive commands.

## Pattern 8: Code Quality Checks

Run linters or formatters on file edits:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/check-quality.sh"
          }
        ]
      }
    ]
  }
}
```

**Example script (.claude/scripts/check-quality.sh):**

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Run linter if applicable
if [[ "$file_path" == *.js ]] || [[ "$file_path" == *.ts ]]; then
  npx eslint "$file_path" 2>&1 || true
elif [[ "$file_path" == *.py ]]; then
  ruff check "$file_path" 2>&1 || true
fi
```

**Use for:** Automatic code quality enforcement.

## Pattern Combinations

Combine multiple patterns for comprehensive protection:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Validate file write safety. Check: system paths, credentials, path traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Validate bash command safety. Check for dangerous operations (rm, dd, mkfs, etc). Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Verify tests run and build succeeded. If code was modified but no tests or build executed, respond with JSON: {\"decision\": \"block\", \"reason\": \"Tests and build must run before stopping\"}. Otherwise respond: {\"decision\": \"allow\"}."
          }
        ]
      },
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/git-status-check.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/load-context.sh"
          }
        ]
      }
    ]
  }
}
```

This provides multi-layered protection and automation.

## Pattern 9: Temporarily Active Hooks

Create hooks that only run when explicitly enabled via flag files:

```bash
#!/bin/bash
# Hook only active when flag file exists
FLAG_FILE="$CLAUDE_PROJECT_DIR/.enable-strict-validation"

if [ ! -f "$FLAG_FILE" ]; then
  exit 0  # Not enabled, skip
fi

# Flag present, run validation
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Run strict validation
# ... validation logic ...
```

**Activation:**

```bash
# Enable the hook
touch .enable-strict-validation

# Disable the hook
rm .enable-strict-validation
```

**Use for:**

- Temporary debugging hooks
- Feature flags for development
- Opt-in strict validation
- Performance-intensive checks only when needed

**Note:** Must restart Claude Code after creating/removing flag files.

## Pattern 10: Configuration-Driven Hooks

Use JSON configuration to control hook behavior:

```bash
#!/bin/bash
CONFIG_FILE="$CLAUDE_PROJECT_DIR/.claude/settings.local.json"

# Read configuration
if [ -f "$CONFIG_FILE" ]; then
  strict_mode=$(jq -r '.strictMode // false' "$CONFIG_FILE")
  max_file_size=$(jq -r '.maxFileSize // 1000000' "$CONFIG_FILE")
else
  # Defaults
  strict_mode=false
  max_file_size=1000000
fi

# Skip if not in strict mode
if [ "$strict_mode" != "true" ]; then
  exit 0
fi

# Apply configured limits
input=$(cat)
file_size=$(echo "$input" | jq -r '.tool_input.content | length')

if [ "$file_size" -gt "$max_file_size" ]; then
  echo '{"decision": "deny", "reason": "File exceeds configured size limit"}' >&2
  exit 2
fi
```

**Configuration file (.claude/settings.local.json):**

```json
{
  "strictMode": true,
  "maxFileSize": 500000,
  "allowedPaths": ["src/", "lib/"]
}
```

**Use for:**

- User-configurable hook behavior
- Personal development preferences
- Project-specific validation criteria
- Dynamic settings without editing hooks

## Pattern 11: Git-Aware Hooks

Create hooks that behave differently based on git state:

```bash
#!/bin/bash
# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0  # Not a git repo, skip
fi

# Check if there are uncommitted changes
if git diff --quiet && git diff --cached --quiet; then
  CLEAN_STATE=true
else
  CLEAN_STATE=false
fi

# Apply different rules based on git state
if [ "$CLEAN_STATE" = "false" ]; then
  # Stricter validation when there are uncommitted changes
  input=$(cat)
  # ... strict validation logic ...
fi
```

**Use for:**

- Enhanced validation during active development
- Pre-commit style checks
- Branch-specific behavior
- Work-in-progress detection

## Pattern 12: Project Type Detection

Automatically adjust behavior based on project type:

```bash
#!/bin/bash
cd "$CLAUDE_PROJECT_DIR"

# Detect project type and set rules
if [ -f "package.json" ]; then
  PROJECT_TYPE="nodejs"
  BUILD_CMD="npm run build"
  TEST_CMD="npm test"
elif [ -f "Cargo.toml" ]; then
  PROJECT_TYPE="rust"
  BUILD_CMD="cargo build"
  TEST_CMD="cargo test"
elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
  PROJECT_TYPE="python"
  BUILD_CMD="python -m build"
  TEST_CMD="pytest"
else
  PROJECT_TYPE="unknown"
fi

# Apply project-specific rules
case "$PROJECT_TYPE" in
  nodejs)
    # Node.js specific checks
    ;;
  rust)
    # Rust specific checks
    ;;
  python)
    # Python specific checks
    ;;
esac
```

**Use for:**

- Language-specific validation
- Framework-aware checks
- Custom build/test commands
- Project-type appropriate linters

## Detailed Security Patterns

### Path Traversal Prevention

Protect against directory traversal attacks in file operations:

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Validate file path format
if [[ -z "$file_path" ]]; then
  echo '{"continue": true}'
  exit 0
fi

# Deny path traversal attempts
if [[ "$file_path" == *".."* ]]; then
  echo '{"permissionDecision": "deny", "systemMessage": "Path traversal detected"}' >&2
  exit 2
fi

# Deny absolute paths to system directories
if [[ "$file_path" == /etc/* ]] || [[ "$file_path" == /usr/* ]] || [[ "$file_path" == /bin/* ]] || [[ "$file_path" == /sbin/* ]]; then
  echo '{"permissionDecision": "deny", "systemMessage": "System directory access denied"}' >&2
  exit 2
fi

echo '{"continue": true}'
exit 0
```

**Protection targets:**

- `../` traversal sequences
- `/etc/` system configuration
- `/usr/` system binaries
- `/bin/`, `/sbin/` critical system files

### Sensitive File Protection

Block modification of credential and configuration files:

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Sensitive file patterns
SENSITIVE_PATTERNS=(
  ".env"
  ".env.local"
  ".env.production"
  "credentials"
  "secret"
  "private_key"
  "id_rsa"
  ".pem"
  ".key"
)

# Check against sensitive patterns
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if [[ "$file_path" == *"$pattern"* ]]; then
    echo '{"permissionDecision": "deny", "systemMessage": "Sensitive file protection"}' >&2
    exit 2
  fi
done

echo '{"continue": true}'
exit 0
```

**Protected file types:**

- Environment files (`.env*`)
- Credential files (`credentials`, `secret`)
- Private keys (`private_key`, `id_rsa`, `.pem`, `.key`)

### Dangerous Command Validation

Intercept destructive bash commands:

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Dangerous command patterns
DANGEROUS_COMMANDS=(
  "rm -rf"
  "rm -fr"
  "dd if="
  "mkfs"
  ">:"
  "drop table"
  "delete from"
  "truncate"
  "shutdown"
  "reboot"
)

# Check for dangerous patterns
for dangerous in "${DANGEROUS_COMMANDS[@]}"; do
  if [[ "$command" == *"$dangerous"* ]]; then
    echo '{"permissionDecision": "ask", "systemMessage": "Destructive command requires confirmation"}' >&2
    exit 2
  fi
done

echo '{"continue": true}'
exit 0
```

**Intercepted commands:**

- File deletion (`rm -rf`, `dd`)
- Filesystem operations (`mkfs`)
- Database operations (`drop`, `delete`, `truncate`)
- System commands (`shutdown`, `reboot`)

### Output Sanitization

Prevent sensitive data leakage in hook output:

```markdown
<!-- For AI agents using native tools -->

Use the `Edit` tool with regex replacement for controlled sanitization:
```

Edit: Replace pattern key="[^"]\*" with key=**_REJECTED_**
Edit: Replace pattern token="[^"]\*" with token=**_REJECTED_**
Edit: Replace pattern password="[^"]\*" with password=**_REJECTED_**

```

**Sanitization targets:**
- API keys (`key=...`)
- Auth tokens (`token=...`)
- Passwords (`password=...`)
- Credential strings
```

## Advanced Matcher Patterns

### Regex-Based Tool Matching

Use regex for sophisticated tool matching:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__.*__.*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "MCP tool detected: $TOOL_NAME. Verify this MCP server is trusted and the operation is safe. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ]
  }
}
```

**Matcher patterns:**

- `mcp__.*` - All MCP tools
- `mcp__github__.*` - GitHub MCP server tools only
- `mcp__.*__delete.*` - All MCP deletion operations
- `.*File.*` - Tools containing "File" in name

### File Extension Matching

Validate based on file extension via prompt hooks:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "File: $TOOL_INPUT.file_path. If file extension is .sh, .py, .js, .ts, verify script is safe and not obfuscated. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ]
  }
}
```

**Target extensions:**

- Shell scripts: `.sh`, `.bash`
- Python: `.py`, `.pyw`
- JavaScript: `.js`, `.mjs`
- TypeScript: `.ts`, `.tsx`

## Error Handling Patterns

### Graceful Degradation

Handle missing tools or dependencies gracefully:

```bash
#!/bin/bash
set -euo pipefail

# Check if required tool exists
if ! command -v jq &> /dev/null; then
  # jq not available, skip validation
  echo '{"continue": true}'
  exit 0
fi

# jq available, proceed with validation
input=$(cat)
# ... validation logic ...
```

### Validation Recovery

Provide fallback behavior when validation fails:

```bash
#!/bin/bash
set -euo pipefail

input=$(cat)

# Try to validate
if ! validation_result=$(validate_input "$input"); then
  # Validation failed, but don't block
  echo '{"continue": true, "systemMessage": "Validation unavailable, proceeding with caution"}' >&2
  exit 0
fi

# Validation succeeded
echo "$validation_result"
```

## Team Collaboration Patterns

### Shared Hooks in settings.json

Put team-wide hooks in `.claude/settings.json` (committed to git):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Validate file write safety for team project. Check: system paths, credentials, path traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Ensure tests pass before stopping. If code was modified but tests were not run, respond with JSON: {\"decision\": \"block\", \"reason\": \"Tests must pass before stopping\"}. Otherwise respond: {\"decision\": \"allow\"}."
          }
        ]
      }
    ]
  }
}
```

### Personal Overrides in settings.local.json

Put personal hooks in `.claude/settings.local.json` (gitignored):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/my-dev-setup.sh"
          }
        ]
      }
    ]
  }
}
```

**Remember:** Add `.claude/settings.local.json` to `.gitignore`.

### Hook Priority

When both files define hooks for the same event:

- All hooks run in parallel (no priority)
- Design hooks for independence
- Avoid duplicate functionality across files
