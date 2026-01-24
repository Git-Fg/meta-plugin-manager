#!/usr/bin/env bash
# scaffold_script.sh - Generate hook script template
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - File system error

set -euo pipefail

# Configuration
SCRIPTS_DIR="${CLAUDE_PROJECT_DIR}/.claude/scripts"

usage() {
    cat << 'EOF'
Usage: scaffold_script.sh [OPTIONS]

Generates a hook script template with proper structure.

OPTIONS:
  --name NAME              Script name (required, without .sh extension)
  --event EVENT            Event type: PreToolUse|PostToolUse|Stop (required)
  --matcher MATCHER        Tool pattern or name (required)
  --purpose PURPOSE        Brief description of script purpose

EXAMPLES:
  scaffold_script.sh --name validate-write \
    --event PreToolUse --matcher Write \
    --purpose "Validate Write tool operations"

EOF
    exit 1
}

scaffold_script() {
    local name="$1"
    local event="$2"
    local matcher="$3"
    local purpose="${4:-Hook validation script}"

    local script_file="${SCRIPTS_DIR}/${name}.sh"

    # Check if script already exists
    if [[ -f "$script_file" ]]; then
        echo "ERROR: Script already exists: $script_file"
        echo "Use a different name or remove the existing file."
        exit 2
    fi

    # Generate script
    cat > "$script_file" << SCRIPT_EOF
#!/usr/bin/env bash
# ${name}.sh - ${purpose}
#
# Hook: ${event} for ${matcher}
#
# Exit Codes:
#   0 - Success, operation allowed
#   1 - Warning, operation allowed
#   2 - Blocking error, operation denied

set -euo pipefail

# Get tool input from environment
# TOOL_NAME: Name of the tool being executed
# TOOL_INPUT: JSON input to the tool

main() {
    local tool_name="\${TOOL_NAME:-}"
    local tool_input="\${TOOL_INPUT:-}"

    # Add your validation logic here

    # Example: Check for dangerous operations
    # case "\$tool_name" in
    #     Write|Edit)
    #         # Check file path
    #         local file_path=\$(echo "\$tool_input" | jq -r '.path // empty')
    #         if [[ "\$file_path" == *".env"* ]]; then
    #             echo "ERROR: Attempting to modify .env file"
    #             exit 2  # Block the operation
    #         fi
    #         ;;
    # esac

    # Default: allow operation
    return 0
}

main "\$@"
SCRIPT_EOF

    chmod +x "$script_file"

    echo "✅ Hook script created: $script_file"
    echo "   Next: Edit the script to add your validation logic"
}

# Parse arguments
NAME=""
EVENT=""
MATCHER=""
PURPOSE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            NAME="$2"
            shift 2
            ;;
        --event)
            EVENT="$2"
            shift 2
            ;;
        --matcher)
            MATCHER="$2"
            shift 2
            ;;
        --purpose)
            PURPOSE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [[ -z "$NAME" || -z "$EVENT" || -z "$MATCHER" ]]; then
    echo "ERROR: --name, --event, and --matcher are required."
    usage
fi

# Set CLAUDE_PROJECT_DIR if not set
if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
    export CLAUDE_PROJECT_DIR="$(pwd)"
fi

# Create scripts directory
mkdir -p "$SCRIPTS_DIR"

# Generate script
scaffold_script "$NAME" "$EVENT" "$MATCHER" "$PURPOSE"

exit 0
