#!/usr/bin/env bash
# add_server.sh - Add MCP server to .mcp.json
#
# Dependencies: python3 (for JSON handling)
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - File system error
#   3 - JSON error

set -euo pipefail

# Configuration
MCP_FILE="${CLAUDE_PROJECT_DIR}/.mcp.json"

usage() {
    cat << 'EOF'
Usage: add_server.sh [OPTIONS]

Adds an MCP server to .mcp.json with safe merge.

OPTIONS:
  --name NAME              Server name (required, kebab-case)
  --transport TYPE         Transport type: stdio|http (required)
  --command CMD            Command to execute (for stdio)
  --args ARRAY             Command arguments (JSON array string)
  --url URL                Server URL (for http)
  --header HEADER          HTTP header (for http, can be repeated)

EXAMPLES:
  # stdio transport
  add_server.sh --name my-server --transport stdio --command node --args '["abs/path/server.js"]'

  # http transport with OAuth
  add_server.sh --name github --transport http --url 'https://api.githubcopilot.com/mcp/'

  # http transport with Bearer token
  add_server.sh --name api --transport http --url 'https://api.example.com/mcp' \
    --header 'Authorization: Bearer ${API_TOKEN}'

EOF
    exit 1
}

# Check python3 availability
if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 is required for JSON handling"
    exit 3
fi

add_server_stdio() {
    local name="$1"
    local command="$2"
    local args="$3"

    # Create .mcp.json if doesn't exist
    if [[ ! -f "$MCP_FILE" ]]; then
        cat > "$MCP_FILE" << 'EOF'
{
  "mcpServers": {}
}
EOF
    fi

    # Use python for safe merge
    python3 - "$name" "$command" "$args" "$MCP_FILE" << 'PYTHON_EOF'
import json
import sys

name = sys.argv[1]
command = sys.argv[2]
args_str = sys.argv[3]
mcp_file = sys.argv[4]

try:
    with open(mcp_file, 'r') as f:
        config = json.load(f)
except json.JSONDecodeError as e:
    print(f"ERROR: Invalid JSON in {mcp_file}: {e}")
    sys.exit(1)

# Parse args as JSON array
try:
    args = json.loads(args_str)
except json.JSONDecodeError:
    # If not JSON array, treat as single value in array
    args = [args_str]

# Add server (stdio format: direct command/args)
config['mcpServers'][name] = {
    'command': command,
    'args': args
}

# Write back
with open(mcp_file, 'w') as f:
    json.dump(config, f, indent=2)

print(f"✅ MCP server added: {name}")
PYTHON_EOF
}

add_server_http() {
    local name="$1"
    local url="$2"
    shift 2
    local headers=()

    # Parse remaining arguments as headers
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --header)
                headers+=("$2")
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    # Create .mcp.json if doesn't exist
    if [[ ! -f "$MCP_FILE" ]]; then
        cat > "$MCP_FILE" << 'EOF'
{
  "mcpServers": {}
}
EOF
    fi

    # Convert headers array to JSON array string
    headers_json=$(printf '%s\n' "${headers[@]}" | jq -R . | jq -s .)

    # Use python for safe merge
    python3 - "$name" "$url" "$headers_json" "$MCP_FILE" << 'PYTHON_EOF'
import json
import sys

name = sys.argv[1]
url = sys.argv[2]
headers_json = sys.argv[3]
mcp_file = sys.argv[4]

try:
    with open(mcp_file, 'r') as f:
        config = json.load(f)
except json.JSONDecodeError as e:
    print(f"ERROR: Invalid JSON in {mcp_file}: {e}")
    sys.exit(1)

# Parse headers
headers = json.loads(headers_json) if headers_json != "[]" else {}

# Build headers object from array
headers_obj = {}
for header in headers:
    # Parse "Key: Value" format
    if ': ' in header:
        key, value = header.split(': ', 1)
        headers_obj[key] = value

# Add server (http format: type + url + optional headers)
server_config = {
    'type': 'http',
    'url': url
}

if headers_obj:
    server_config['headers'] = headers_obj

config['mcpServers'][name] = server_config

# Write back
with open(mcp_file, 'w') as f:
    json.dump(config, f, indent=2)

print(f"✅ MCP server added: {name}")
PYTHON_EOF
}

# Parse arguments
NAME=""
TRANSPORT=""
COMMAND=""
ARGS=""
URL=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            NAME="$2"
            shift 2
            ;;
        --transport)
            TRANSPORT="$2"
            shift 2
            ;;
        --command)
            COMMAND="$2"
            shift 2
            ;;
        --args)
            ARGS="$2"
            shift 2
            ;;
        --url)
            URL="$2"
            shift 2
            ;;
        --header)
            # Pass through to add_server_http
            shift
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
if [[ -z "$NAME" || -z "$TRANSPORT" ]]; then
    echo "ERROR: --name and --transport are required."
    usage
fi

# Set CLAUDE_PROJECT_DIR if not set
if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
    export CLAUDE_PROJECT_DIR="$(pwd)"
fi

# Route to appropriate function
case "$TRANSPORT" in
    stdio)
        if [[ -z "$COMMAND" ]]; then
            echo "ERROR: --command is required for stdio transport"
            exit 1
        fi
        add_server_stdio "$NAME" "$COMMAND" "${ARGS:-[]}"
        ;;
    http)
        if [[ -z "$URL" ]]; then
            echo "ERROR: --url is required for http transport"
            exit 1
        fi
        # Pass through remaining args for headers
        add_server_http "$NAME" "$URL" "$@"
        ;;
    *)
        echo "ERROR: Invalid transport type: $TRANSPORT"
        echo "Valid types: stdio, http"
        exit 1
        ;;
esac

exit 0
