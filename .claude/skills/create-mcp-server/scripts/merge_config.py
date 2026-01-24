#!/usr/bin/env python3
"""
merge_config.py - Safe JSON merge for .mcp.json

Usage:
    python3 merge_config.py <name> <transport_type> [options]

Options:
    --command CMD     Command for stdio transport
    --args ARRAY      Command arguments (JSON array)
    --url URL         URL for streamable-http transport
    --file PATH       Path to .mcp.json (default: $CLAUDE_PROJECT_DIR/.mcp.json)

Exit Codes:
    0 - Success
    1 - Input validation error
    2 - File system error
    3 - JSON error
"""

import argparse
import json
import os
import sys


def parse_args():
    parser = argparse.ArgumentParser(
        description="Safely merge MCP server configuration into .mcp.json"
    )
    parser.add_argument("name", help="Server name (kebab-case)")
    parser.add_argument("transport", choices=["stdio", "streamable-http"],
                       help="Transport type")
    parser.add_argument("--command", help="Command for stdio transport")
    parser.add_argument("--args", help="Command arguments (JSON array)")
    parser.add_argument("--url", help="URL for streamable-http transport")
    parser.add_argument("--file", help="Path to .mcp.json")

    return parser.parse_args()


def load_config(mcp_file):
    """Load existing .mcp.json or create new structure."""
    if os.path.exists(mcp_file):
        with open(mcp_file, 'r') as f:
            return json.load(f)
    else:
        return {"mcpServers": {}}


def build_server_config(args):
    """Build server configuration from arguments."""
    server_config = {"transport": {"type": args.transport}}

    if args.transport == "stdio":
        if not args.command:
            print("ERROR: --command is required for stdio transport")
            sys.exit(1)

        server_config["transport"]["command"] = args.command

        # Parse args as JSON array
        if args.args:
            try:
                server_config["transport"]["args"] = json.loads(args.args)
            except json.JSONDecodeError:
                # Treat as single value in array
                server_config["transport"]["args"] = [args.args]
        else:
            server_config["transport"]["args"] = []

    elif args.transport == "streamable-http":
        if not args.url:
            print("ERROR: --url is required for streamable-http transport")
            sys.exit(1)

        server_config["transport"]["url"] = args.url

    return server_config


def merge_server(config, name, server_config):
    """Merge server configuration into existing config."""
    # Check if server already exists
    if name in config["mcpServers"]:
        print(f"WARNING: Server '{name}' already exists. Overwriting.")

    # Merge server
    config["mcpServers"][name] = server_config

    return config


def save_config(config, mcp_file):
    """Save configuration to file."""
    # Ensure directory exists
    os.makedirs(os.path.dirname(mcp_file) or '.', exist_ok=True)

    with open(mcp_file, 'w') as f:
        json.dump(config, f, indent=2)


def main():
    args = parse_args()

    # Determine .mcp.json path
    if args.file:
        mcp_file = args.file
    else:
        project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
        mcp_file = os.path.join(project_dir, ".mcp.json")

    # Load existing config
    try:
        config = load_config(mcp_file)
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON in {mcp_file}: {e}")
        sys.exit(3)
    except FileNotFoundError as e:
        print(f"ERROR: {e}")
        sys.exit(2)

    # Build server config
    server_config = build_server_config(args)

    # Merge server
    config = merge_server(config, args.name, server_config)

    # Save config
    save_config(config, mcp_file)

    print(f"✅ MCP server added: {args.name}")


if __name__ == "__main__":
    main()
