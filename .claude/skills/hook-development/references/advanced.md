# Advanced Hook Use Cases for Local Projects

This reference covers advanced hook patterns and techniques for sophisticated automation workflows in local projects.

## Multi-Stage Validation

Combine command and prompt hooks for layered validation:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/quick-check.sh",
            "timeout": 5
          },
          {
            "type": "prompt",
            "prompt": "Deep analysis of bash command: $TOOL_INPUT",
            "timeout": 15
          }
        ]
      }
    ]
  }
}
```

**Use case:** Fast deterministic checks followed by intelligent analysis

**Example .claude/scripts/quick-check.sh:**
```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Immediate approval for safe commands
if [[ "$command" =~ ^(ls|pwd|echo|date|whoami)$ ]]; then
  exit 0
fi

# Let prompt hook handle complex cases
exit 0
```

The command hook quickly approves obviously safe commands, while the prompt hook analyzes everything else.

## Conditional Hook Execution

Execute hooks based on environment or context:

```bash
#!/bin/bash
# Only run in CI environment
if [ -z "$CI" ]; then
  echo '{"continue": true}' # Skip in non-CI
  exit 0
fi

# Run validation logic in CI
input=$(cat)
# ... validation code ...
```

**Use cases:**
- Different behavior in CI vs local development
- Project-specific validation
- Environment-specific rules

**Example: Skip certain checks in development:**
```bash
#!/bin/bash
# Skip detailed checks in development
if [ "$NODE_ENV" = "development" ]; then
  exit 0
fi

# Full validation in production/staging
input=$(cat)
# ... validation code ...
```

## Git-Aware Hook Behavior

Create hooks that adapt based on git state:

```bash
#!/bin/bash
# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0  # Not a git repo, skip
fi

# Get current branch
branch=$(git branch --show-current 2>/dev/null || echo "unknown")

# Apply different rules based on branch
case "$branch" in
  main|master|production)
    # Strictest validation for protected branches
    input=$(cat)
    # ... strict validation ...
    ;;
  feature/*|develop)
    # Moderate validation for feature branches
    input=$(cat)
    # ... moderate validation ...
    ;;
  *)
    # Basic validation for other branches
    exit 0
    ;;
esac
```

**Example: Check for uncommitted changes:**
```bash
#!/bin/bash
# Only enforce strict rules when there are uncommitted changes
if git diff --quiet && git diff --cached --quiet; then
  exit 0  # Clean state, skip strict validation
fi

# Uncommitted changes exist, apply strict rules
input=$(cat)
# ... strict validation ...
```

## Dynamic Hook Configuration

Modify hook behavior based on project configuration:

```bash
#!/bin/bash
CONFIG_FILE="$CLAUDE_PROJECT_DIR/.claude/hooks-config.json"

# Read project-specific config
if [ -f "$CONFIG_FILE" ]; then
  strict_mode=$(jq -r '.strict_mode // false' "$CONFIG_FILE")

  if [ "$strict_mode" = "true" ]; then
    # Apply strict validation
    # ...
  else
    # Apply lenient validation
    # ...
  fi
fi
```

**Example .claude/hooks-config.json:**
```json
{
  "strict_mode": true,
  "allowed_commands": ["ls", "pwd", "grep", "cat"],
  "forbidden_paths": ["/etc", "/sys", "/proc"],
  "max_file_size": 1000000
}
```

**Configuration hierarchy:**
1. `.claude/settings.json` - Team-wide base configuration
2. `.claude/settings.local.json` - Personal overrides
3. `.claude/hooks-config.json` - Project-specific hook behavior (optional, committed)

## Context-Aware Prompt Hooks

Use transcript and session context for intelligent decisions:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Review the full transcript at $TRANSCRIPT_PATH. Check: 1) Were tests run after code changes? 2) Did the build succeed? 3) Were all user questions answered? 4) Is there any unfinished work? If incomplete, respond with JSON: {\"decision\": \"block\", \"reason\": \"explanation\"}. Otherwise respond: {\"decision\": \"allow\"}."
          }
        ]
      }
    ]
  }
}
```

The LLM can read the transcript file and make context-aware decisions.

**Example: Branch-aware completion check:**
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check current git branch. If on main/master/production branch: require tests passing, build success, and clean git status. If on feature branch: require tests passing. Respond with JSON: {\"decision\": \"block\", \"reason\": \"explanation\"} for incomplete work, or {\"decision\": \"allow\"} to proceed."
          }
        ]
      }
    ]
  }
}
```

## Performance Optimization

### Caching Validation Results

```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
cache_key=$(echo -n "$file_path" | md5sum | cut -d' ' -f1)
cache_file="$CLAUDE_PROJECT_DIR/.cache/hook-validation-$cache_key"

# Create cache directory
mkdir -p "$(dirname "$cache_file")"

# Check cache
if [ -f "$cache_file" ]; then
  cache_age=$(($(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || stat -c%Y "$cache_file")))
  if [ "$cache_age" -lt 300 ]; then  # 5 minute cache
    cat "$cache_file"
    exit 0
  fi
fi

# Perform validation
result='{"decision": "approve"}'

# Cache result
echo "$result" > "$cache_file"
echo "$result"
```

### Parallel Execution Optimization

Since hooks run in parallel, design them to be independent:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/check-size.sh",
            "timeout": 2
          },
          {
            "type": "command",
            "command": "bash .claude/scripts/check-path.sh",
            "timeout": 2
          },
          {
            "type": "prompt",
            "prompt": "Check content safety",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

All three hooks run simultaneously, reducing total latency.

## Cross-Event Workflows

Coordinate hooks across different events:

**SessionStart - Set up tracking:**
```bash
#!/bin/bash
# Initialize session tracking
STATE_DIR="$CLAUDE_PROJECT_DIR/.claude/state"
mkdir -p "$STATE_DIR"
echo "0" > "$STATE_DIR/test-count"
echo "0" > "$STATE_DIR/build-count"
```

**PostToolUse - Track events:**
```bash
#!/bin/bash
STATE_DIR="$CLAUDE_PROJECT_DIR/.claude/state"
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

if [ "$tool_name" = "Bash" ]; then
  command=$(echo "$input" | jq -r '.tool_input.command')
  if [[ "$command" == *"test"* ]] || [[ "$command" == *"pytest"* ]] || [[ "$command" == *"npm test"* ]]; then
    count=$(cat "$STATE_DIR/test-count" 2>/dev/null || echo "0")
    echo $((count + 1)) > "$STATE_DIR/test-count"
  fi
fi
```

**Stop - Verify based on tracking:**
```bash
#!/bin/bash
STATE_DIR="$CLAUDE_PROJECT_DIR/.claude/state"
test_count=$(cat "$STATE_DIR/test-count" 2>/dev/null || echo "0")

if [ "$test_count" -eq 0 ]; then
  echo '{"decision": "block", "reason": "No tests were run"}' >&2
  exit 2
fi
```

## Project Type Detection

Automatically detect and adapt to different project types:

```bash
#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 1

# Detect project type
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
elif [ -f "go.mod" ]; then
  PROJECT_TYPE="go"
  BUILD_CMD="go build"
  TEST_CMD="go test"
else
  PROJECT_TYPE="unknown"
fi

# Apply project-type-specific rules
case "$PROJECT_TYPE" in
  nodejs)
    # Node.js specific validation
    ;;
  rust)
    # Rust specific validation
    ;;
  python)
    # Python specific validation
    ;;
  go)
    # Go specific validation
    ;;
esac
```

## Integration with External Systems

### Project Notifications

```bash
#!/bin/bash
# Notify on important events in team projects
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

# Only notify in production/main branches
branch=$(git branch --show-current 2>/dev/null || echo "unknown")
if [[ ! "$branch" =~ ^(main|master|production)$ ]]; then
  exit 0
fi

# Send notification (if webhook configured)
if [ -n "$PROJECT_WEBHOOK" ]; then
  curl -X POST "$PROJECT_WEBHOOK" \
    -H 'Content-Type: application/json' \
    -d "{\"text\": \"Hook triggered ${tool_name} on $branch\"}" \
    2>/dev/null
fi

exit 0
```

### Local Logging

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
timestamp=$(date -Iseconds)

# Log to project-local file
LOG_DIR="$CLAUDE_PROJECT_DIR/.claude/logs"
mkdir -p "$LOG_DIR"
echo "$timestamp | $tool_name | $input" >> "$LOG_DIR/hooks.log"

exit 0
```

### Metrics Collection

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')

# Track hook usage locally
METRICS_FILE="$CLAUDE_PROJECT_DIR/.claude/metrics/hook-usage.json"
mkdir -p "$(dirname "$METRICS_FILE")"

# Update metrics (requires jq)
if [ -f "$METRICS_FILE" ]; then
  jq ".${tool_name} += 1" "$METRICS_FILE" > "$METRICS_FILE.tmp"
  mv "$METRICS_FILE.tmp" "$METRICS_FILE"
else
  echo "{\"${tool_name}\": 1}" > "$METRICS_FILE"
fi

exit 0
```

## Security Patterns

### Rate Limiting

```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Track command frequency
STATE_DIR="$CLAUDE_PROJECT_DIR/.claude/state"
mkdir -p "$STATE_DIR"
rate_file="$STATE_DIR/rate-limit"
current_minute=$(date +%Y%m%d%H%M)

if [ -f "$rate_file" ]; then
  last_minute=$(head -1 "$rate_file")
  count=$(tail -1 "$rate_file")

  if [ "$current_minute" = "$last_minute" ]; then
    if [ "$count" -gt 10 ]; then
      echo '{"decision": "deny", "reason": "Rate limit exceeded"}' >&2
      exit 2
    fi
    count=$((count + 1))
  else
    count=1
  fi
else
  count=1
fi

echo "$current_minute" > "$rate_file"
echo "$count" >> "$rate_file"

exit 0
```

### Audit Logging

```bash
#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
timestamp=$(date -Iseconds)

# Append to project audit log
AUDIT_DIR="$CLAUDE_PROJECT_DIR/.claude/audit"
mkdir -p "$AUDIT_DIR"
echo "$timestamp | $USER | $tool_name | $input" >> "$AUDIT_DIR/audit.log"

exit 0
```

### Secret Detection

```bash
#!/bin/bash
input=$(cat)
content=$(echo "$input" | jq -r '.tool_input.content // empty')

# Check for common secret patterns
if echo "$content" | grep -qE "(api[_-]?key|password|secret|token).{0,20}['\"]?[A-Za-z0-9]{20,}"; then
  echo '{"decision": "deny", "reason": "Potential secret detected in content"}' >&2
  exit 2
fi

exit 0
```

## Testing Advanced Hooks

### Unit Testing Hook Scripts

```bash
# test-hook.sh
#!/bin/bash

# Test 1: Approve safe command
result=$(echo '{"tool_input": {"command": "ls"}}' | bash .claude/scripts/validate-bash.sh)
if [ $? -eq 0 ]; then
  echo "✓ Test 1 passed"
else
  echo "✗ Test 1 failed"
fi

# Test 2: Block dangerous command
result=$(echo '{"tool_input": {"command": "rm -rf /"}}' | bash .claude/scripts/validate-bash.sh)
if [ $? -eq 2 ]; then
  echo "✓ Test 2 passed"
else
  echo "✗ Test 2 failed"
fi
```

### Integration Testing

Create test scenarios that exercise the full hook workflow:

```bash
# integration-test.sh
#!/bin/bash

# Set up test environment
TEST_DIR="/tmp/test-project-$$"
export CLAUDE_PROJECT_DIR="$TEST_DIR"
mkdir -p "$TEST_DIR/.claude/scripts"

# Copy hooks to test location
cp .claude/scripts/* "$TEST_DIR/.claude/scripts/"

# Test SessionStart hook
echo '{}' | bash .claude/scripts/session-start.sh
if [ -f "$TEST_DIR/.claude/state/session-initialized" ]; then
  echo "✓ SessionStart hook works"
else
  echo "✗ SessionStart hook failed"
fi

# Clean up
rm -rf "$TEST_DIR"
```

## Best Practices for Advanced Hooks

1. **Keep hooks independent**: Don't rely on execution order
2. **Use timeouts**: Set appropriate limits for each hook type
3. **Handle errors gracefully**: Provide clear error messages
4. **Document complexity**: Explain advanced patterns in project README
5. **Test thoroughly**: Cover edge cases and failure modes
6. **Monitor performance**: Track hook execution time
7. **Version configuration**: Commit hook configs to git
8. **Provide escape hatches**: Allow bypass via flag files when needed

## Common Pitfalls

### ❌ Assuming Hook Order

```bash
# BAD: Assumes hooks run in specific order
# Hook 1 saves state, Hook 2 reads it
# This can fail because hooks run in parallel!
```

### ❌ Long-Running Hooks

```bash
# BAD: Hook takes 2 minutes to run
sleep 120
# This will timeout and block the workflow
```

### ❌ Uncaught Exceptions

```bash
# BAD: Script crashes on unexpected input
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
cat "$file_path"  # Fails if file doesn't exist
```

### ✅ Proper Error Handling

```bash
# GOOD: Handles errors gracefully
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
if [ ! -f "$file_path" ]; then
  echo '{"continue": true, "systemMessage": "File not found, skipping check"}' >&2
  exit 0
fi
```

## Conclusion

Advanced hook patterns enable sophisticated automation in local projects while maintaining reliability and performance. Use these techniques when basic hooks are insufficient, but always prioritize simplicity and maintainability.
