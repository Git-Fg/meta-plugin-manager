#!/usr/bin/env bash
# validate_mcp.sh - Validate MCP configuration
#
# Dependencies: python3 (for JSON handling)
#
# Exit Codes:
#   0 - Validation passed
#   1 - Validation failed

set -euo pipefail

# Configuration
MCP_FILE="${CLAUDE_PROJECT_DIR}/.mcp.json"

usage() {
    cat << 'EOF'
Usage: validate_mcp.sh

Validates .mcp.json configuration.

EXAMPLES:
  validate_mcp.sh
EOF
    exit 1
}

# Check python3 availability
if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 is required"
    exit 1
fi

validate_mcp() {
    # Set CLAUDE_PROJECT_DIR if not set
    if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
        export CLAUDE_PROJECT_DIR="$(pwd)"
    fi

    if [[ ! -f "$MCP_FILE" ]]; then
        echo "❌ FAIL: .mcp.json does not exist: $MCP_FILE"
        return 1
    fi

    python3 - "$MCP_FILE" << 'PYTHON_EOF'
import json
import sys

mcp_file = sys.argv[1]

try:
    with open(mcp_file, 'r') as f:
        config = json.load(f)
except json.JSONDecodeError as e:
    print(f"❌ FAIL: Invalid JSON: {e}")
    sys.exit(1)
except FileNotFoundError:
    print(f"❌ FAIL: File not found: {mcp_file}")
    sys.exit(1)

# Validate structure
if 'mcpServers' not in config:
    print("❌ FAIL: Missing 'mcpServers' key")
    sys.exit(1)

servers = config['mcpServers']
if not isinstance(servers, dict):
    print("❌ FAIL: 'mcpServers' must be an object")
    sys.exit(1)

# Score calculation
score = 100
issues = []
warnings = []

server_count = len(servers)
print(f"📊 Found {server_count} MCP server(s)")

# Validate each server
for name, server in servers.items():
    print(f"\nValidating: {name}")

    # Check transport type
    server_type = server.get('type', '')

    if server_type == '' or server_type is None:
        # stdio server (no type field)
        if 'command' not in server:
            issues.append(f"{name}: Missing 'command' for stdio server")
            score -= 5
        if 'args' not in server:
            warnings.append(f"{name}: Missing 'args' for stdio server")
            score -= 2
    elif server_type == 'http':
        # HTTP server
        if 'url' not in server:
            issues.append(f"{name}: Missing 'url' for http server")
            score -= 5
        # Check for HTTPS
        url = server.get('url', '')
        if url and not url.startswith('https://'):
            warnings.append(f"{name}: URL should use HTTPS")
            score -= 2
    elif server_type == 'sse':
        # SSE is deprecated
        warnings.append(f"{name}: SSE transport is deprecated, use http instead")
        score -= 2
    else:
        issues.append(f"{name}: Unknown transport type '{server_type}'")
        score -= 10

# Report results
print(f"\n{'='*50}")
print(f"Quality Score: {score}/100")

if score >= 90:
    grade = "A"
    status = "✅ Exemplary"
elif score >= 75:
    grade = "B"
    status = "✅ Good"
elif score >= 60:
    grade = "C"
    status = "⚠️  Adequate"
elif score >= 40:
    grade = "D"
    status = "❌ Poor"
else:
    grade = "F"
    status = "❌ Failing"

print(f"Grade: {grade} ({status})")

if issues:
    print(f"\nCritical Issues ({len(issues)}):")
    for issue in issues:
        print(f"  ❌ {issue}")

if warnings:
    print(f"\nWarnings ({len(warnings)}):")
    for warning in warnings:
        print(f"  ⚠️  {warning}")

if score >= 75:
    print(f"\n✅ PASS: Configuration is valid")
    sys.exit(0)
else:
    print(f"\n❌ FAIL: Configuration needs improvement")
    sys.exit(1)
PYTHON_EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            usage
            ;;
    esac
done

validate_mcp
