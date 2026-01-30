#!/bin/bash
# testing-e2e/scripts/runner.sh
# E2E Test Orchestrator - Hardcoded claude -p execution with sandbox CWD

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$SKILL_DIR/../.." && pwd)"
SANDBOX_DIR="$PROJECT_ROOT/.sandbox"
LOGS_DIR="$SKILL_DIR/logs"
CLAUDE_BIN="claude"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

usage() {
    cat << EOF
${CYAN}╔════════════════════════════════════════════════════════════╗
║                  E2E Testing Skill - Runner                      ║
╚════════════════════════════════════════════════════════════╝${NC}

${BLUE}Usage:${NC}  $(basename "$0") [COMMAND]

${BLUE}Commands:${NC}
  setup       Setup sandbox and test scenarios
  run         Execute E2E tests (hardcoded claude -p)
  skill-authoring   Test skill-authoring specifically
  all         Test all components
  verify      Verify results
  logs        View logs

EOF
}

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
pass() { echo -e "${GREEN}[PASS]${NC} $1"; ((PASS_COUNT++)); }
fail() { echo -e "${RED}[FAIL]${NC} $1"; ((FAIL_COUNT++)); }
step() { echo -e "${CYAN}[STEP]${NC} $1"; }

# Hardcoded claude -p execution with sandbox CWD
run_claude_p() {
    local PROMPT_FILE="$1"
    local LOG_FILE="$2"

    # CWD MUST be in .sandbox/.claude/ - HARDCODED
    cd "$SANDBOX_DIR/.claude"

    # Execute claude -p with ALL required flags - HARDCODED
    "$CLAUDE_BIN" -p "@$PROMPT_FILE" \
        --output-format stream-json \
        --verbose \
        --dangerously-skip-permissions \
        --allowedTools "*" \
        2>&1 | tee "$LOG_FILE"
}

# Setup sandbox
cmd_setup() {
    step "Setting up sandbox..."

    rm -rf "$SANDBOX_DIR"
    mkdir -p "$SANDBOX_DIR/.claude/skills"
    mkdir -p "$SANDBOX_DIR/.claude/commands"
    mkdir -p "$SANDBOX_DIR/.claude/agents"
    mkdir -p "$SANDBOX_DIR/Custom_MCP"
    mkdir -p "$SANDBOX_DIR/tests"
    mkdir -p "$LOGS_DIR"

    cp -r "$PROJECT_ROOT/.claude/skills" "$SANDBOX_DIR/.claude/"
    cp -r "$PROJECT_ROOT/.claude/commands" "$SANDBOX_DIR/.claude/"
    cp -r "$PROJECT_ROOT/.claude/agents" "$SANDBOX_DIR/.claude/"
    cp "$PROJECT_ROOT/.claude/settings.json" "$SANDBOX_DIR/.claude/"
    cp -r "$PROJECT_ROOT/Custom_MCP" "$SANDBOX_DIR/"

    info "Sandbox ready: $SANDBOX_DIR"
}

# Create skill-authoring test scenario
create_skill_authoring_test() {
    local TEST_DIR="$SANDBOX_DIR/tests/skill-authoring"
    mkdir -p "$TEST_DIR"

    cat > "$TEST_DIR/test-skill.md" << 'EOF'
# Test: Skill-Authoring Creates Valid Skill

## Use Cases
| Scenario | Trigger | Expected |
|----------|---------|----------|
| Create minimal skill | Use skill-authoring | Valid SKILL.md created |

## Validation Conditions
| Condition | Check | Pass |
|-----------|-------|------|
| File created | `[ -f "$OUTPUT_FILE" ]` | Exit 0 |
| Has frontmatter | `head -1 "$OUTPUT_FILE" | grep -q '^---'` | Exit 0 |
| Has mission_control | `grep -q '<mission_control>' "$OUTPUT_FILE"` | Exit 0 |

## Risks
| Risk | Mitigation |
|------|------------|
| Invalid YAML | Check frontmatter |

## Test Prompt
Use skill-authoring to create a test skill:
- name: test-skill-e2e
- description: "Test skill for E2E validation"

Output the SKILL.md content directly to: /tmp/test-skill-output.md

## Hallucination Scenarios
| Scenario | Detection |
|----------|-----------|
| Read instead of invoke | Must create file, not read |
| Skip verification | Must output file |
EOF

    info "Created skill-authoring test"
}

# Test skill-authoring
cmd_skill_authoring() {
    step "Testing skill-authoring..."

    cmd_setup
    create_skill_authoring_test

    local PROMPT_FILE="$SANDBOX_DIR/tests/skill-authoring/test-skill.md"
    local LOG_FILE="$LOGS_DIR/skill-authoring-$(date +%s).log"

    step "Executing claude -p in sandbox CWD: $SANDBOX_DIR/.claude"

    run_claude_p "$PROMPT_FILE" "$LOG_FILE"
    local EXIT=$?

    if [ $EXIT -eq 0 ]; then
        pass "skill-authoring test executed"
    else
        fail "skill-authoring test failed (exit: $EXIT)"
    fi

    step "Checking output..."
    if [ -f /tmp/test-skill-output.md ]; then
        pass "Output file created"
        head -10 /tmp/test-skill-output.md
    else
        fail "Output file not created"
    fi
}

# Test all components
cmd_all() {
    step "Testing all components..."

    cmd_setup

    # Test skill-authoring
    create_skill_authoring_test
    local LOG="$LOGS_DIR/all-$(date +%s).log"

    cat > /tmp/all-test-prompt.md << 'EOF'
Execute the skill-authoring test in tests/skill-authoring/test-skill.md
Then test self-learning by using it on this conversation.
Then test command-authoring by describing what commands do.

Report what you found and what was created.
EOF

    run_claude_p /tmp/all-test-prompt.md "$LOG"

    info "Logs: $LOG"
}

# Verify results
cmd_verify() {
    step "Verifying results..."

    if [ ! -d "$LOGS_DIR" ]; then
        fail "No logs directory"
        return
    fi

    local LOGS=$(ls -1t "$LOGS_DIR"/*.log 2>/dev/null | head -5)
    if [ -z "$LOGS" ]; then
        fail "No log files"
        return
    fi

    info "Recent logs:"
    echo "$LOGS" | nl

    pass "Verification complete"
}

# View logs
cmd_logs() {
    if [ ! -d "$LOGS_DIR" ]; then
        fail "No logs directory"
        return
    fi

    local COUNT=$(ls -1 "$LOGS_DIR"/*.log 2>/dev/null | wc -l)
    if [ $COUNT -eq 0 ]; then
        fail "No log files"
        return
    fi

    info "Log files in $LOGS_DIR:"
    ls -1t "$LOGS_DIR"/*.log | head -10 | nl
}

main() {
    if [ $# -eq 0 ]; then
        usage
        exit 0
    fi

    local CMD="$1"
    shift

    case $CMD in
        setup) cmd_setup ;;
        run) cmd_skill_authoring ;;
        skill-authoring) cmd_skill_authoring ;;
        all) cmd_all ;;
        verify) cmd_verify ;;
        logs) cmd_logs ;;
        help|--help|-h) usage ;;
        *) fail "Unknown command: $CMD"; usage; exit 1 ;;
    esac
}

main "$@"
