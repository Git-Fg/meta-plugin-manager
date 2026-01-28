#!/bin/bash
# Hook Testing Helper
# Tests a hook with sample input and shows output

set -euo pipefail

# Usage
show_usage() {
  echo "Usage: $0 [options] <hook-script> <test-input.json>"
  echo ""
  echo "Options:"
  echo "  -h, --help      Show this help message"
  echo "  -v, --verbose   Show detailed execution information"
  echo "  -t, --timeout N Set timeout in seconds (default: 60)"
  echo ""
  echo "Examples:"
  echo "  $0 validate-bash.sh test-input.json"
  echo "  $0 -v -t 30 validate-write.sh write-input.json"
  echo ""
  echo "Creates sample test input with:"
  echo "  $0 --create-sample <event-type>"
  exit 0
}

# Create sample input
create_sample() {
  event_type="$1"

  case "$event_type" in
    PreToolUse)
      cat <<'EOF'
{
  "session_id": "test-session",
  "transcript_path": "/tmp/transcript.txt",
  "cwd": "/tmp/test-project",
  "permission_mode": "ask",
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/tmp/test.txt",
    "content": "Test content"
  }
}
EOF
      ;;
    PostToolUse)
      cat <<'EOF'
{
  "session_id": "test-session",
  "transcript_path": "/tmp/transcript.txt",
  "cwd": "/tmp/test-project",
  "permission_mode": "ask",
  "hook_event_name": "PostToolUse",
  "tool_name": "Bash",
  "tool_result": "Command executed successfully"
}
EOF
      ;;
    Stop|SubagentStop)
      cat <<'EOF'
{
  "session_id": "test-session",
  "transcript_path": "/tmp/transcript.txt",
  "cwd": "/tmp/test-project",
  "permission_mode": "ask",
  "hook_event_name": "Stop",
  "reason": "Task appears complete"
}
EOF
      ;;
    UserPromptSubmit)
      cat <<'EOF'
{
  "session_id": "test-session",
  "transcript_path": "/tmp/transcript.txt",
  "cwd": "/tmp/test-project",
  "permission_mode": "ask",
  "hook_event_name": "UserPromptSubmit",
  "user_prompt": "Test user prompt"
}
EOF
      ;;
    SessionStart|SessionEnd)
      cat <<'EOF'
{
  "session_id": "test-session",
  "transcript_path": "/tmp/transcript.txt",
  "cwd": "/tmp/test-project",
  "permission_mode": "ask",
  "hook_event_name": "SessionStart"
}
EOF
      ;;
    *)
      echo "Unknown event type: $event_type"
      echo "Valid types: PreToolUse, PostToolUse, Stop, SubagentStop, UserPromptSubmit, SessionStart, SessionEnd"
      exit 1
      ;;
  esac
}

# Parse arguments
VERBOSE=false
TIMEOUT=60

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      show_usage
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -t|--timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    --create-sample)
      create_sample "$2"
      exit 0
      ;;
    *)
      break
      ;;
  esac
done

if [ $# -ne 2 ]; then
  echo "❌ VALIDATION FAILED: Missing arguments"
  echo ""
  echo "Micro-Prompt: Fix command invocation"
  echo ""
  echo "1. Hook script path is required"
  echo "   Fix: Provide path to hook script as first argument"
  echo ""
  echo "2. Test input JSON is required"
  echo "   Fix: Provide path to test input as second argument"
  echo ""
  echo "Invocation: bash $0 <hook-script> <test-input.json>"
  exit 1
fi

HOOK_SCRIPT="$1"
TEST_INPUT="$2"

# Validate inputs
if [ ! -f "$HOOK_SCRIPT" ]; then
  echo "❌ VALIDATION FAILED: Hook script not found"
  echo ""
  echo "Micro-Prompt: Fix the hook script path"
  echo ""
  echo "1. File does not exist: $HOOK_SCRIPT"
  echo "   Fix: Verify path is correct and file exists"
  echo ""
  echo "Invocation: bash $0 <hook-script> <test-input.json>"
  exit 1
fi

if [ ! -x "$HOOK_SCRIPT" ]; then
  echo "⚠️  Warning: Hook script is not executable. Attempting to run with bash..."
  HOOK_SCRIPT="bash $HOOK_SCRIPT"
fi

if [ ! -f "$TEST_INPUT" ]; then
  echo "❌ VALIDATION FAILED: Test input not found"
  echo ""
  echo "Micro-Prompt: Fix the test input path"
  echo ""
  echo "1. File does not exist: $TEST_INPUT"
  echo "   Fix: Verify path is correct and file exists"
  echo ""
  echo "Invocation: bash $0 <hook-script> <test-input.json>"
  exit 1
fi

# Validate test input JSON
if ! jq empty "$TEST_INPUT" 2>/dev/null; then
  echo "❌ VALIDATION FAILED: Invalid JSON"
  echo ""
  echo "Micro-Prompt: Fix JSON syntax in test input"
  echo ""
  echo "1. File is not valid JSON: $TEST_INPUT"
  echo "   Fix: Run 'jq . $TEST_INPUT' to see parsing errors"
  echo "   Fix: Use 'jq empty $TEST_INPUT' to validate"
  echo ""
  echo "Invocation: skill:hook-development"
  exit 1
fi

echo "🧪 Testing hook: $HOOK_SCRIPT"
echo "📥 Input: $TEST_INPUT"
echo ""

if [ "$VERBOSE" = true ]; then
  echo "Input JSON:"
  jq . "$TEST_INPUT"
  echo ""
fi

# Set up environment
export CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-/tmp/test-project}"
export CLAUDE_PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(pwd)}"
export CLAUDE_ENV_FILE="${CLAUDE_ENV_FILE:-/tmp/test-env-$$}"

if [ "$VERBOSE" = true ]; then
  echo "Environment:"
  echo "  CLAUDE_PROJECT_DIR=$CLAUDE_PROJECT_DIR"
  echo "  CLAUDE_PLUGIN_ROOT=$CLAUDE_PLUGIN_ROOT"
  echo "  CLAUDE_ENV_FILE=$CLAUDE_ENV_FILE"
  echo ""
fi

# Run the hook
echo "▶️  Running hook (timeout: ${TIMEOUT}s)..."
echo ""

start_time=$(date +%s)

set +e
output=$(timeout "$TIMEOUT" bash -c "cat '$TEST_INPUT' | $HOOK_SCRIPT" 2>&1)
exit_code=$?
set -e

end_time=$(date +%s)
duration=$((end_time - start_time))

# Analyze results
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results:"
echo ""
echo "Exit Code: $exit_code"
echo "Duration: ${duration}s"
echo ""

case $exit_code in
  0)
    echo "✅ Hook approved/succeeded"
    ;;
  2)
    echo "🚫 Hook blocked/denied"
    ;;
  124)
    echo "⏱️  Hook timed out after ${TIMEOUT}s"
    ;;
  *)
    echo "⚠️  Hook returned unexpected exit code: $exit_code"
    ;;
esac

echo ""
echo "Output:"
if [ -n "$output" ]; then
  echo "$output"
  echo ""

  # Try to parse as JSON
  if echo "$output" | jq empty 2>/dev/null; then
    echo "Parsed JSON output:"
    echo "$output" | jq .
  fi
else
  echo "(no output)"
fi

# Check for environment file
if [ -f "$CLAUDE_ENV_FILE" ]; then
  echo ""
  echo "Environment file created:"
  cat "$CLAUDE_ENV_FILE"
  rm -f "$CLAUDE_ENV_FILE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $exit_code -eq 0 ] || [ $exit_code -eq 2 ]; then
  echo "✅ Test completed successfully"
  exit 0
else
  echo "❌ TEST FAILED"
  echo ""
  echo "Micro-Prompt: Debug hook execution failure"
  echo ""
  echo "Exit code: $exit_code"
  echo "Duration: ${duration}s"
  echo ""
  echo "1. Check hook script for errors"
  echo "2. Verify timeout is sufficient (current: ${TIMEOUT}s)"
  echo "3. Review test input matches expected schema"
  echo ""
  echo "Invocation: skill:hook-development"
  exit 1
fi
