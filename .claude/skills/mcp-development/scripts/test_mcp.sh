#!/usr/bin/env bash
# test_mcp.sh - Test MCP servers using @modelcontextprotocol/inspector
#
# A simplified CLI for MCP server testing. Abstracts the complexity of
# npx @modelcontextprotocol/inspector with easy-to-use commands.
#
# Usage:
#   test_mcp.sh <server-path> <command> [options]
#
# Commands:
#   health        - Quick health check (tools/list)
#   tools         - List all available tools
#   resources     - List all resources
#   prompts       - List all prompts
#   call <name>   - Call a tool by name
#   all           - Run full test suite (health + tools + resources + prompts)
#
# Examples:
#   test_mcp.sh Custom_MCP/simpleWebFetch/dist/server.js health
#   test_mcp.sh /path/to/server.js tools
#   test_mcp.sh dist/server.js call fullWebFetch --arg url="https://example.com"
#
# Exit Codes:
#   0 - Command succeeded
#   1 - Command failed

set -euo pipefail

# Configuration
INSPECTOR="@modelcontextprotocol/inspector"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_ok() { echo -e "${GREEN}✓${NC} $*"; }
log_fail() { echo -e "${RED}✗${NC} $*"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $*"; }

# Print usage
usage() {
    cat << EOF
Usage: $(basename "$0") <server-path> <command> [options]

Test MCP servers using @modelcontextprotocol/inspector

Arguments:
  server-path      Path to MCP server entry point (JS/TS file)
                   Supports: relative paths, absolute paths
                   Examples: abs/path/server.js, /path/to/server.js, Custom_MCP/server/dist/server.js
  command          Operation to perform:
                   health     - Quick health check (tools/list)
                   tools      - List all available tools
                   resources  - List all resources
                   prompts    - List all prompts
                   call       - Call a tool (requires tool name)
                   all        - Run full test suite
  --help, -h       Show this help message

Options for 'call' command:
  --arg, -a        Tool argument in key=value format
                   Can be used multiple times for multiple arguments
                   Example: --arg url="https://example.com" --arg format="json"
  --json, -j       Pass arguments as JSON string
                   Example: --json '{"url": "https://example.com"}'

Examples:
  # Health check
  $(basename "$0") abs/path/server.js health

  # List all tools
  $(basename "$0") Custom_MCP/myServer/abs/path/server.js tools

  # Call a tool with single argument
  $(basename "$0") /abs/path/server.js call myTool --arg name="value"

  # Call a tool with multiple arguments
  $(basename "$0") server.js call search --arg query="test" --arg limit=10

  # Call a tool with JSON arguments
  $(basename "$0") abs/path/server.js call complexTool --json '{"url": "https://example.com", "depth": 2}'

  # Full test suite
  $(basename "$0") abs/path/server.js all

EOF
    exit 0
}

# Resolve server path to absolute
resolve_path() {
    local path="$1"

    # If already absolute, use as-is
    if [[ "$path" == /* ]]; then
        echo "$path"
        return
    fi

    # If path starts with Custom_MCP/, resolve relative to CLAUDE_PROJECT_DIR or pwd
    if [[ "$path" == Custom_MCP/* ]]; then
        local base="${CLAUDE_PROJECT_DIR:-$(pwd)}"
        echo "$base/$path"
        return
    fi

    # Otherwise, resolve relative to current directory
    echo "$(pwd)/$path"
}

# Build inspector command
build_inspector_cmd() {
    local server_path="$1"
    shift
    local method="$1"
    shift

    # Resolve path
    local resolved_path
    resolved_path=$(resolve_path "$server_path")

    # Build command based on method
    case "$method" in
        health|tools/list)
            echo "npx -y $INSPECTOR --cli node \"$resolved_path\" --method tools/list"
            ;;
        resources/list)
            echo "npx -y $INSPECTOR --cli node \"$resolved_path\" --method resources/list"
            ;;
        prompts/list)
            echo "npx -y $INSPECTOR --cli node \"$resolved_path\" --method prompts/list"
            ;;
        tools/call)
            echo "npx -y $INSPECTOR --cli node \"$resolved_path\" --method tools/call $*"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Run inspector command
run_inspector() {
    local cmd="$*"
    log_info "Running: $cmd"
    eval "$cmd"
}

# Health check command
cmd_health() {
    local server_path="$1"
    local cmd
    cmd=$(build_inspector_cmd "$server_path" "health")

    log_info "Health check for: $server_path"
    if run_inspector "$cmd"; then
        log_ok "Server is healthy"
        return 0
    else
        log_fail "Health check failed"
        return 1
    fi
}

# List tools command
cmd_tools() {
    local server_path="$1"
    local cmd
    cmd=$(build_inspector_cmd "$server_path" "tools/list")

    log_info "Listing tools for: $server_path"
    if run_inspector "$cmd"; then
        log_ok "Tools listed"
        return 0
    else
        log_fail "Failed to list tools"
        return 1
    fi
}

# List resources command
cmd_resources() {
    local server_path="$1"
    local cmd
    cmd=$(build_inspector_cmd "$server_path" "resources/list")

    log_info "Listing resources for: $server_path"
    if run_inspector "$cmd"; then
        log_ok "Resources listed"
        return 0
    else
        log_fail "Failed to list resources"
        return 1
    fi
}

# List prompts command
cmd_prompts() {
    local server_path="$1"
    local cmd
    cmd=$(build_inspector_cmd "$server_path" "prompts/list")

    log_info "Listing prompts for: $server_path"
    if run_inspector "$cmd"; then
        log_ok "Prompts listed"
        return 0
    else
        log_fail "Failed to list prompts"
        return 1
    fi
}

# Call tool command
cmd_call() {
    local server_path="$1"
    local tool_name="$2"
    shift 2

    local args=()
    local json_args=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --arg|-a)
                args+=("$2")
                shift 2
                ;;
            --json|-j)
                json_args="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    # Build the command
    local resolved_path
    resolved_path=$(resolve_path "$server_path")

    log_info "Calling tool '$tool_name' on: $server_path"

    local cmd="npx -y $INSPECTOR --cli node \"$resolved_path\" --method tools/call --tool-name \"$tool_name\""

    # Add individual arguments
    for arg in "${args[@]}"; do
        cmd="$cmd --tool-arg \"$arg\""
    done

    # Add JSON arguments if provided
    if [[ -n "$json_args" ]]; then
        cmd="$cmd --tool-arg '$json_args'"
    fi

    if run_inspector "$cmd"; then
        log_ok "Tool call succeeded"
        return 0
    else
        log_fail "Tool call failed"
        return 1
    fi
}

# Run all tests
cmd_all() {
    local server_path="$1"
    local failed=0

    echo "========================================"
    log_info "Running full test suite for: $server_path"
    echo "========================================"

    # Health check
    echo ""
    echo "--- Health Check ---"
    if ! cmd_health "$server_path"; then
        failed=1
    fi

    # Tools
    echo ""
    echo "--- Tools List ---"
    if ! cmd_tools "$server_path"; then
        failed=1
    fi

    # Resources
    echo ""
    echo "--- Resources List ---"
    if ! cmd_resources "$server_path"; then
        failed=1
    fi

    # Prompts
    echo ""
    echo "--- Prompts List ---"
    if ! cmd_prompts "$server_path"; then
        failed=1
    fi

    echo ""
    echo "========================================"
    if [[ $failed -eq 0 ]]; then
        log_ok "All tests passed"
        return 0
    else
        log_fail "Some tests failed"
        return 1
    fi
}

# Main entry point
main() {
    # Show help if requested or no arguments
    if [[ "$1" == "--help" || "$1" == "-h" || $# -lt 2 ]]; then
        usage
    fi

    local server_path="$1"
    local command="$2"
    shift 2

    # Validate server path exists
    local resolved_path
    resolved_path=$(resolve_path "$server_path")
    if [[ ! -f "$resolved_path" ]]; then
        log_fail "Server file not found: $resolved_path"
        echo " test_mcp.sh distTry:/server.js health"
        exit 1
    fi

    # Execute command
    case "$command" in
        health)
            cmd_health "$server_path"
            ;;
        tools)
            cmd_tools "$server_path"
            ;;
        resources)
            cmd_resources "$server_path"
            ;;
        prompts)
            cmd_prompts "$server_path"
            ;;
        call)
            if [[ -z "$1" ]]; then
                log_fail "Tool name required for 'call' command"
                echo "Usage: $(basename "$0") <server-path> call <tool-name> [--arg key=value]..."
                exit 1
            fi
            cmd_call "$server_path" "$@"
            ;;
        all)
            cmd_all "$server_path"
            ;;
        *)
            log_fail "Unknown command: $command"
            echo "Available commands: health, tools, resources, prompts, call, all"
            exit 1
            ;;
    esac
}

main "$@"
