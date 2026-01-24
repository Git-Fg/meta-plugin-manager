# Test Runner Helper

Modern Python-based helper tools for the test-runner skill suite using PEP-standard Python scripts with `uv run`.

## Overview

Provides JSON parsing, batch operations, and lifecycle tracking for test execution workflows.

## Features

- **JSON Test Plan Management**: Find next test, update status, track progress
- **Test Output Analysis**: Parse NDJSON, score autonomy, detect tool usage
- **Batch Operations**: Update multiple tests, mark phases complete
- **Lifecycle Tracking**: Track setup → execute → validate → archive phases

## Usage

All commands use `uv run` to execute the Python script:

### Test Plan Operations

```bash
# Find next NOT_STARTED test
uv run scripts/test_runner_helper.py find-next

# Update test status and metrics
uv run scripts/test_runner_helper.py update-status "2.3" "COMPLETED" "100" "5432"

# Show overall progress
uv run scripts/test_runner_helper.py progress

# Update lifecycle stage
uv run scripts/test_runner_helper.py lifecycle-stage "4.4" "validate"

# Mark phase complete
uv run scripts/test_runner_helper.py phase-complete 2

# Add finding to test
uv run scripts/test_runner_helper.py add-finding "2.1" "Context isolation confirmed"
```

### Test Output Analysis

```bash
# Analyze single test output
uv run scripts/test_runner_helper.py analyze /path/to/test-output.json

# Detect tool usage patterns
uv run scripts/test_runner_helper.py detect-tools /path/to/test-output.json

# Comprehensive execution analysis
uv run scripts/test_runner_helper.py analyze-execution /path/to/test-output.json
```

## Direct Execution (Alternative)

```bash
# Make executable and run directly
chmod +x scripts/test_runner_helper.py
./scripts/test_runner_helper.py <command> [args...]
```

## Configuration

### Test Plan Path

Default: `tests/skill_test_plan.json` (relative to project root)

The script automatically resolves the path relative to the script location.

## Architecture

### Components

1. **TestPlanManager**: Core class for JSON operations
   - Safe JSON loading/saving
   - Robust error handling
   - Type-safe operations

2. **TestResult**: Data class for test metrics
   - Autonomy scoring
   - Permission denial counting
   - NDJSON validation

3. **CLI Interface**: Command-line interface
   - Subcommand-based design
   - Clear error messages
   - JSON output support

### Design Principles

- **Defensive Programming**: Validate inputs, handle errors gracefully
- **Type Safety**: Use dataclasses and type hints
- **Fail Fast**: Exit early on invalid state
- **Clear Errors**: Provide actionable error messages

## Migration from Bash

### Old vs New

| Bash Script | Python Equivalent |
|------------|-------------------|
| `bash scripts/test_runner_helper.sh find-next` | `uv run scripts/test_runner_helper.py find-next` |
| `bash scripts/test_runner_helper.sh update-status` | `uv run scripts/test_runner_helper.py update-status` |
| `bash scripts/test_runner_helper.sh progress` | `uv run scripts/test_runner_helper.py progress` |
| `bash scripts/analyze_tools.sh` | `uv run scripts/test_runner_helper.py analyze` |

### Benefits

✅ **Type Safety**: Dataclasses prevent invalid state
✅ **Error Handling**: Structured exception handling
✅ **Maintainability**: OOP design, clear separation
✅ **Testability**: Unit tests, testable functions
✅ **Performance**: In-memory JSON operations
✅ **Extensibility**: Easy to add new commands
✅ **Modern Python**: PEP-standard scripts, no setup.py needed
✅ **UV Integration**: Uses `uv run` for execution

## File Structure

```
.claude/skills/test-runner/scripts/
├── analyze_tools.sh           # Original bash analyzer
├── test_runner_helper.sh      # Original bash helper
├── test_runner_helper.py      # Modern Python version
└── README.md                  # This file
```

## Testing

```bash
# Run comprehensive test
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3
./test_commands.sh

# Test individual commands
uv run scripts/test_runner_helper.py progress
uv run scripts/test_runner_helper.py find-next
uv run scripts/test_runner_helper.py analyze tests/raw_logs/phase_2/test_2.1.basic.fork.json
```

## License

MIT
