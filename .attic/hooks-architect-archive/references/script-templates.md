# Script Templates

Copy-paste ready validation script templates for common security guardrails.

---

## Overview

This document provides production-ready script templates for all common hook validation scenarios. Each template includes input validation, security checks, and proper exit codes.

---

## Template Structure

### Standard Template Format
```bash
#!/bin/bash
# Script Description
# Purpose: What this script validates

# ========== INPUT VALIDATION ==========
# Extract and validate inputs

# ========== SECURITY CHECKS ==========
# Pattern matching, whitelist/blacklist validation

# ========== ACTION ==========
# Allow, block, or warn based on findings

# ========== EXIT ==========
# Exit with appropriate code
```

### Exit Code Convention
- **0**: ✅ Success, operation allowed
- **1**: ⚠️ Warning, operation allowed with caution
- **2**: ❌ Blocking, operation denied

---

## Core Templates

### Template 1: Path Validation

**Purpose**: Validate file paths before write operations

**Script**: `/.claude/scripts/guard-paths.sh`

```bash
#!/bin/bash
# Path Validation Guardrail
# Purpose: Prevent writing to sensitive or dangerous paths

# ========== INPUT VALIDATION ==========
# Get the file path from arguments
if [ -z "$1" ]; then
  echo "❌ ERROR: No path provided"
  exit 2
fi

PATH_TO_VALIDATE="$1"

# ========== SECURITY CHECKS ==========

# 1. Check for path traversal attempts
if [[ "$PATH_TO_VALIDATE" == *"../"* ]] || [[ "$PATH_TO_VALIDATE" == *"..\\"* ]]; then
  echo "❌ BLOCKED: Path traversal attempt detected"
  echo "Path: $PATH_TO_VALIDATE"
  echo "Only use relative paths within the project directory."
  exit 2
fi

# 2. Check for absolute paths (potential security risk)
if [[ "$PATH_TO_VALIDATE" == /* ]]; then
  echo "⚠️  WARNING: Absolute path detected"
  echo "Path: $PATH_TO_VALIDATE"
  echo "Use relative paths for project files."
  exit 1
fi

# 3. Sensitive file patterns
SENSITIVE_PATTERNS=(
  "\.env"                    # Environment files
  "\.env\."                  # .env.local, .env.production, etc.
  "config/secrets"           # Secrets directory
  "secrets"                  # Secrets directory
  "\.aws/credentials"        # AWS credentials
  "\.kube/config"            # Kubernetes config
  "\.ssh/id_"                # SSH keys
  "\.git/config"             # Git config (if sensitive)
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if [[ "$PATH_TO_VALIDATE" =~ $pattern ]]; then
    echo "❌ BLOCKED: Sensitive file detected"
    echo "Pattern: $pattern"
    echo "Path: $PATH_TO_VALIDATE"
    echo "Do not write sensitive files directly."
    echo "Use environment variables or secure secret management."
    exit 2
  fi
done

# 4. Check if file exists (prevent accidental overwrite)
if [ -f "$PATH_TO_VALIDATE" ]; then
  echo "⚠️  WARNING: File already exists"
  echo "Path: $PATH_TO_VALIDATE"
  echo "Use Edit tool instead of Write to modify existing files."
  echo "This will prevent accidental data loss."
  exit 1
fi

# 5. Check write permissions on parent directory
PARENT_DIR=$(dirname "$PATH_TO_VALIDATE")
if [ ! -w "$PARENT_DIR" ] && [ -d "$PARENT_DIR" ]; then
  echo "❌ BLOCKED: No write permission"
  echo "Directory: $PARENT_DIR"
  echo "Check directory permissions."
  exit 2
fi

# ========== VALIDATION PASSED ==========
echo "✅ Path validation passed: $PATH_TO_VALIDATE"
exit 0
```

**Usage**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-paths.sh"
```

---

### Template 2: Command Validation

**Purpose**: Block dangerous system commands

**Script**: `/.claude/scripts/guard-commands.sh`

```bash
#!/bin/bash
# Command Validation Guardrail
# Purpose: Prevent execution of dangerous system commands

# ========== INPUT VALIDATION ==========
if [ -z "$1" ]; then
  echo "❌ ERROR: No command provided"
  exit 2
fi

COMMAND="$1"

# ========== SECURITY CHECKS ==========

# 1. Dangerous command patterns
DANGEROUS_PATTERNS=(
  # File system destruction
  "rm\s+-rf"                        # rm -rf
  "sudo\s+"                         # sudo (need explicit allow)
  "chmod\s+777"                     # chmod 777
  "> /dev/sda"                      # Disk wipe attempt
  "mkfs"                            # Format disk
  "dd\s+if="                        # Low-level disk operations
  ":(\s*)\(:(\s*)\|:(\s*)&"         # Fork bomb

  # Network security
  "nc\s+-l"                         # Netcat listener
  "nc\s+.*-e"                       # Netcat with execute
  "ssh\s+.*@.*-i"                   # SSH with key

  # Process manipulation
  "killall"                         # Kill all processes
  "pkill"                           # Kill by pattern
  "kill\s+-9"                       # Force kill

  # Package management (can modify system)
  "apt-get\s+install"               # Install packages
  "yum\s+install"                   # Install packages
  "brew\s+install"                  # Install packages
  "npm\s+install\s+-g"              # Global npm install
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "❌ BLOCKED: Dangerous command pattern detected"
    echo "Pattern: $pattern"
    echo "Command: $COMMAND"
    echo "This command could damage your system or data."
    echo "Review and modify your command before retrying."
    exit 2
  fi
done

# 2. Check for pipe to shell (curl | sh, wget | sh)
if echo "$COMMAND" | grep -qE "(curl|wget).*\|.*sh"; then
  echo "❌ BLOCKED: Pipe to shell detected"
  echo "Command: $COMMAND"
  echo "Downloading and executing scripts is dangerous."
  echo "Download the script first, review it, then execute."
  exit 2
fi

# 3. Production safety checks
ENVIRONMENT="${ENVIRONMENT:-development}"

# Check for production-destructive commands in non-production
if [[ "$ENVIRONMENT" != "production" ]]; then
  PROD_DANGEROUS=(
    "kubectl\s+delete"              # Delete k8s resources
    "docker\s+rm\s+-f"              # Force remove containers
    "docker\s+rmi"                   # Remove images
    "aws\s+s3\s+rm"                  # Delete S3 objects
    "gcloud\s+compute\s+instances\s+delete"  # Delete VM instances
    "heroku\s+destroy"               # Destroy Heroku app
    "firebase\s+deploy.*--only\s+hosting"  # Overwrite hosting
  )

  for pattern in "${PROD_DANGEROUS[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern"; then
      echo "❌ BLOCKED: Production-destructive command"
      echo "Pattern: $pattern"
      echo "Environment: $ENVIRONMENT"
      echo "These commands should only run in production."
      exit 2
    fi
  done
fi

# 4. Check git status before deploy
if echo "$COMMAND" | grep -qE "(deploy|pm2\s+restart|nginx)"; then
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  WARNING: Uncommitted changes detected"
    echo "Deploying with uncommitted changes is not recommended."
    echo "Commands: $COMMAND"
    echo "Commit or stash changes before deploying."
    exit 1
  fi
fi

# 5. Validate npm/package commands
if echo "$COMMAND" | grep -qE "npm\s+(install|publish)"; then
  # Check for package.json
  if [ ! -f "package.json" ]; then
    echo "⚠️  WARNING: No package.json found"
    echo "This doesn't appear to be a Node.js project."
    echo "Command: $COMMAND"
    exit 1
  fi

  # Check for audit issues before install
  if echo "$COMMAND" | grep -q "npm install"; then
    if command -v npm-audit &> /dev/null; then
      echo "⚠️  Consider running 'npm audit' after install"
      echo "To check for security vulnerabilities."
    fi
  fi
fi

# ========== VALIDATION PASSED ==========
echo "✅ Command validation passed: $COMMAND"
exit 0
```

**Usage**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-commands.sh"
```

---

### Template 3: Secrets Detection

**Purpose**: Detect and block accidental secret exposure

**Script**: `/.claude/scripts/detect-secrets.sh`

```bash
#!/bin/bash
# Secrets Detection Guardrail
# Purpose: Prevent accidental commit of secrets to files

# ========== INPUT VALIDATION ==========
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "❌ ERROR: Insufficient arguments"
  echo "Usage: $0 <content> <filename>"
  exit 2
fi

CONTENT="$1"
FILENAME="$2"

# ========== SECURITY CHECKS ==========

# 1. Private key patterns
PRIVATE_KEY_PATTERNS=(
  "-----BEGIN [A-Z]+ PRIVATE KEY-----"    # Generic private key
  "-----BEGIN RSA PRIVATE KEY-----"       # RSA key
  "-----BEGIN DSA PRIVATE KEY-----"      # DSA key
  "-----BEGIN EC PRIVATE KEY-----"       # EC key
  "-----BEGIN OPENSSH PRIVATE KEY-----"  # OpenSSH key
)

for pattern in "${PRIVATE_KEY_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qF "$pattern"; then
    echo "❌ BLOCKED: Private key detected"
    echo "Pattern: $pattern"
    echo "Filename: $FILENAME"
    echo "Private keys should never be committed to files."
    echo "Use environment variables or secure secret management."
    exit 2
  fi
done

# 2. API key patterns
API_KEY_PATTERNS=(
  "api[_-]?key\s*[=:]\s*[A-Za-z0-9+/=]{20,}"      # api_key=...
  "secret[_-]?key\s*[=:]\s*[A-Za-z0-9+/=]{20,}"   # secret_key=...
  "access[_-]?token\s*[=:]\s*[A-Za-z0-9+/=]{20,}" # access_token=...
  "refresh[_-]?token\s*[=:]\s*[A-Za-z0-9+/=]{20,}"# refresh_token=...
)

for pattern in "${API_KEY_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qE "$pattern"; then
    echo "❌ BLOCKED: API key pattern detected"
    echo "Pattern: $pattern"
    echo "Filename: $FILENAME"
    echo "API keys should use environment variables."
    exit 2
  fi
done

# 3. Service-specific secret patterns
SERVICE_KEYS=(
  # OpenAI
  "sk-[A-Za-z0-9]{48}"                               # OpenAI API key
  # GitHub
  "ghp_[A-Za-z0-9]{36}"                              # GitHub personal access token
  # AWS
  "AKIA[0-9A-Z]{16}"                                 # AWS Access Key ID
  "aws_secret_access_key\s*[=:]\s*[A-Za-z0-9+/=]{40}" # AWS Secret
  # Google
  "AIza[0-9A-Za-z\\-_]{35}"                          # Google API key
  # Slack
  "xox[baprs]-[0-9A-Za-z-]{10,48}"                  # Slack token
  # Stripe
  "sk_live_[A-Za-z0-9]{24}"                          # Stripe secret key
  # Database URLs
  "[a-z]+://[^:]+:[^@]+@[^/]+"                       # Protocol://user:pass@host
)

for pattern in "${SERVICE_KEYS[@]}"; do
  if echo "$CONTENT" | grep -qE "$pattern"; then
    echo "❌ BLOCKED: Service-specific secret detected"
    echo "Pattern: $pattern"
    echo "Filename: $FILENAME"
    echo "Use environment variables for service credentials."
    exit 2
  fi
done

# 4. Check filename for sensitive files
SENSITIVE_FILENAMES=(
  "\.env"
  "\.env\."
  "\.aws/credentials"
  "\.aws/config"
  "\.kube/config"
  "\.ssh/id_"
  "\.google/credentials"
  "secrets\.txt"
  "passwords\.txt"
  "keys\.txt"
  "\.(key|pem|p12|pfx)$"
)

for pattern in "${SENSITIVE_FILENAMES[@]}"; do
  if [[ "$FILENAME" =~ $pattern ]]; then
    echo "❌ BLOCKED: Sensitive filename detected"
    echo "Pattern: $pattern"
    echo "Filename: $FILENAME"
    echo "Sensitive files should not be committed."
    echo "Add to .gitignore and use secure secret management."
    exit 2
  fi
done

# 5. Check for hardcoded passwords
if echo "$CONTENT" | grep -qiE "password\s*[=:]\s*['\"]?[^'\";\s]{8,}"; then
  echo "❌ BLOCKED: Hardcoded password detected"
  echo "Filename: $FILENAME"
  echo "Passwords should not be hardcoded in files."
  echo "Use environment variables or secret management."
  exit 2
fi

# 6. Certificate files (warn, don't block)
if [[ "$FILENAME" =~ \.(crt|pem)$ ]] && [[ "$FILENAME" != *\.pub ]]; then
  echo "⚠️  WARNING: Certificate file detected"
  echo "Filename: $FILENAME"
  echo "Ensure this is a public certificate, not a private key."
  echo "Private certificates should use secure management."
  exit 1
fi

# ========== VALIDATION PASSED ==========
echo "✅ No secrets detected in: $FILENAME"
exit 0
```

**Usage**:
```yaml
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/detect-secrets.sh"
```

**Note**: This script needs content passed as argument. For Write operations, use:
```bash
# Extract content from tool use
CONTENT="${args[1]}"
FILENAME="${args[0]}"
/.claude/scripts/detect-secrets.sh "$CONTENT" "$FILENAME"
```

---

### Template 4: Environment Validation

**Purpose**: Validate environment before production operations

**Script**: `/.claude/scripts/validate-env.sh`

```bash
#!/bin/bash
# Environment Validation Guardrail
# Purpose: Ensure correct environment for production operations

# ========== INPUT VALIDATION ==========
if [ -z "$1" ]; then
  echo "❌ ERROR: No command provided"
  exit 2
fi

COMMAND="$1"

# ========== SECURITY CHECKS ==========

# 1. Detect if this is a production operation
PROD_INDICATORS=(
  "prod"
  "production"
  "deploy"
  "start.*prod"
  "NODE_ENV.*production"
)

IS_PROD=false
for indicator in "${PROD_INDICATORS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$indicator"; then
    IS_PROD=true
    break
  fi
done

if [ "$IS_PROD" = false ]; then
  # Not a production command, skip validation
  exit 0
fi

echo "🔍 Validating production environment..."

# 2. Check NODE_ENV
if [ -n "$NODE_ENV" ]; then
  if [ "$NODE_ENV" != "production" ]; then
    echo "⚠️  WARNING: NODE_ENV mismatch"
    echo "Command suggests production: $COMMAND"
    echo "Current NODE_ENV: $NODE_ENV"
    echo "Expected NODE_ENV: production"
    echo "Set NODE_ENV=production for production operations."
    exit 1
  else
    echo "✅ NODE_ENV is correctly set to 'production'"
  fi
else
  echo "⚠️  WARNING: NODE_ENV not set"
  echo "Production operation detected but NODE_ENV is unset."
  echo "Set NODE_ENV=production explicitly."
  exit 1
fi

# 3. Check for production configuration files
if [ -f ".env.production" ]; then
  echo "✅ Production configuration found: .env.production"
elif [ -f "prod.env" ]; then
  echo "✅ Production configuration found: prod.env"
else
  echo "⚠️  WARNING: No production .env file found"
  echo "Expected: .env.production or prod.env"
  echo "Create production configuration before deploying."
  exit 1
fi

# 4. Check for critical environment variables
REQUIRED_VARS=(
  "DATABASE_URL"
  "API_KEY"
  "JWT_SECRET"
)

MISSING_VARS=()
for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    MISSING_VARS+=("$var")
  fi
done

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
  echo "❌ BLOCKED: Missing required environment variables:"
  for var in "${MISSING_VARS[@]}"; do
    echo "  - $var"
  done
  echo "Set all required variables before production deployment."
  exit 2
else
  echo "✅ All required environment variables are set"
fi

# 5. Check git status
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
  echo "⚠️  WARNING: Uncommitted changes detected"
  echo "Deploying with uncommitted changes:"
  git diff --name-only | head -5
  echo "Commit changes before deploying to production."
  exit 1
fi

# 6. Check for .env files in git (should be ignored)
if git ls-files --error-unmatch .env .env.* 2>/dev/null; then
  echo "❌ BLOCKED: .env files tracked in git"
  echo "Environment files should be in .gitignore"
  echo "Use .env.example for templates instead."
  exit 2
fi

# 7. Validate database URL is not localhost
if [ -n "$DATABASE_URL" ]; then
  if echo "$DATABASE_URL" | grep -q "localhost\|127.0.0.1"; then
    echo "❌ BLOCKED: Localhost database in production"
    echo "Use production database URL, not localhost."
    exit 2
  fi
fi

# ========== VALIDATION PASSED ==========
echo "✅ Production environment validation passed"
echo "NODE_ENV: $NODE_ENV"
echo "Configuration: $(ls -1 .env.production prod.env 2>/dev/null | head -1)"
exit 0
```

**Usage**:
```yaml
hooks:
  PreToolUse:
    - matcher:
        tool: "Bash"
        command: "npm.*run.*prod"
      hooks:
        - type: command
          command: "./.claude/scripts/validate-env.sh"
```

---

### Template 5: Database Protection

**Purpose**: Protect against accidental data deletion

**Script**: `/.claude/scripts/guard-database.sh`

```bash
#!/bin/bash
# Database Protection Guardrail
# Purpose: Prevent accidental data deletion or production database access

# ========== INPUT VALIDATION ==========
if [ -z "$1" ]; then
  echo "❌ ERROR: No command provided"
  exit 2
fi

COMMAND="$1"
ENVIRONMENT="${ENVIRONMENT:-development}"

# ========== SECURITY CHECKS ==========

# 1. Dangerous database patterns
DROP_PATTERNS=(
  "--drop"                         # Drop database/table
  "DROP\s+DATABASE"                # SQL DROP DATABASE
  "DROP\s+TABLE"                   # SQL DROP TABLE
  "DROP\s+SCHEMA"                  # SQL DROP SCHEMA
  "DROP\s+INDEX"                  # SQL DROP INDEX
  "FLUSHALL"                       # Redis flush all
  "FLUSHDB"                        # Redis flush db
  "DEL\s+\*"                      # Delete all keys
  "TRUNCATE\s+TABLE"              # Truncate table
  "DELETE\s+FROM\s+\w+\s*;"       # Delete all from table
  "rm\s+-rf.*data"                # Delete data directory
)

for pattern in "${DROP_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "❌ BLOCKED: Dangerous database operation detected"
    echo "Pattern: $pattern"
    echo "Command: $COMMAND"
    echo "Environment: $ENVIRONMENT"

    if [[ "$ENVIRONMENT" == "production" ]]; then
      echo ""
      echo "⚠️  CRITICAL: This will affect PRODUCTION data"
      echo "This operation is blocked for safety."
      echo "If you need to proceed, verify:"
      echo "1. You have a recent backup"
      echo "2. This is intentional"
      echo "3. You understand the consequences"
      exit 2
    else
      echo ""
      echo "⚠️  WARNING: This will delete data"
      echo "Environment: $ENVIRONMENT"
      echo "Make sure you have a backup."
      echo "Add --force to command to bypass this warning."
      exit 1
    fi
  fi
done

# 2. Check for production database in development
if [[ "$ENVIRONMENT" != "production" ]]; then
  # AWS patterns
  if echo "$COMMAND" | grep -qiE "prod.*\.rds\.amazonaws\.com\|prod.*\.dynamodb\.amazonaws\.com"; then
    echo "⚠️  WARNING: Production AWS database detected"
    echo "Environment: $ENVIRONMENT"
    echo "Ensure you are not connecting to production by mistake."
    exit 1
  fi

  # GCP patterns
  if echo "$COMMAND" | grep -qiE "prod.*\.cloud\.sql\|prod.*\.mongo\.net"; then
    echo "⚠️  WARNING: Production GCP database detected"
    echo "Environment: $ENVIRONMENT"
    echo "Ensure you are not connecting to production by mistake."
    exit 1
  fi

  # Azure patterns
  if echo "$COMMAND" | grep -qiE "prod.*\.database\.windows\.net\|prod.*\.mongo\.net"; then
    echo "⚠️  WARNING: Production Azure database detected"
    echo "Environment: $ENVIRONMENT"
    echo "Ensure you are not connecting to production by mistake."
    exit 1
  fi
fi

# 3. Check for backup before drop operations
if echo "$COMMAND" | grep -qiE "DROP|TRUNCATE|DELETE"; then
  echo "⚠️  WARNING: Data modification operation detected"
  echo "Command: $COMMAND"
  echo ""
  echo "Before proceeding, verify:"
  echo "1. Recent backup exists"
  echo "2. This is intentional"
  echo "3. Changes are tested in dev/staging first"
  echo ""
  echo "Consider using transactions for safety."
  exit 1
fi

# ========== VALIDATION PASSED ==========
echo "✅ Database validation passed"
echo "Environment: $ENVIRONMENT"
exit 0
```

---

### Template 6: Build Safety

**Purpose**: Validate build operations

**Script**: `/.claude/scripts/validate-build.sh`

```bash
#!/bin/bash
# Build Safety Guardrail
# Purpose: Ensure safe and correct build operations

# ========== INPUT VALIDATION ==========
if [ -z "$1" ]; then
  echo "❌ ERROR: No command provided"
  exit 2
fi

COMMAND="$1"

# ========== SECURITY CHECKS ==========

# 1. Check for node_modules before npm operations
if echo "$COMMAND" | grep -qE "npm"; then
  if [ ! -d "node_modules" ]; then
    echo "⚠️  WARNING: node_modules not found"
    echo "Command: $COMMAND"
    echo "Run 'npm install' before building or running"
    exit 1
  fi
fi

# 2. TypeScript compilation checks
if echo "$COMMAND" | grep -qE "(tsc|build)"; then
  # Check for tsconfig.json
  if [ ! -f "tsconfig.json" ]; then
    echo "⚠️  WARNING: tsconfig.json not found"
    echo "TypeScript configuration may be missing"
    echo "Command: $COMMAND"
    exit 1
  fi

  # Check if TypeScript is installed
  if ! command -v tsc &> /dev/null; then
    echo "❌ BLOCKED: TypeScript compiler not found"
    echo "Install TypeScript: npm install -g typescript"
    exit 2
  fi

  # Warn about linting
  if [ -f "package.json" ]; then
    if grep -q '"lint"' package.json 2>/dev/null; then
      echo "⚠️  Consider running lint before build"
      echo "Found 'lint' script in package.json"
      echo "Run: npm run lint && npm run build"
      exit 1
    fi
  fi
fi

# 3. Docker build checks
if echo "$COMMAND" | grep -qE "docker build"; then
  # Check if Docker is installed
  if ! command -v docker &> /dev/null; then
    echo "❌ BLOCKED: Docker not found"
    echo "Install Docker or use --dockerfile to specify path"
    exit 2
  fi

  # Check for .dockerignore
  if [ ! -f ".dockerignore" ]; then
    echo "⚠️  WARNING: .dockerignore not found"
    echo "Consider creating .dockerignore for smaller images"
    echo "Add: node_modules, .git, .env"
    exit 1
  fi

  # Warn about Dockerfile location
  if [ ! -f "Dockerfile" ]; then
    echo "⚠️  WARNING: Dockerfile not found in current directory"
    echo "Specify path: docker build -f path/to/Dockerfile ."
    exit 1
  fi
fi

# 4. Check for security vulnerabilities (npm audit)
if echo "$COMMAND" | grep -qE "(npm install|build)"; then
  if command -v npm-audit &> /dev/null; then
    echo "ℹ️  Info: Consider running 'npm audit' to check for vulnerabilities"
    echo "High severity vulnerabilities should be fixed before production."
  fi
fi

# 5. Python build checks
if echo "$COMMAND" | grep -qE "(pip|python)"; then
  # Check for requirements.txt
  if [ ! -f "requirements.txt" ] && [ ! -f "Pipfile" ] && [ ! -f "pyproject.toml" ]; then
    echo "⚠️  WARNING: No Python dependency file found"
    echo "Expected: requirements.txt, Pipfile, or pyproject.toml"
    exit 1
  fi

  # Check virtual environment
  if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️  WARNING: No virtual environment detected"
    echo "Consider using a virtual environment for Python"
    echo "Create: python -m venv venv"
    echo "Activate: source venv/bin/activate"
    exit 1
  fi
fi

# ========== VALIDATION PASSED ==========
echo "✅ Build validation passed: $COMMAND"
exit 0
```

---

## Advanced Templates

### Template 7: Custom Skill Validation

**Purpose**: Skill-specific validation logic

**Script**: `/.claude/scripts/validate-skill.sh`

```bash
#!/bin/bash
# Skill-Specific Validation
# Purpose: Validate operations for specific skills

# Get skill name from environment
SKILL_NAME="${CLAUDE_SKILL_NAME:-unknown}"
COMMAND="${1:-}"

case "$SKILL_NAME" in
  "deploy-skill")
    # Special validation for deployment skill
    if echo "$COMMAND" | grep -qE "(prod|production)"; then
      if [ "$ENVIRONMENT" != "production" ]; then
        echo "❌ BLOCKED: Production deploy in non-production environment"
        echo "Environment: $ENVIRONMENT"
        exit 2
      fi
    fi
    ;;

  "database-skill")
    # Special validation for database skill
    if echo "$COMMAND" | grep -qE "(DROP|DELETE|TRUNCATE)"; then
      echo "⚠️  WARNING: Destructive database operation"
      echo "Skill: $SKILL_NAME"
      echo "Ensure you have a backup"
      exit 1
    fi
    ;;

  "file-skill")
    # Special validation for file operations
    if [ ! -f ".gitignore" ]; then
      echo "⚠️  WARNING: No .gitignore found"
      echo "Ensure sensitive files are not committed"
      exit 1
    fi
    ;;

  *)
    # Default validation for unknown skills
    echo "ℹ️  Info: No specific validation for skill: $SKILL_NAME"
    ;;
esac

echo "✅ Skill validation passed: $SKILL_NAME"
exit 0
```

---

## Testing Templates

### Test Script: test-guardrails.sh

```bash
#!/bin/bash
# Test All Guardrails
# Purpose: Verify all guardrail scripts work correctly

echo "🧪 Testing Guardrail Scripts"
echo "=============================="

# Test 1: Path validation
echo ""
echo "Test 1: Path validation"
echo "Testing dangerous path..."
if ./.claude/scripts/guard-paths.sh "../../../etc/passwd" 2>&1 | grep -q "BLOCKED"; then
  echo "✅ Path validation blocks dangerous paths"
else
  echo "❌ Path validation failed"
fi

# Test 2: Command validation
echo ""
echo "Test 2: Command validation"
echo "Testing dangerous command..."
if ./.claude/scripts/guard-commands.sh "rm -rf /" 2>&1 | grep -q "BLOCKED"; then
  echo "✅ Command validation blocks dangerous commands"
else
  echo "❌ Command validation failed"
fi

# Test 3: Secrets detection
echo ""
echo "Test 3: Secrets detection"
echo "Testing API key pattern..."
if ./.claude/scripts/detect-secrets.sh "api_key=sk-1234567890123456789012345678901234567890" "config.js" 2>&1 | grep -q "BLOCKED"; then
  echo "✅ Secrets detection blocks API keys"
else
  echo "❌ Secrets detection failed"
fi

# Test 4: Safe operations
echo ""
echo "Test 4: Safe operations"
echo "Testing safe file write..."
if ./.claude/scripts/guard-paths.sh "src/app.js" 2>&1 | grep -q "passed"; then
  echo "✅ Safe operations pass validation"
else
  echo "❌ Safe operations failed"
fi

echo ""
echo "=============================="
echo "🎉 Guardrail testing complete"
```

---

## Best Practices

### Script Writing Guidelines

1. **Always validate inputs**
   ```bash
   if [ -z "$1" ]; then
     echo "❌ ERROR: No argument provided"
     exit 2
   fi
   ```

2. **Use descriptive error messages**
   ```bash
   echo "❌ BLOCKED: [reason]"
   echo "Context: [details]"
   echo "Solution: [guidance]"
   exit 2
   ```

3. **Log validation results**
   ```bash
   echo "✅ Path validation passed: $PATH"
   ```

4. **Make scripts idempotent**
   - Running multiple times should produce same result
   - Don't leave side effects

5. **Keep scripts fast**
   - No expensive operations
   - Fast pattern matching
   - Minimal file I/O

### Exit Code Best Practices

| Exit Code | Meaning | Example |
|-----------|---------|---------|
| 0 | Success, operation allowed | Valid file write |
| 1 | Warning, operation allowed | Non-critical issues |
| 2 | Blocking, operation denied | Dangerous operation |

### Security Checklist

For each script:
- [ ] Input validation
- [ ] Pattern matching for threats
- [ ] Appropriate exit codes
- [ ] Clear error messages
- [ ] No hardcoded secrets
- [ ] Executable permissions set
- [ ] Fast execution (<100ms)
- [ ] Tested with dangerous inputs

---

## Troubleshooting

### Scripts Not Executing
```bash
# Check permissions
ls -la .claude/scripts/

# Make executable
chmod +x .claude/scripts/*.sh

# Test directly
./.claude/scripts/guard-paths.sh test.txt
```

### False Positives
```bash
# Add exceptions
if [[ "$PATH" == "test/fixtures/"* ]]; then
  echo "✅ Test fixtures allowed"
  exit 0
fi
```

### Performance Issues
```bash
# Add timing
START=$(date +%s.%N)
# ... validation logic ...
END=$(date +%s.%N)
echo "⏱️  Duration: $(echo "$END - $START" | bc)s"
```

---

## Quick Reference

| Script | Purpose | Hook Type |
|--------|---------|-----------|
| `guard-paths.sh` | Validate file paths | PreToolUse (Write) |
| `guard-commands.sh` | Block dangerous commands | PreToolUse (Bash) |
| `detect-secrets.sh` | Prevent secret exposure | PreToolUse (Write) |
| `validate-env.sh` | Check production environment | PreToolUse (Bash) |
| `guard-database.sh` | Protect against data deletion | PreToolUse (Bash) |
| `validate-build.sh` | Validate build operations | PreToolUse (Bash) |

All scripts follow the same structure:
1. Input validation
2. Security checks
3. Action (allow/block/warn)
4. Exit with appropriate code
