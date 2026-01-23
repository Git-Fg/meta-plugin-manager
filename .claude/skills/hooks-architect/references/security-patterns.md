# Security Guardrail Patterns

Comprehensive patterns for creating effective security guardrails with hooks.

---

## Overview

This guide provides concrete, copy-paste ready security guardrail patterns for common threats. Each pattern includes the hook configuration and validation script.

---

## Core Security Principles

### Defense in Depth
- Multiple layers of protection
- Fail-safe defaults (block on uncertainty)
- Component-scoped where possible

### Validation Patterns
- **Whitelist approach**: Only allow known-safe operations
- **Input sanitization**: Clean all user input
- **Path validation**: Prevent directory traversal
- **Command validation**: Restrict dangerous operations

### Exit Code Convention
- **0**: Success, operation allowed
- **1**: Warning, operation allowed with caution
- **2**: Blocking, operation denied

---

## Pattern Library

### 1. Path Protection (File Operations)

**Threat**: Unauthorized file access, directory traversal, sensitive file exposure

**Hook Configuration**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-paths.sh"
```

**Script Template** (`/.claude/scripts/guard-paths.sh`):
```bash
#!/bin/bash
# Path Protection Guardrail

# Get the path from tool use
PATH="${args[0]}"

# Sensitive paths that should be protected
SENSITIVE_PATHS=(
  ".env"
  ".env.local"
  ".env.production"
  "config/secrets"
  "secrets"
  "*.key"
  "*.pem"
  "id_rsa"
  "id_dsa"
)

# Check if path matches any sensitive pattern
for pattern in "${SENSITIVE_PATHS[@]}"; do
  if [[ "$PATH" == $pattern ]]; then
    echo "❌ BLOCKED: Attempting to write to sensitive file: $PATH"
    echo "This file contains secrets or configuration."
    echo "Use environment variables or secure config management instead."
    exit 2
  fi

  # Check for .env pattern
  if [[ "$PATH" =~ \.env\.?.* ]]; then
    echo "❌ BLOCKED: .env files contain sensitive data"
    echo "Use environment variables or secure config management."
    exit 2
  fi
done

# Check for path traversal attempts
if [[ "$PATH" == *"../"* ]] || [[ "$PATH" == *"..\\"* ]]; then
  echo "❌ BLOCKED: Path traversal attempt detected: $PATH"
  echo "Only use relative paths within the project directory."
  exit 2
fi

# Check if file exists (prevent accidental overwrite)
if [ -f "$PATH" ]; then
  echo "⚠️  WARNING: File already exists: $PATH"
  echo "This will overwrite the existing file."
  echo "Use Edit tool instead of Write to modify existing files."
  exit 1
fi

echo "✅ Path validation passed: $PATH"
exit 0
```

**When to Use**:
- Projects with .env files
- Applications handling credentials
- Production deployments
- Projects with sensitive configuration

---

### 2. Command Guard (Bash Operations)

**Threat**: Dangerous system commands, production deployments, data deletion

**Hook Configuration**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-commands.sh"
```

**Script Template** (`/.claude/scripts/guard-commands.sh`):
```bash
#!/bin/bash
# Command Guardrail

COMMAND="${args[*]}"

# Dangerous commands that should be blocked
DANGEROUS_PATTERNS=(
  "rm -rf"
  "sudo"
  "chmod 777"
  "> /dev/sda"
  "mkfs"
  "dd if="
  ":(){ :|:& };:"
  "curl.*\|.*sh"
  "wget.*\|.*sh"
)

# Production-triggering patterns
PRODUCTION_PATTERNS=(
  "kubectl delete"
  "docker rm -f"
  "aws s3 rm"
  "gcloud compute instances delete"
  "heroku destroy"
)

# Check dangerous patterns
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if [[ "$COMMAND" =~ $pattern ]]; then
    echo "❌ BLOCKED: Dangerous command detected: $pattern"
    echo "This command could damage your system or data."
    echo "Review and modify your command before retrying."
    exit 2
  fi
done

# Check production patterns (block in dev/staging)
ENVIRONMENT="${ENVIRONMENT:-development}"
if [[ "$ENVIRONMENT" != "production" ]]; then
  for pattern in "${PRODUCTION_PATTERNS[@]}"; do
    if [[ "$COMMAND" =~ $pattern ]]; then
      echo "⚠️  BLOCKED: Production command detected: $pattern"
      echo "Environment: $ENVIRONMENT"
      echo "These commands should only run in production."
      exit 2
    fi
  done
fi

# Check for attempts to execute downloaded scripts
if [[ "$COMMAND" =~ (curl|wget).*\|.*sh ]]; then
  echo "❌ BLOCKED: Pipe to shell detected"
  echo "Downloading and executing scripts is dangerous."
  echo "Download the script first, review it, then execute."
  exit 2
fi

# Check git status before deploy commands
if [[ "$COMMAND" =~ (deploy|pm2|nginx) ]]; then
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  WARNING: Uncommitted changes detected"
    echo "Deploying with uncommitted changes is not recommended."
    echo "Commit or stash changes before deploying."
    exit 1
  fi
fi

echo "✅ Command validation passed: $COMMAND"
exit 0
```

**When to Use**:
- Multi-environment deployments
- Team development (prevents accidents)
- Production safety
- Junior developers on team

---

### 3. Environment Validation

**Threat**: Running production code in development, missing environment variables

**Hook Configuration**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      matchers:
        - command: "npm.*start"
        - command: "npm.*run.*prod"
      hooks:
        - type: command
          command: "./.claude/scripts/validate-env.sh"
```

**Script Template** (`/.claude/scripts/validate-env.sh`):
```bash
#!/bin/bash
# Environment Validation

COMMAND="${args[*]}"

# Detect if this is a production command
if [[ "$COMMAND" =~ (prod|production|deploy) ]]; then
  echo "🔍 Validating production environment..."

  # Check for production indicators
  if [ -f ".env.production" ] || [ -f "prod.env" ]; then
    echo "✅ Production configuration found"
  else
    echo "⚠️  WARNING: No production .env file found"
    echo "Expected: .env.production or prod.env"
    echo "Create production config before deploying."
  fi

  # Check NODE_ENV
  if [ "$NODE_ENV" != "production" ]; then
    echo "⚠️  WARNING: NODE_ENV is not set to 'production'"
    echo "Current: NODE_ENV=${NODE_ENV:-not set}"
    echo "Set: export NODE_ENV=production"
    exit 1
  fi

  # Check for critical env vars
  REQUIRED_VARS=(
    "DATABASE_URL"
    "API_KEY"
    "JWT_SECRET"
  )

  for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
      echo "❌ BLOCKED: Required environment variable not set: $var"
      echo "Set all required variables before production deployment."
      exit 2
    fi
  done

  echo "✅ Environment validation passed"
  exit 0
fi

# Development environment checks
if [[ "$COMMAND" =~ (dev|development) ]]; then
  echo "🔍 Validating development environment..."

  # Warn if NODE_ENV is production in dev
  if [ "$NODE_ENV" = "production" ]; then
    echo "⚠️  WARNING: NODE_ENV is 'production' in development"
    echo "This may cause unexpected behavior."
    echo "Use: export NODE_ENV=development"
  fi

  exit 0
fi

exit 0
```

**When to Use**:
- Multi-environment projects
- Deployment pipelines
- Automated CI/CD
- Production safety

---

### 4. Database Protection

**Threat**: Accidental data deletion, production database access

**Hook Configuration**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      matchers:
        - command: "mongo.*--drop"
        - command: "psql.*DROP"
        - command: "redis.*FLUSHALL"
      hooks:
        - type: command
          command: "./.claude/scripts/guard-database.sh"
```

**Script Template** (`/.claude/scripts/guard-database.sh`):
```bash
#!/bin/bash
# Database Protection Guardrail

COMMAND="${args[*]}"

# Dangerous database patterns
DROP_PATTERNS=(
  "--drop"
  "DROP DATABASE"
  "DROP TABLE"
  "DROP SCHEMA"
  "FLUSHALL"
  "FLUSHDB"
  "DEL *"
  "rm -rf.*data"
)

ENVIRONMENT="${ENVIRONMENT:-development}"

for pattern in "${DROP_PATTERNS[@]}"; do
  if [[ "$COMMAND" =~ $pattern ]]; then
    echo "❌ BLOCKED: Dangerous database operation detected"
    echo "Pattern: $pattern"
    echo "Environment: $ENVIRONMENT"

    if [[ "$ENVIRONMENT" == "production" ]]; then
      echo "⚠️  CRITICAL: This will affect PRODUCTION data"
      echo "Operation blocked for safety."
      exit 2
    else
      echo "⚠️  WARNING: This will delete data"
      echo "Make sure you have a backup."
      echo "Add --force to command to bypass this warning."
      exit 1
    fi
  fi
done

# Check for production database URLs in dev
if [[ "$COMMAND" =~ prod.*\.amazonaws\.com ]] || [[ "$COMMAND" =~ prod.*\.azure\.com ]]; then
  if [[ "$ENVIRONMENT" != "production" ]]; then
    echo "⚠️  WARNING: Production database detected in $ENVIRONMENT"
    echo "Ensure you are not connecting to production by mistake."
  fi
fi

echo "✅ Database validation passed"
exit 0
```

**When to Use**:
- Projects with databases
- Multi-environment setups
- Team development
- Production safety

---

### 5. Secrets Detection

**Threat**: Accidental exposure of API keys, credentials, tokens

**Hook Configuration**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/detect-secrets.sh"
```

**Script Template** (`/.claude/scripts/detect-secrets.sh`):
```bash
#!/bin/bash
# Secrets Detection Guardrail

CONTENT="${args[*]}"
FILENAME="${args[1]}"

# Patterns that indicate secrets
SECRET_PATTERNS=(
  "-----BEGIN [A-Z]+ PRIVATE KEY-----"
  "api[_-]?key.*=.*[A-Za-z0-9]{20,}"
  "secret[_-]?key.*=.*[A-Za-z0-9]{20,}"
  "password.*=.*\S{8,}"
  "token.*=.*[A-Za-z0-9]{20,}"
  "sk-[A-Za-z0-9]{48}"  # OpenAI API key
  "ghp_[A-Za-z0-9]{36}"  # GitHub personal access token
  "AKIA[0-9A-Z]{16}"     # AWS access key ID
)

# Check content for secrets
for pattern in "${SECRET_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qE "$pattern"; then
    echo "❌ BLOCKED: Possible secret detected in content"
    echo "Pattern matched: $pattern"
    echo "Do not commit secrets to files."
    echo "Use environment variables or secure secret management."
    exit 2
  fi
done

# Check filename patterns
if [[ "$FILENAME" =~ \.(key|pem|p12|pfx)$ ]]; then
  echo "⚠️  WARNING: Private key file detected: $FILENAME"
  echo "Ensure this file is in .gitignore"
  echo "Private keys should not be committed to version control."
  exit 1
fi

# Check for .env in filename
if [[ "$FILENAME" == *.env* ]]; then
  echo "⚠️  WARNING: .env file detected: $FILENAME"
  echo "Ensure .env files are in .gitignore"
  echo "Use .env.example for template instead."
  exit 1
fi

echo "✅ Secrets validation passed"
exit 0
```

**When to Use**:
- Projects handling API keys
- Cloud deployments
- Team development
- Security compliance requirements

---

### 6. Build Safety

**Threat**: Running production builds in development, missing dependencies

**Hook Configuration**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      matchers:
        - command: "npm.*run.*build"
        - command: "docker build"
      hooks:
        - type: command
          command: "./.claude/scripts/validate-build.sh"
```

**Script Template** (`/.claude/scripts/validate-build.sh`):
```bash
#!/bin/bash
# Build Safety Guardrail

COMMAND="${args[*]}"

# Check for node_modules
if [ ! -d "node_modules" ] && [[ "$COMMAND" =~ npm ]]; then
  echo "⚠️  WARNING: node_modules not found"
  echo "Run 'npm install' before building"
  exit 1
fi

# Check for TypeScript compilation
if [[ "$COMMAND" =~ "tsc" ]] || [[ "$COMMAND" =~ "build" ]]; then
  if [ ! -f "tsconfig.json" ]; then
    echo "⚠️  WARNING: tsconfig.json not found"
    echo "TypeScript configuration may be missing"
  fi

  # Check for linting before build
  if [ -f "package.json" ]; then
    if grep -q '"lint"' package.json && ! echo "$COMMAND" | grep -q "lint"; then
      echo "⚠️  WARNING: Lint script found but not executed"
      echo "Consider running 'npm run lint' before build"
      exit 1
    fi
  fi
fi

# Docker build checks
if [[ "$COMMAND" =~ "docker build" ]]; then
  if ! command -v docker &> /dev/null; then
    echo "❌ BLOCKED: Docker not found"
    echo "Install Docker or use --dockerfile to specify path"
    exit 2
  fi

  # Check for .dockerignore
  if [ ! -f ".dockerignore" ]; then
    echo "⚠️  WARNING: .dockerignore not found"
    echo "Consider creating .dockerignore for smaller images"
    exit 1
  fi
fi

echo "✅ Build validation passed"
exit 0
```

**When to Use**:
- Node.js/TypeScript projects
- Docker containerization
- CI/CD pipelines
- Automated builds

---

## Workflow-Specific Patterns

### INIT Workflow Patterns

**Purpose**: Establish baseline security for new projects

**Required Scripts**:
1. `guard-paths.sh` - Path validation
2. `guard-commands.sh` - Command validation
3. `detect-secrets.sh` - Secret detection

**Global Hooks** (`/.claude/hooks.json`):
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
      },
      {
        "matcher": {"tool": "Bash"},
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/guard-commands.sh"
          }
        ]
      }
    ]
  }
}
```

### SECURE Workflow Patterns

**Purpose**: Add specialized guardrails based on project needs

**Detected Needs**:
- **Database present** → Add database guard
- **Docker files** → Add build safety guard
- **Cloud configs** → Add environment validation
- **API integrations** → Add secrets detection

**Component-Scoped Hooks** (preferred):
```yaml
# In .claude/skills/<skill-name>/SKILL.md
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      matchers:
        - command: "npm.*run.*deploy"
      hooks:
        - type: command
          command: "./.claude/scripts/validate-env.sh"
```

### REMEDIATE Workflow Patterns

**Purpose**: Fix common security vulnerabilities

**Common Fixes**:
1. Missing exit codes → Add exit codes
2. No input validation → Add pattern matching
3. Overly permissive → Add whitelisting
4. Missing .gitignore → Add sensitive files

**Before (Vulnerable)**:
```bash
echo "File written: $FILE"
# No validation, no exit codes
```

**After (Secure)**:
```bash
if [[ "$FILE" =~ \.env ]]; then
  echo "❌ BLOCKED: .env files not allowed"
  exit 2
fi
echo "✅ Validated: $FILE"
exit 0
```

---

## Best Practices

### Script Structure
```bash
#!/bin/bash
# Script description

# 1. Input validation
# 2. Threat detection
# 3. Action (allow/block/warn)
# 4. Exit with appropriate code
```

### Exit Code Usage
- **0**: Operation passes validation
- **1**: Warning, operation allowed
- **2**: Blocked, operation denied

### Error Messages
- Start with emoji indicator (✅❌⚠️)
- Explain why the action was taken
- Provide guidance on how to proceed

### Performance
- Keep scripts fast (<100ms)
- Avoid expensive operations (git status, database queries)
- Cache results when possible

---

## Testing Guardrails

### Test Dangerous Operations
```bash
# Test path traversal
Write file: "../../../etc/passwd"
# Should be blocked

# Test secrets
Write file: test.txt with: "api_key=sk-123456789..."
# Should be blocked

# Test dangerous commands
Bash: "rm -rf /"
# Should be blocked
```

### Test Safe Operations
```bash
# Test normal file write
Write file: src/app.js with: "console.log('hello');"
# Should be allowed

# Test safe command
Bash: "npm test"
# Should be allowed
```

---

## Troubleshooting

### Guardrail Not Triggering
1. Check script is executable: `chmod +x .claude/scripts/*.sh`
2. Verify path in hook configuration
3. Check script syntax: `bash -n .claude/scripts/guard-commands.sh`

### False Positives
1. Add exceptions to patterns
2. Use more specific matchers
3. Adjust warning vs block levels

### Performance Issues
1. Optimize regex patterns
2. Reduce file I/O
3. Cache validation results

---

## Integration with Skills

### Using Hooks in Skills
```yaml
---
name: my-skill
description: "Description"
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/validate-operation.sh"
---
```

### Skill-Specific Guards
```bash
#!/bin/bash
# Skill-specific validation

# Only run for specific skill context
if [ "$CLAUDE_SKILL_NAME" != "my-skill" ]; then
  exit 0
fi

# Validate skill-specific operations
# ...
```

---

## Quick Reference

| Threat | Hook | Script | Exit Code |
|--------|------|--------|-----------|
| File overwrite | PreToolUse (Write) | guard-paths.sh | 2 |
| Dangerous commands | PreToolUse (Bash) | guard-commands.sh | 2 |
| Secrets exposure | PreToolUse (Write) | detect-secrets.sh | 2 |
| Data deletion | PreToolUse (Bash) | guard-database.sh | 2 |
| Production mistakes | PreToolUse (Bash) | validate-env.sh | 1-2 |
| Build failures | PreToolUse (Bash) | validate-build.sh | 1 |

---

## Success Criteria

**Secure Project**:
- ✅ All scripts use proper exit codes
- ✅ Input validation on all paths
- ✅ No secrets in files
- ✅ Dangerous commands blocked
- ✅ Component-scoped hooks preferred

**Quality Score ≥80/100**:
- Security Coverage: 20/25
- Validation Patterns: 18/20
- Exit Code Usage: 15/15
- Script Quality: 15/20
- Component Scope: 15/20
