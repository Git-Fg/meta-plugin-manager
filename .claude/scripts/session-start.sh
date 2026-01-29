#!/bin/bash
# Session Start Hook - Discipline Enforcement Injection + Session Lifecycle
# Emits discipline context and manages session directory lifecycle

# --- Configuration ---
ARCHIVE_DIR="${HOME}/.claude/sessions"
LOCAL_SESSIONS_DIR="${CLAUDE_PROJECT_DIR}/.claude/workspace/sessions"

# --- Read hook input from stdin ---
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# --- Session directory ---
session_dir="${LOCAL_SESSIONS_DIR}/${session_id}"

# --- Archive previous local session if exists ---
if [ -d "$LOCAL_SESSIONS_DIR" ] && [ -n "$(ls -A "$LOCAL_SESSIONS_DIR" 2>/dev/null)" ]; then
    for prev_dir in "$LOCAL_SESSIONS_DIR"/*/; do
        [ -d "$prev_dir" ] || continue
        prev_session_id=$(basename "$prev_dir")
        if [ "$prev_session_id" != "$session_id" ]; then
            mkdir -p "${ARCHIVE_DIR}/${prev_session_id}"
            cp -r "$prev_dir"* "${ARCHIVE_DIR}/${prev_session_id}/" 2>/dev/null || true
            rm -rf "$prev_dir"
            echo "[SessionStart] Archived previous session: ${prev_session_id}"
        fi
    done
fi

# --- Session Persistence ---
mkdir -p "$session_dir"

# Record session metadata
cat > "${session_dir}/start.jsonl" <<EOF
{"timestamp":"$(date -u +"%Y-%m-%dT%H:%M:%SZ")","event":"session_start","session_id":"${session_id}","cwd":"$(pwd)","git_branch":"$(git branch --show-current 2>/dev/null || echo 'no-git')","transcript_path":"${transcript_path}"}
EOF

# Save session dir for SessionEnd to read
echo "$session_dir" > "${LOCAL_SESSIONS_DIR}/.current_session"

# --- Discipline Marker Injection ---
discipline_marker="<SESSION_DISCIPLINE>
SKILL SENSITIVITY: 10x ELEVATED. Threshold lowered 10x. Before EVERY action:

1. Rate confidence (0-100) in completing without a skill
2. If confidence <90%, ASK YOURSELF: \"Does a skill exist for this?\"
3. If 1% chance applies, invoke it

CONTEXT FIRST. Before any task, question, code, or planning, gather relevant context. What is the current state? What changed recently? What exists in the project? SKIP THIS AND YOU ARE LAZY. You cannot act on stale context.

CHECK SKILL. Before every action, ASK YOURSELF: \"Does a skill exist for this?\" If there is even the remotest chance a skill applies, invoke it. No exceptions. No rationalization. No \"I'll just do it myself.\" Skills prevent mistakes and encode wisdom. Using them is mandatory—not optional.

EXECUTE. After context and skill check, act. Loop continues with every new action. Skip any step and you fail. This is not guidance. This is enforcement.
</SESSION_DISCIPLINE>"

# Escape for JSON transport
escape_for_json() {
    local input="$1"
    input="${input//\\/\\\\}"
    input="${input//\"/\\\"}"
    input="${input//$'\n'/\\n}"
    input="${input//$'\r'/\\r}"
    input="${input//$'\t'/\\t}"
    printf '%s' "$input"
}

injected_discipline=$(escape_for_json "$discipline_marker")

# --- Output ---
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "injectedContext": "${injected_discipline}"
  }
}
EOF

exit 0
