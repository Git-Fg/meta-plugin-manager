# Test Runner Helper

Modern Python-based helper tools for the test-runner skill suite.

## Overview

Provides JSON parsing, batch operations, and lifecycle tracking for test execution workflows.

## Features

- **JSON Test Plan Management**: Find next test, update status, track progress
- **Test Output Analysis**: Parse NDJSON, score autonomy, detect tool usage
- **Batch Operations**: Update multiple tests, mark phases complete
- **Lifecycle Tracking**: Track setup → execute → validate → archive phases

## Installation

### Development Mode

```bash
# Install in development mode
pip install -e .

# Or using uv
uv pip install -e .
```

### Direct Usage

```bash
# Make executable and run directly
chmod +x test_runner_helper.py
./test_runner_helper.py <command> [args...]
```

## Commands

### Test Plan Operations

```bash
# Find next NOT_STARTED test
test-runner-helper find-next

# Update test status and metrics
test-runner-helper update-status "2.3" "COMPLETED" "100" "5432"

# Show overall progress
test-runner-helper progress

# Update lifecycle stage
test-runner-helper lifecycle-stage "4.4" "validate"

# Mark phase complete
test-runner-helper phase-complete 2

# Add finding to test
test-runner-helper add-finding "2.1" "Context isolation confirmed"
```

### Test Output Analysis

```bash
# Analyze single test output
test-runner-helper analyze /path/to/test-output.json

# Detect tool usage patterns
test-runner-helper detect-tools /path/to/test-output.json

# Comprehensive execution analysis
test-runner-helper analyze-execution /path/to/test-output.json
```

## Configuration

### Test Plan Path

Default: `./tests/skill_test_plan.json`

Override with environment variable:
```bash
TEST_PLAN=/custom/path/test_plan.json test-runner-helper progress
```

Or pass directly in code:
```python
manager = TestPlanManager(Path("/custom/path/test_plan.json"))
```

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

## Testing

```bash
# Run tests
pytest

# With coverage
pytest --cov=test_runner_helper

# Using uv
uv run pytest
```

## Migration from Bash

### Old vs New

| Bash Script | Python Equivalent |
|------------|-------------------|
| `find_next_test()` | `test_runner_helper.py find-next` |
| `update_test_status()` | `test_runner_helper.py update-status` |
| `get_progress()` | `test_runner_helper.py progress` |
| `analyze_output()` | `test_runner_helper.py analyze` |
| `detect_tool_usage()` | `test_runner_helper.py detect-tools` |

### Benefits

✅ **Type Safety**: Dataclasses prevent invalid state  
✅ **Error Handling**: Structured exception handling  
✅ **Maintainability**: OOP design, clear separation  
✅ **Testability**: Unit tests, testable functions  
✅ **Performance**: In-memory JSON operations  
✅ **Extensibility**: Easy to add new commands  

## License

MIT
