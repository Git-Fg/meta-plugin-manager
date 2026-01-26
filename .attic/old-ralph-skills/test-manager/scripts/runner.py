#!/usr/bin/env python3
import argparse
import json
import sys
import subprocess
import time
import os
from pathlib import Path
from typing import Dict, Any, List


class TelemetryAccumulator:
    def __init__(self):
        self.stats = {
            # Init data (system message)
            "available_tools": [],
            "available_skills": [],
            "available_agents": [],
            "mcp_servers": [],
            "slash_commands": [],
            "model": "unknown",
            "permission_mode": None,
            # Execution tracking
            "tool_counts": {},
            "tool_usage_sequence": [],
            # Result data
            "duration_ms": 0,
            "num_turns": 0,
            "permission_denials": 0,
            "exit_code": None,
            "is_error": False,
        }

    def parse_line(self, line: str):
        try:
            if not line.strip():
                return
            data = json.loads(line)
            msg_type = data.get("type")

            # A. System Init - Capture ALL available data
            if msg_type == "system" and data.get("subtype") == "init":
                self.stats["available_tools"] = data.get("tools", [])
                self.stats["available_skills"] = data.get("skills", [])
                self.stats["available_agents"] = data.get("agents", [])
                self.stats["mcp_servers"] = data.get("mcp_servers", [])
                self.stats["slash_commands"] = data.get("slash_commands", [])
                self.stats["model"] = data.get("model", "unknown")
                self.stats["permission_mode"] = data.get("permissionMode")

            # B. Assistant - Track ALL tool uses dynamically
            elif msg_type == "assistant":
                content = data.get("message", {}).get("content", [])
                if isinstance(content, list):
                    for block in content:
                        if block.get("type") == "tool_use":
                            t_name = block.get("name")
                            if t_name:
                                self.stats["tool_counts"][t_name] = (
                                    self.stats["tool_counts"].get(t_name, 0) + 1
                                )
                                self.stats["tool_usage_sequence"].append(t_name)

            # C. Result - Capture ALL result data
            elif msg_type == "result":
                self.stats["duration_ms"] = data.get("duration_ms", 0)
                self.stats["num_turns"] = data.get("num_turns", 0)
                self.stats["permission_denials"] = len(
                    data.get("permission_denials", [])
                )
                self.stats["is_error"] = data.get("is_error", False)
                self.stats["exit_code"] = 0 if data.get("subtype") == "success" else 1

        except Exception:
            pass


def analyze_file(file_path: str) -> None:
    """Offline analysis of an existing NDJSON log file."""
    path = Path(file_path)
    if not path.exists():
        print(json.dumps({"error": f"File not found: {path}"}))
        sys.exit(1)

    accumulator = TelemetryAccumulator()
    try:
        with open(path, "r") as f:
            for line in f:
                accumulator.parse_line(line)
    except Exception as e:
        print(json.dumps({"error": f"Failed to read file: {str(e)}"}))
        sys.exit(1)

    result = {
        "status": "ANALYZED",
        "log_path": str(path.absolute()),
        "telemetry": accumulator.stats,
    }
    print(json.dumps(result, indent=2))


def run_trial(path: str, prompt: str, max_turns: int = 15) -> None:
    """Execute and stream raw logs + parsed telemetry."""
    sandbox_dir = Path(path).resolve()
    if not sandbox_dir.exists():
        print(
            json.dumps(
                {"error": f"Sandbox not found: {sandbox_dir}", "status": "ERROR"}
            )
        )
        sys.exit(1)

    output_file = sandbox_dir / "raw_log.json"
    env = os.environ.copy()

    cmd = [
        "claude",
        "--dangerously-skip-permissions",
        "-p",
        prompt,
        "--output-format",
        "stream-json",
        "--verbose",
        "--no-session-persistence",
        "--max-turns",
        str(max_turns),
    ]

    accumulator = TelemetryAccumulator()
    start_time = time.time()
    exit_code = 0
    try:
        with open(output_file, "w") as f:
            process = subprocess.Popen(
                cmd,
                cwd=sandbox_dir,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                env=env,
                bufsize=1,
            )

            # Stream raw logs to both file and stdout
            for line in process.stdout:
                f.write(line)
                f.flush()  # Ensure immediate write to file
                print(line.rstrip())  # Stream to AI agent
                sys.stdout.flush()  # Ensure immediate output
                accumulator.parse_line(line)

            exit_code = process.wait()

    except Exception as e:
        print(json.dumps({"error": str(e), "status": "CRASH"}))
        sys.exit(1)

    duration_ms = int((time.time() - start_time) * 1000)

    # Print separator and final parsed summary
    print("\n" + "="*80)
    print("# TEST RUNNER: RAW LOGS COMPLETE")
    print("="*80 + "\n")

    result = {
        "status": "EXECUTED",
        "log_path": str(output_file.absolute()),
        "cwd": str(sandbox_dir),
        "exit_code": exit_code,
        "duration_ms": duration_ms,
        "telemetry": accumulator.stats,
    }
    print(json.dumps(result, indent=2))


def main():
    parser = argparse.ArgumentParser(
        description="Backbone Runner (V9.0 - Generic Parser)"
    )
    sub = parser.add_subparsers(dest="cmd")

    run = sub.add_parser("execute", help="Launch a trial.")
    run.add_argument("path", help="Absolute path to sandbox")
    run.add_argument("prompt", help="Trigger prompt")
    run.add_argument("--max-turns", type=int, default=15)

    ana = sub.add_parser("summarize", help="Analyze existing log.")
    ana.add_argument("file", help="Absolute path to JSON log")

    args = parser.parse_args()
    if args.cmd == "execute":
        run_trial(args.path, args.prompt, args.max_turns)
    elif args.cmd == "summarize":
        analyze_file(args.file)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
