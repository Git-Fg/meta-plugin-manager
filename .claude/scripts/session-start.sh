#!/bin/bash
# Session Start Hook
# Initializes session logging and context persistence

SESSION_DIR="${HOME}/.claude/sessions"
SESSION_ID=$(date +%Y%m%d-%H%M%S)-$$
SESSION_FILE="${SESSION_DIR}/${SESSION_ID}/start.jsonl"
LOG_FILE="${SESSION_DIR}/${SESSION_ID}/session.log"

mkdir -p "$(dirname "$SESSION_FILE")" "$(dirname "$LOG_FILE")"

# Record session start
cat > "$SESSION_FILE" << EOF
{"timestamp":"$(date -u +"%Y-%m-%dT%H:%M:%SZ")","event":"session_start","session_id":"$SESSION_ID","cwd":"$(pwd)","git_branch":"$(git branch --show-current 2>/dev/null || echo 'no-git')"}
EOF

# Set environment variables for session tracking
export CLAUDE_SESSION_ID="$SESSION_ID"
export CLAUDE_SESSION_DIR="${SESSION_DIR}/${SESSION_ID}"

# Log to session file
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Session started: $SESSION_ID" >> "$LOG_FILE"

exit 0
