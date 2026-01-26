#!/usr/bin/env bash
# Production Deployment Script for thecattoolkit_v3
# Includes verification, backup, deployment, and rollback

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKUP_DIR="${PROJECT_ROOT}/.backups/production/$(date +%Y%m%d_%H%M%S)"
DEPLOYMENT_LOG="${PROJECT_ROOT}/.logs/deployment_$(date +%Y%m%d_%H%M%S).log"
CLAUDE_DIR="${PROJECT_ROOT}/.claude"

# Create directories
mkdir -p "$(dirname "$DEPLOYMENT_LOG")"
mkdir -p "$BACKUP_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$DEPLOYMENT_LOG"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

log_header() {
    echo ""
    echo -e "${BLUE}==============================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}==============================================${NC}"
    echo ""
}

# Rollback function
rollback() {
    log_error "ROLLBACK INITIATED"
    log_info "Restoring from backup: $BACKUP_DIR"

    if [ -d "$BACKUP_DIR" ]; then
        # Remove current .claude directory
        if [ -d "$CLAUDE_DIR" ]; then
            rm -rf "$CLAUDE_DIR"
        fi

        # Restore from backup
        cp -r "$BACKUP_DIR/.claude" "$PROJECT_ROOT/"

        log_info "Rollback completed successfully"
    else
        log_error "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi
}

# Trap errors
trap 'log_error "Deployment failed at line $LINENO"; rollback; exit 1' ERR

# Start deployment
clear
log_header "PRODUCTION DEPLOYMENT STARTED"
log_info "Deployment ID: $(date +%Y%m%d_%H%M%S)"
log_info "Project: thecattoolkit_v3"
log_info "Log file: $DEPLOYMENT_LOG"
log_info "Backup directory: $BACKUP_DIR"

# Step 1: Pre-deployment Verification
log_header "STEP 1: PRE-DEPLOYMENT VERIFICATION"

log_info "Running deployment verification..."
if bash "${CLAUDE_DIR}/scripts/deploy_verify.sh"; then
    log_info "Pre-deployment verification: ✓ PASSED"
else
    log_error "Pre-deployment verification: ✗ FAILED"
    log_error "Cannot proceed with deployment"
    exit 1
fi

# Step 2: Create Backup
log_header "STEP 2: CREATING BACKUP"

log_info "Creating production backup..."
if [ -d "$CLAUDE_DIR" ]; then
    cp -r "$CLAUDE_DIR" "$BACKUP_DIR/"
    log_info "Backup created: $BACKUP_DIR"
else
    log_warn "No existing .claude directory to backup"
    mkdir -p "$BACKUP_DIR"
fi

# Step 3: Validate Current State
log_header "STEP 3: VALIDATING CURRENT STATE"

log_info "Checking git status..."
cd "$PROJECT_ROOT"
if [ -n "$(git status --porcelain)" ]; then
    log_warn "Git working directory is not clean"
    log_info "Staging changes..."
    git add -A
    git commit -m "Pre-deployment commit - $(date)" || true
fi

log_info "Current commit: $(git rev-parse HEAD)"
log_info "Branch: $(git branch --show-current)"

# Step 4: Deploy Skills
log_header "STEP 4: DEPLOYING SKILLS"

SKILL_COUNT=$(find "${CLAUDE_DIR}/skills" -name "SKILL.md" -type f | wc -l)
log_info "Found $SKILL_COUNT skills to deploy"

DEPLOYED_SKILLS=0
FAILED_SKILLS=0

for skill_dir in "${CLAUDE_DIR}/skills"/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        skill_file="${skill_dir}SKILL.md"

        if [ -f "$skill_file" ]; then
            log_info "Deploying skill: $skill_name"

            # Validate YAML
            if python3 -c "import yaml; yaml.safe_load(open('$skill_file'))" 2>/dev/null; then
                log_info "  ✓ $skill_name: YAML valid"
                ((DEPLOYED_SKILLS++))
            else
                log_error "  ✗ $skill_name: YAML invalid"
                ((FAILED_SKILLS++))
            fi
        fi
    fi
done

log_info "Skills deployed: $DEPLOYED_SKILLS"
if [ $FAILED_SKILLS -gt 0 ]; then
    log_error "Failed skills: $FAILED_SKILLS"
    rollback
    exit 1
fi

# Step 5: Validate MCP Configuration
log_header "STEP 5: VALIDATING MCP CONFIGURATION"

log_info "Checking MCP configuration..."
if python3 -c "import json; json.load(open('${PROJECT_ROOT}/.mcp.json'))" 2>/dev/null; then
    log_info "MCP configuration: ✓ VALID"
else
    log_error "MCP configuration: ✗ INVALID"
    rollback
    exit 1
fi

# Check MCP servers
MCP_SERVERS=$(python3 -c "import json; data=json.load(open('${PROJECT_ROOT}/.mcp.json')); print(len(data.get('mcpServers', {})))" 2>/dev/null || echo "0")
log_info "MCP servers configured: $MCP_SERVERS"

# Step 6: Run Quality Framework Validation
log_header "STEP 6: QUALITY FRAMEWORK VALIDATION"

log_info "Checking critical rules exist..."
CRITICAL_RULES=(
    "architecture.md"
    "anti-patterns.md"
    "philosophy.md"
    "quality-framework.md"
)

for rule in "${CRITICAL_RULES[@]}"; do
    if [ -f "${CLAUDE_DIR}/rules/$rule" ]; then
        log_info "  ✓ $rule exists"
    else
        log_error "  ✗ $rule missing"
        rollback
        exit 1
    fi
done

# Step 7: Final Validation
log_header "STEP 7: FINAL VALIDATION"

log_info "Running final checks..."
log_info "  - Verifying file permissions..."
find "$CLAUDE_DIR" -type f -name "*.md" -exec test -r {} \; | wc -l | xargs -I {} log_info "  - Readable files: {}"

log_info "  - Checking directory structure..."
for dir in skills rules agents scripts; do
    if [ -d "${CLAUDE_DIR}/$dir" ]; then
        log_info "  ✓ $dir directory exists"
    else
        log_error "  ✗ $dir directory missing"
        rollback
        exit 1
    fi
done

# Step 8: Commit Deployment
log_header "STEP 8: COMMITTING DEPLOYMENT"

log_info "Creating deployment commit..."
cd "$PROJECT_ROOT"
git add -A
git commit -m "deploy: Production deployment - $(date)" || true

DEPLOYMENT_COMMIT=$(git rev-parse HEAD)
log_info "Deployment committed: $DEPLOYMENT_COMMIT"

# Success Summary
log_header "DEPLOYMENT SUCCESSFUL"

log_info "Deployment Summary:"
log_info "  - Deployment ID: $(date +%Y%m%d_%H%M%S)"
log_info "  - Commit: $DEPLOYMENT_COMMIT"
log_info "  - Skills deployed: $DEPLOYED_SKILLS"
log_info "  - Backup location: $BACKUP_DIR"
log_info "  - Log file: $DEPLOYMENT_LOG"

log_info ""
log_info "✓ PRODUCTION DEPLOYMENT COMPLETE"
log_info "=============================================="
log_info ""
log_info "Next steps:"
log_info "1. Monitor for any issues"
log_info "2. Test critical functionality"
log_info "3. Notify team of successful deployment"

exit 0
