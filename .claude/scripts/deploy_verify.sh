#!/usr/bin/env bash
# Production Deployment Verification Script
# Validates all components before production deployment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3"
CLAUDE_DIR="${PROJECT_ROOT}/.claude"
ERROR_COUNT=0
WARNING_COUNT=0

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNING_COUNT++))
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ((ERROR_COUNT++))
}

log_header() {
    echo ""
    echo "=============================================="
    echo "$1"
    echo "=============================================="
}

run_check() {
    local check_name="$1"
    local check_command="$2"
    ((TOTAL_CHECKS++))

    echo -n "Checking: $check_name ... "

    if eval "$check_command" &>/dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASSED_CHECKS++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        log_error "Failed check: $check_name"
        return 1
    fi
}

# Start verification
clear
echo "================================================"
echo "  PRODUCTION DEPLOYMENT VERIFICATION"
echo "  thecattoolkit_v3"
echo "================================================"
echo ""

# 1. Directory Structure Validation
log_header "1. DIRECTORY STRUCTURE VALIDATION"

run_check ".claude directory exists" "[ -d '${CLAUDE_DIR}' ]"
run_check "skills directory exists" "[ -d '${CLAUDE_DIR}/skills' ]"
run_check "rules directory exists" "[ -d '${CLAUDE_DIR}/rules' ]"
run_check "agents directory exists" "[ -d '${CLAUDE_DIR}/agents' ]"
run_check "MCP config exists" "[ -f '${PROJECT_ROOT}/.mcp.json' ]"

# 2. Skills Validation
log_header "2. SKILLS VALIDATION"

SKILL_COUNT=$(find "${CLAUDE_DIR}/skills" -name "SKILL.md" -type f | wc -l)
log_info "Found $SKILL_COUNT skills"

# Check each skill
for skill in "${CLAUDE_DIR}/skills"/*/SKILL.md; do
    if [ -f "$skill" ]; then
        skill_name=$(basename "$(dirname "$skill")")
        run_check "Skill: $skill_name (YAML valid)" "python3 -c 'import yaml; yaml.safe_load(open(\"$skill\"))'"
        run_check "Skill: $skill_name (has description)" "grep -q 'description:' '$skill'"
    fi
done

# 3. Rules Validation
log_header "3. RULES VALIDATION"

run_check "Architecture rules exist" "[ -f '${CLAUDE_DIR}/rules/architecture.md' ]"
run_check "Anti-patterns exist" "[ -f '${CLAUDE_DIR}/rules/anti-patterns.md' ]"
run_check "Philosophy rules exist" "[ -f '${CLAUDE_DIR}/rules/philosophy.md' ]"
run_check "Quality framework exist" "[ -f '${CLAUDE_DIR}/rules/quality-framework.md' ]"

# 4. MCP Configuration Validation
log_header "4. MCP CONFIGURATION VALIDATION"

run_check "MCP config is valid JSON" "python3 -c 'import json; json.load(open(\"${PROJECT_ROOT}/.mcp.json\"))'"

# Validate MCP servers
log_info "Checking MCP servers..."
if command -v npx &> /dev/null; then
    log_info "npx is available"
else
    log_warn "npx not found - some MCP servers may not work"
fi

# 5. Git Repository Validation
log_header "5. GIT REPOSITORY VALIDATION"

run_check "Git repository is clean" "cd '${PROJECT_ROOT}' && [ -z \"\$(git status --porcelain)\" ]"
run_check "Git repository has commits" "cd '${PROJECT_ROOT}' && git rev-parse HEAD &>/dev/null"

# 6. File Permissions Validation
log_header "6. FILE PERMISSIONS VALIDATION"

run_check "CLAUDE.md is readable" "[ -r '${PROJECT_ROOT}/CLAUDE.md' ]"
run_check "Project is readable" "cd '${PROJECT_ROOT}' && find . -type f -name '*.md' -o -name '*.json' | head -1 | xargs test -r"

# 7. Critical Skills Check
log_header "7. CRITICAL SKILLS CHECK"

CRITICAL_SKILLS=(
    "create-skill"
    "create-mcp-server"
    "create-hook"
    "agent-development"
    "knowledge-skills"
    "meta-critic"
)

for critical_skill in "${CRITICAL_SKILLS[@]}"; do
    if [ -f "${CLAUDE_DIR}/skills/${critical_skill}/SKILL.md" ]; then
        run_check "Critical skill: $critical_skill exists" "true"
    else
        log_error "Critical skill missing: $critical_skill"
        run_check "Critical skill: $critical_skill exists" "false"
    fi
done

# 8. Documentation Quality Check
log_header "8. DOCUMENTATION QUALITY CHECK"

run_check "CLAUDE.md exists" "[ -f '${PROJECT_ROOT}/CLAUDE.md' ]"
CLAUDE_SIZE=$(wc -l < "${PROJECT_ROOT}/CLAUDE.md")
if [ "$CLAUDE_SIZE" -lt 100 ]; then
    log_warn "CLAUDE.md seems short ($CLAUDE_SIZE lines)"
else
    log_info "CLAUDE.md size OK ($CLAUDE_SIZE lines)"
fi

# Summary
log_header "VERIFICATION SUMMARY"
echo ""
echo "Total Checks: $TOTAL_CHECKS"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$ERROR_COUNT${NC}"
echo -e "Warnings: ${YELLOW}$WARNING_COUNT${NC}"
echo ""

# Calculate score
if [ $TOTAL_CHECKS -gt 0 ]; then
    SCORE=$(( (PASSED_CHECKS * 100) / TOTAL_CHECKS ))
    echo "Score: $SCORE%"
    echo ""
fi

if [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ VERIFICATION PASSED${NC}"
    echo "Ready for production deployment!"
    exit 0
else
    echo -e "${RED}✗ VERIFICATION FAILED${NC}"
    echo "Fix $ERROR_COUNT error(s) before deployment"
    exit 1
fi
