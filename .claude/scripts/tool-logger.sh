#!/usr/bin/env bash
# tool-logger.sh - Passive Tool Tracking System
# Captures comprehensive tool usage data via PreToolUse/PostToolUse hooks
# Usage: tool-logger.sh {pre|post}

set -euo pipefail

# Configuration
LOG_DIR="${LOG_DIR:-.claude/logs}"
FULL_LOG="${LOG_DIR}/full_log.log"
SESSION_LOG="${LOG_DIR}/last_run.log"
SESSION_FILE="${LOG_DIR}/.session_id"
TEMP_DIR="${LOG_DIR}/.tmp"

# Ensure log directory exists
mkdir -p "${LOG_DIR}"
mkdir -p "${TEMP_DIR}"

# Generate/get session ID
get_session_id() {
    if [[ -f "${SESSION_FILE}" ]]; then
        cat "${SESSION_FILE}"
    else
        # Generate new UUID for session
        local sid
        if command -v uuidgen >/dev/null 2>&1; then
            sid=$(uuidgen)
        elif command -v python3 >/dev/null 2>&1; then
            sid=$(python3 -c 'import uuid; print(uuid.uuid4())')
        else
            # Fallback: timestamp-based ID
            sid="session-$(date +%s)-$$"
        fi
        echo "${sid}" > "${SESSION_FILE}"
        echo "${sid}"
    fi
}

# Escape JSON string
json_escape() {
    local str="$1"
    # Remove newlines and escape special characters
    echo "${str}" | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/g' | tr -d '\n' | sed 's/\\n$//'
}

# Capture tool metadata
capture_tool_data() {
    local hook_type="$1"  # pre or post

    # Extract tool information from environment
    local tool_name="${TOOL_NAME:-unknown}"
    local tool_input="${TOOL_INPUT:-}"
    local tool_id="${TOOL_ID:-}"
    local duration="${DURATION:-0}"

    # Get session info
    local session_id
    session_id=$(get_session_id)

    # Get context
    local cwd="${PWD}"
    local user="${USER:-unknown}"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")

    # Parse tool arguments if JSON
    local arguments_json="null"
    if [[ -n "${tool_input}" ]]; then
        # Validate and pretty-print JSON if possible
        if echo "${tool_input}" | jq . >/dev/null 2>&1; then
            arguments_json=$(echo "${tool_input}" | jq -c .)
        else
            # Not JSON, treat as string
            arguments_json="{\"raw_input\": \"$(json_escape "${tool_input}")\"}"
        fi
    fi

    # Create JSON structure
    local json
    json=$(cat <<EOF
{
  "session_id": "${session_id}",
  "timestamp": "${timestamp}",
  "hook_type": "${hook_type}",
  "tool_name": "${tool_name}",
  "tool_id": "${tool_id}",
  "arguments": ${arguments_json},
  "duration_ms": ${duration},
  "result": null,
  "success": null,
  "context": {
    "cwd": "${cwd}",
    "user": "${user}"
  }
}
EOF
)

    # Write to temp file for post-processing
    local temp_file="${TEMP_DIR}/${tool_id:-no_id}.${hook_type}.json"
    echo "${json}" > "${temp_file}"

    # For pre hooks, just store the data
    # For post hooks, merge and write to logs
    if [[ "${hook_type}" == "post" ]]; then
        merge_and_write_logs "${tool_id}" "${temp_file}"
    fi
}

# Merge pre and post data, write to logs
merge_and_write_logs() {
    local tool_id="$1"
    local post_file="$2"

    # Find corresponding pre file
    local pre_file="${TEMP_DIR}/${tool_id}.pre.json"

    if [[ ! -f "${pre_file}" ]]; then
        # No pre data, just write post
        write_to_logs "${post_file}"
        return
    fi

    # Merge pre and post data
    local merged
    merged=$(jq -s '.[0] * .[1]' "${pre_file}" "${post_file}")

    # Write merged data
    write_to_logs_from_string "${merged}"

    # Clean up temp files
    rm -f "${pre_file}" "${post_file}"
}

# Write JSON object to log files
write_to_logs() {
    local json_file="$1"

    # Atomic write: write to temp then move
    local full_temp="${FULL_LOG}.tmp"
    local session_temp="${SESSION_LOG}.tmp"

    cat "${json_file}" >> "${full_temp}"
    mv "${full_temp}" "${FULL_LOG}"

    cat "${json_file}" >> "${session_temp}"
    mv "${session_temp}" "${SESSION_LOG}"
}

# Write JSON string to log files
write_to_logs_from_string() {
    local json_string="$1"

    # Atomic write to both logs
    local full_temp="${FULL_LOG}.tmp"
    local session_temp="${SESSION_LOG}.tmp"

    echo "${json_string}" >> "${full_temp}"
    mv "${full_temp}" "${FULL_LOG}"

    echo "${json_string}" >> "${session_temp}"
    mv "${session_temp}" "${SESSION_LOG}"
}

# Cleanup old temp files
cleanup_temp() {
    # Remove temp files older than 1 hour
    find "${TEMP_DIR}" -name "*.json" -type f -mmin +60 -delete 2>/dev/null || true
}

# Main execution
main() {
    local hook_type="${1:-}"

    if [[ -z "${hook_type}" ]]; then
        echo "Usage: $0 {pre|post}" >&2
        exit 1
    fi

    # Validate hook type
    if [[ "${hook_type}" != "pre" && "${hook_type}" != "post" ]]; then
        echo "Error: Invalid hook type: ${hook_type}" >&2
        exit 1
    fi

    # Cleanup on exit
    trap cleanup_temp EXIT

    # Capture and log
    capture_tool_data "${hook_type}"
}

# Run main
main "$@"
