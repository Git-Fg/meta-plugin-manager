#!/bin/bash
# Session Start Hook - Native Tool Discipline Injection
# Inspired by superpowers: Session-level discipline enforcement

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

# Escape function for JSON (pure bash, no sed)
json_escape() {
    local string="$1"
    string="${string//\\/\\\\}"
    string="${string//\"/\\\"}"
    string="${string//$'\n'/\\n}"
    string="${string//$'\r'/\\r}"
    string="${string//$'\t'/\\t}"
    printf '%s' "$string"
}

# Native tool discipline content
DISCIPLINE_CONTENT="<SESSION_DISCIPLINE>
CRITICAL: SKILLS FIRST, NATIVE TOOLS SECOND

You MUST use available skills and native tools appropriately. No rationalization.

## SKILL DISCIPLINE (PRIMARY)

### 1% Rule

If there's even a 1% chance a skill applies, invoke it. IF A SKILL APPLIES, YOU MUST USE IT.

### Check Before ANY Action

Before starting tasks, asking questions, exploring, gathering info, writing code, debugging, or planning—ASK: \"Does a skill exist for this?\" If 1% yes → INVOKE IT.

### Priority: Process Before Implementation

1. Process skills (HOW to approach)
2. Implementation skills (guide execution)

### Red Flags (STOP—you're rationalizing)

| Thought (Stop)                     | Reality                                    |
| ---------------------------------- | ------------------------------------------ |
| \"This is simple\"                  | Check for skills first                     |
| \"I need context first\"            | Skill check BEFORE questions               |
| \"I'll explore first\"              | Skills tell you HOW to explore             |
| \"This doesn't need a skill\"       | If skill exists, use it                    |
| \"I remember this skill\"           | Skills evolve. Invoke current version      |
| \"I'll just do this one thing\"     | Check BEFORE doing anything                |
| \"I know what to do\"               | Use skill to ensure best practices         |

### How to Use Skills

Use the Skill tool. When invoked, follow its content directly. Never Read skill files manually.

## NATIVE TOOL DISCIPLINE (SECONDARY)

### Mandates

AFTER checking skills, use native tools:

- Grep: instead of grep/rg/ack
- Read: instead of head/tail/cat/less
- Glob: instead of find/fd
- Edit: instead of sed -i
- Write: instead of echo > file
- LSP: for TypeScript navigation
- TaskList: for task tracking

### Forbidden Patterns

grep/rg/ack → Grep | head/tail/cat → Read | find/fd → Glob | sed -i → Edit | echo > → Write | Manual tracking → TaskList

### TaskList Rules

**Use TaskCreate for:** 3+ step tasks, non-trivial work, user requests
**Skip for:** Single straightforward edits, <3 trivial steps, conversational exchanges

**Workflow:** Create → in_progress (when starting) → completed (ONLY when fully done, tests pass, no errors)

**NEVER mark completed if:** Tests failing, partial implementation, errors, unsure

### Exceptions

Bash only for: actual system commands (npm, git, python), no native equivalent, chained operations

## DOCUMENTATION DISCIPLINE

ALWAYS suggest updates to .claude/rules/, CLAUDE.md, or agents.md when content needs to reflect changes.

## SUMMARY

1. Skills first (1% rule: invoke if might apply)
2. Native tools second (replace bash when possible)
3. No rationalization
4. Documentation updates (suggest when rules/docs need refresh)

Session-level enforcement. Self-police accordingly.
</SESSION_DISCIPLINE>"

# Output JSON with context injection
ESCAPED_CONTENT=$(json_escape "$DISCIPLINE_CONTENT")
cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$ESCAPED_CONTENT"
  }
}
EOF

exit 0
