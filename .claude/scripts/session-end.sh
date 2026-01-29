#!/bin/bash
# Session End Hook - Transcript Condensation
# Strips infrastructure fields, truncates thinking blocks, condenses large tool outputs

# --- Read hook input from stdin ---
input=$(cat)
transcript_path=$(echo "$input" | jq -r '.transcript_path')
session_id=$(echo "$input" | jq -r '.session_id')

# --- Validation ---
if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  echo "[SessionEnd] No transcript found at: $transcript_path" >&2
  exit 0
fi

# --- Determine session directory ---
LOCAL_SESSIONS_DIR="${CLAUDE_PROJECT_DIR}/.claude/workspace/sessions"
if [ -f "${LOCAL_SESSIONS_DIR}/.current_session" ]; then
  session_dir=$(cat "${LOCAL_SESSIONS_DIR}/.current_session")
else
  session_dir="${LOCAL_SESSIONS_DIR}/${session_id}"
  mkdir -p "$session_dir"
fi

# --- Condensation jq filter ---
condense() {
  jq -c '
    # 1. Strip infrastructure metadata (17 fields)
    del(.isSidechain, .userType, .messageId, .parentToolUseID, .toolUseID,
        .message?.usage, .message?.thinkingMetadata, .usage, .thinkingMetadata,
        .isSnapshotUpdate, .permissionMode, .service_tier, .stop_reason,
        .stop_sequence, .signature, .uuid, .parentUuid, .sessionId,
        .timestamp, .cwd, .version, .gitBranch) |

    # 2. Truncate thinking blocks to metadata only
    if .message?.content | type == "array" then
      .message.content = (.message.content | map(
        if .type == "thinking" then {type: "thinking", size: (.thinking | length)}
        else . end
      ))
    else . end
  '
}

# --- Apply condensation ---
transcript_dest="${session_dir}/raw-transcript.jsonl"
condense < "$transcript_path" > "$transcript_dest"

# --- Copy to fixed latest file ---
latest_transcript="${LOCAL_SESSIONS_DIR}/previous-session.jsonl"
condense < "$transcript_path" > "$latest_transcript"

# --- Record metadata ---
cat > "${session_dir}/end.jsonl" <<EOF
{"timestamp":"$(date -u +"%Y-%m-%dT%H:%M:%SZ")","event":"session_end","session_id":"${session_id}","transcript_size_bytes":$(wc -c < "$transcript_dest" 2>/dev/null || echo 0)}
EOF

# --- Cleanup ---
rm -f "${LOCAL_SESSIONS_DIR}/.current_session"

echo "[SessionEnd] Transcript condensed to: $transcript_dest"
exit 0
