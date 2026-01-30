#!/bin/bash
# testing-e2e/scripts/claude-invoke.sh
# Claude -p invocation wrapper with logging

set -euo pipefail

# Configuration
CLAUDE_BIN="${CLAUDE_BIN:-claude}"
OUTPUT_FORMAT="${OUTPUT_FORMAT:-stream-json}"
VERBOSE="${VERBOSE:-false}"
SKIP_PERMISSIONS="${SKIP_PERMISSIONS:-true}"
ALLOWED_TOOLS="${ALLOWED_TOOLS:-*}"

usage() {
    cat << EOF
Usage: $(basename "$0") <sandbox_dir> <prompt_file> <log_file> [options]

Invoke claude -p with proper sandbox CWD and logging.

ARGUMENTS:
    sandbox_dir     Path to .sandbox directory
    prompt_file     Path to prompt file (will use @ syntax)
    log_file        Path to output log file

OPTIONS:
    -f, --format    Output format (stream-json, json, text) [default: stream-json]
    -v, --verbose   Enable verbose output
    -s, --skip      Skip permission prompts [default: true]
    -a, --tools     Allowed tools comma-separated [default: *]
    -h, --help      Show this help

EXAMPLES:
    $(basename "$0" .sandbox prompts/test.md logs/test.log
    $(basename "$0" .sandbox prompt.md output.log -v -f json

EOF
}

# Parse arguments
SANDBOX_DIR=""
PROMPT_FILE=""
LOG_FILE=""

while getopts "f:vsa:h-:" opt; do
    case $opt in
        f)
            OUTPUT_FORMAT="$OPTARG"
            ;;
        v)
            VERBOSE=true
            ;;
        s)
            SKIP_PERMISSIONS=true
            ;;
        a)
            ALLOWED_TOOLS="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        -)
            case "${OPTARG}" in
                format)
                    OUTPUT_FORMAT="${!OPTIND}"
                    ((OPTIND++))
                    ;;
                verbose)
                    VERBOSE=true
                    ;;
                skip)
                    SKIP_PERMISSIONS=true
                    ;;
                tools)
                    ALLOWED_TOOLS="${!OPTIND}"
                    ((OPTIND++))
                    ;;
            esac
            ;;
        \?)
            usage
            exit 1
            ;;
    esac
done

# Shift past parsed arguments
shift $((OPTIND - 1))

# Get required arguments
if [ $# -lt 3 ]; then
    echo "Error: Missing required arguments" >&2
    usage
    exit 1
fi

SANDBOX_DIR="$1"
PROMPT_FILE="$2"
LOG_FILE="$3"

# Validate arguments
if [ ! -d "$SANDBOX_DIR" ]; then
    echo "Error: Sandbox directory not found: $SANDBOX_DIR" >&2
    exit 1
fi

if [ ! -f "$PROMPT_FILE" ]; then
    echo "Error: Prompt file not found: $PROMPT_FILE" >&2
    exit 1
fi

# Verify CWD will be correct
if [ ! -d "$SANDBOX_DIR/.claude" ]; then
    echo "Error: Sandbox missing .claude/ directory" >&2
    exit 1
fi

# Build command
CMD="$CLAUDE_BIN -p @$PROMPT_FILE --output-format $OUTPUT_FORMAT"

if [ "$VERBOSE" = true ]; then
    CMD="$CMD --verbose"
fi

if [ "$SKIP_PERMISSIONS" = true ]; then
    CMD="$CMD --dangerously-skip-permissions"
fi

if [ "$ALLOWED_TOOLS" != "*" ]; then
    CMD="$CMD --allowedTools $ALLOWED_TOOLS"
fi

# Execute with CWD in sandbox
echo "Executing: $CMD" >&2
echo "CWD: $SANDBOX_DIR/.claude" >&2
echo "Log: $LOG_FILE" >&2
echo "---" >&2

cd "$SANDBOX_DIR/.claude"

# Execute and capture
set +e
$CMD 2>&1 | tee "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}
set -e

echo "" >&2
echo "Exit code: $EXIT_CODE" >&2

exit $EXIT_CODE
