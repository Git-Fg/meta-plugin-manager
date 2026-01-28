#!/bin/bash
# Session End Hook
# Finalizes session summary and extracts learnings

SESSION_ID="${CLAUDE_SESSION_ID:-$(date +%Y%m%d-%H%M%S)-$$}"
SESSION_DIR="${HOME}/.claude/sessions/${SESSION_ID}"
SESSION_FILE="${SESSION_DIR}/end.jsonl"
LOG_FILE="${SESSION_DIR}/session.log"
SUMMARY_FILE="${SESSION_DIR}/summary.md"
TRANSCRIPT_PATH="${1:-${CLAUDE_TRANSCRIPT_PATH:-}}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Record session end
cat > "$SESSION_FILE" << EOF
{"timestamp":"$(date -u +"%Y-%m-%dT%H:%M:%SZ")","event":"session_end","session_id":"$SESSION_ID","cwd":"$(pwd)","transcript_path":"$TRANSCRIPT_PATH"}
EOF

# Generate session summary
cat > "$SUMMARY_FILE" << EOF
# Session Summary

**Session ID**: $SESSION_ID
**Start**: $(head -1 "$LOG_FILE" 2>/dev/null | sed 's/^\[//' | sed 's/\].*$//' || date -u +"%Y-%m-%dT%H:%M:%SZ")
**End**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Working Directory**: $(pwd)
**Git Branch**: $(git branch --show-current 2>/dev/null || echo 'N/A')

## Session Notes

This session was automatically logged by the memory-persistence system.
EOF

# Log to session file
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Session ended: $SESSION_ID" >> "$LOG_FILE"

# Create transcript symlink for reflect-and-patch skill
if [ -n "$PROJECT_DIR" ]; then
  TRANSCRIPTS_DIR="${PROJECT_DIR}/.claude/transcripts"
  mkdir -p "$TRANSCRIPTS_DIR"

  if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    ln -sf "$TRANSCRIPT_PATH" "${TRANSCRIPTS_DIR}/last-session.jsonl"
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Transcript symlinked: ${TRANSCRIPTS_DIR}/last-session.jsonl -> $TRANSCRIPT_PATH" >> "$LOG_FILE"
  else
    # Create metadata file even if transcript path unavailable
    cat > "${TRANSCRIPTS_DIR}/last-session.jsonl" << EOF
{"timestamp":"$(date -u +"%Y-%m-%dT%H:%M:%SZ")","event":"session_end","session_id":"$SESSION_ID","transcript_path":"$TRANSCRIPT_PATH"}
EOF
  fi
fi

# Check for reflection triggers
REFLECTION_TRIGGERED=false

# Check if user issued corrections (heuristic: look for correction patterns in history)
if [ -f "$LOG_FILE" ]; then
  # Patterns indicating user corrections
  if grep -qE "(not|don't|wrong|no, |actually, |wait, |that's incorrect)" "$LOG_FILE" 2>/dev/null; then
    REFLECTION_TRIGGERED=true
  fi
fi

# Log reflection trigger if detected
if [ "$REFLECTION_TRIGGERED" = true ]; then
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Reflection suggested: user corrections detected" >> "$LOG_FILE"
  echo "" >> "$SUMMARY_FILE"
  echo "**Note**: User corrections detected. Consider running /reflect to identify patterns." >> "$SUMMARY_FILE"
fi

exit 0
