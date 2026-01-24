# Script Implementation Best Practices

**Reference for**: Skills that include executable scripts in their `scripts/` directory

**Purpose**: Teach script implementation patterns that ensure reliability, maintainability, and consistency.

---

## Core Principles

### 1. Solve, Don't Punt

**Principle**: Handle error conditions explicitly rather than punting to Claude.

> *"When writing scripts for Skills, handle error conditions rather than punting to Claude."*

**❌ Bad Example**: Punting to Claude
```python
def process_file(path):
    # Just fail and let Claude figure it out
    return open(path).read()
```

**✅ Good Example**: Handle errors explicitly
```python
def process_file(path):
    """Process a file, creating it if it doesn't exist."""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # Create file with default content instead of failing
        print(f"File {path} not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # Provide alternative instead of failing
        print(f"Cannot access {path}, using default")
        return ''
```

**Key Pattern**:
- Explicit error handling for expected failure modes
- Helpful error messages that explain what went wrong
- Fallback behavior where appropriate
- Exit codes that indicate the type of failure

---

### 2. Avoid Magic Numbers (Configuration Parameters)

**Principle**: All configuration values must be justified and documented.

> *"Configuration parameters should also be justified and documented to avoid 'voodoo constants'. If you don't know the right value, how will Claude determine it?"*

**❌ Bad Example**: Undocumented values
```bash
TIMEOUT=47  # Why 47?
RETRIES=5   # Why 5?
MAX_FILES=13  # Why 13?
```

**✅ Good Example**: Self-documenting constants
```bash
# HTTP requests typically complete within 30 seconds
# Longer timeout accounts for slow connections
REQUEST_TIMEOUT=30

# Three retries balances reliability vs speed
# Most intermittent failures resolve by the second retry
MAX_RETRIES=3

# Process up to 50 files before checkpointing
# Balances memory usage with progress persistence
BATCH_SIZE=50
```

**Pattern**:
- Comment explains WHY the value was chosen
- Comment explains WHAT the value controls
- Consider making values configurable when appropriate

---

### 3. Self-Contained Scripts

**Principle**: Scripts should be self-contained or clearly document dependencies.

> *"Scripts should: Be self-contained or clearly document dependencies"*

**Dependency Documentation Template**:
```bash
#!/usr/bin/env bash
# Script Name - Brief description
#
# Dependencies: jq 1.6+, curl 7.79+
# Optional: imagemagick (for image processing)
#
# Required Environment Variables:
#   CLAUDE_PROJECT_DIR - Project root directory
#
# Optional Environment Variables:
#   TIMEOUT - Request timeout in seconds (default: 30)
#   RETRY_COUNT - Number of retries (default: 3)
#
set -euo pipefail

# Validate dependencies
check_dependencies() {
    local missing=()

    command -v jq >/dev/null 2>&1 || missing+=("jq")
    command -v curl >/dev/null 2>&1 || missing+=("curl")

    if [ ${#missing[@]} -gt 0 ]; then
        echo "ERROR: Missing required dependencies: ${missing[*]}"
        echo "Install with: apt-get install ${missing[*]}"
        exit 1
    fi
}

check_dependencies
```

---

### 4. Edge Case Handling

**Principle**: Handle edge cases gracefully.

**Common Edge Cases to Handle**:

1. **Empty input files**:
```bash
if [ ! -s "$INPUT_FILE" ]; then
    echo "Warning: Input file is empty"
    exit 0  # Empty file is valid, not an error
fi
```

2. **Missing directories**:
```bash
# Create output directory if it doesn't exist
OUTPUT_DIR="${OUTPUT_DIR:-./output}"
mkdir -p "$OUTPUT_DIR"
```

3. **Permission errors**:
```bash
if ! touch "$TEST_FILE" 2>/dev/null; then
    echo "ERROR: No write permission to $(dirname "$TEST_FILE")"
    exit 3
fi
```

4. **Invalid input formats**:
```bash
# Validate JSON before processing
if ! jq empty "$INPUT_FILE" 2>/dev/null; then
    echo "ERROR: Invalid JSON format in $INPUT_FILE"
    echo "Run 'jq . < \"$INPUT_FILE\"' to see details"
    exit 2
fi
```

---

### 5. Clear Execution Intent

**Principle**: Make it clear whether to execute a script or read it as reference.

> *"Make clear in your instructions whether Claude should: Execute the script (most common): "Run `analyze_form.py` to extract fields" - Read it as reference: "See `analyze_form.py` for the field extraction algorithm""*

**In SKILL.md, specify execution intent**:

**For Execution** (most common):
```markdown
## Utility Scripts

**analyze_form.py**: Extract all form fields from PDF
```bash
python scripts/analyze_form.py input.pdf > fields.json
```

Output format:
```json
{"field_name": {"type": "text", "x": 100, "y": 200}}
```
```

**For Reference** (complex algorithm documentation):
```markdown
## Algorithm Reference

**extract.py**: Full field extraction algorithm
- Run: `scripts/extract.py --help` for usage
- See inline comments for algorithm details
```

---

### 6. Exit Code Conventions

**Use meaningful exit codes**:

| Code | Meaning | Usage |
|------|---------|-------|
| 0 | Success | Normal completion |
| 1 | Error | Input/validation error (user fixable) |
| 2 | Fatal | System/configuration error (requires admin) |
| 3 | Blocking | Operation denied (security/policy) |

**Example**:
```bash
# Validate input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found: $INPUT_FILE"
    exit 1  # User can fix by providing correct path
fi

# Check write permissions
if ! touch "$OUTPUT_DIR/.write_test" 2>/dev/null; then
    echo "Error: No write permission to $OUTPUT_DIR"
    exit 3  # Blocking security error
fi
```

---

### 7. File Path Best Practices

**Principle**: Always use forward slashes for cross-platform compatibility.

> *"Always use forward slashes in file paths, even on Windows. Unix-style paths work across all platforms."*

**✅ Correct**:
```bash
scripts/validate.sh
references/guide.md
./.claude/scripts/tool.sh
```

**❌ Avoid** (Windows-specific):
```bash
scripts\validate.sh
references\guide.md
```

**Use ABSOLUTE paths when needed for tests**:
```bash
# For test reproducibility
TEST_DIR="/absolute/path/to/tests/test_X_X"
cd "$TEST_DIR" && claude ...
```

---

### 8. Plan-Validate-Execute Pattern

**Principle**: For complex operations, create verifiable intermediate outputs.

> *"Create verifiable intermediate outputs. When Claude performs complex, open-ended tasks, it can make mistakes. The 'plan-validate-execute' pattern catches errors early."*

**Pattern**:
```bash
# Step 1: Create plan file
./scripts/generate_plan.sh > plan.json

# Step 2: Validate plan
./scripts/validate_plan.sh plan.json
if [ $? -ne 0 ]; then
    echo "Plan validation failed, please fix issues"
    exit 2
fi

# Step 3: Execute plan
./scripts/execute_plan.sh plan.json

# Step 4: Verify output
./scripts/verify_output.sh output.json
```

**When to Use**:
- Batch operations (multiple files)
- Destructive changes (deletions, modifications)
- Complex validation rules
- High-stakes operations

---

## When to Use Scripts vs Native Tools

### Use Scripts When:

1. **Complex operations** (>3-5 lines):
   ```bash
   # Script is better for complex validation
   ./scripts/validate_complex.sh "$FILE"
   ```

2. **Reusable utilities**:
   ```bash
   # Script is better for repeated operations
   ./scripts/deploy.sh --environment staging
   ```

3. **Deterministic execution**:
   ```bash
   # Script ensures consistent behavior
   ./scripts/migrate.sh --backup --verify
   ```

4. **Performance-sensitive**:
   ```bash
   # Script is faster than Claude-generated code
   ./scripts/batch_process.sh "$DIRECTORY"
   ```

### Use Native Tools When:

1. **Simple operations** (1-2 lines):
   ```bash
   # Native tools are sufficient
   grep "pattern" file.txt
   ```

2. **One-time operations**:
   ```bash
   # No need to script one-time tasks
   rm temp_file.txt
   ```

3. **Highly variable tasks**:
   ```bash
   # Claude is better at adapting to context
   # Let Claude decide the approach
   ```

---

## Script Structure Template

```bash
#!/usr/bin/env bash
# Script Name - Brief single-line description
#
# Full description with multiple lines
# explaining what the script does and when to use it.
#
# Dependencies: jq 1.6+, curl 7.79+
#
# Required Environment Variables:
#   CLAUDE_PROJECT_DIR - Project root directory
#
# Optional Environment Variables:
#   TIMEOUT - Request timeout in seconds (default: 30)
#   RETRY_COUNT - Number of retries (default: 3)
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - System configuration error
#   3 - Permission denied
#
# Usage: ./script-name.sh [options] <arguments>

set -euo pipefail

# Configuration - All values documented
# Default timeout accounts for network latency (30s)
DEFAULT_TIMEOUT=30
# Three retries balance reliability vs speed
DEFAULT_RETRIES=3
# Batch size of 50 balances memory vs progress persistence
BATCH_SIZE=50

# Functions
main() {
    # Validate dependencies
    check_dependencies

    # Parse arguments
    local input_file="${1:-}"

    # Validate input
    if [ -z "$input_file" ]; then
        echo "Usage: $0 <input-file>"
        exit 1
    fi

    # Process
    process_input "$input_file"
}

check_dependencies() {
    local missing=()

    command -v jq >/dev/null 2>&1 || missing+=("jq")

    if [ ${#missing[@]} -gt 0 ]; then
        echo "ERROR: Missing required dependencies: ${missing[*]}"
        echo "Install with: apt-get install ${missing[*]}"
        exit 2
    fi
}

process_input() {
    local file="$1"

    # Validate file format
    if ! jq empty "$file" 2>/dev/null; then
        echo "ERROR: Invalid JSON format in $file"
        exit 1
    fi

    # Process...
}

# Run main
main "$@"
```

---

## Validation Checklist

Before considering a script production-ready, verify:

- [ ] **Error handling**: All expected error conditions are handled explicitly
- [ ] **Exit codes**: Meaningful exit codes (0=success, 1=input, 2=system, 3=blocked)
- [ ] **Dependencies**: All dependencies documented and validated
- [ ] **Configuration**: All constants have explanatory comments
- [ ] **Edge cases**: Empty files, missing directories, permissions handled
- [ ] **Paths**: Use forward slashes, no Windows-style backslashes
- [ ] **Input validation**: File formats validated before processing
- [ ] **Help text**: Usage instructions included
- [ ] **Self-contained**: Works independently or documents dependencies clearly

---

## Common Anti-Patterns

### ❌ Bad: Punting to Claude
```python
# Just fails and lets Claude figure it out
return open(path).read()
```

### ❌ Bad: Magic Numbers
```bash
MAX_RETRIES=47  # Why 47?
```

### ❌ Bad: Brittle Paths
```bash
cd ../scripts  # Unreliable, breaks context
```

### ❌ Bad: No Validation
```bash
# No check if file exists or is valid JSON
jq '.result' "$FILE"  # Fails cryptically
```

---

## See Also

- **[creation.md](creation.md)** - Creating new skills with scripts
- **[quality-framework.md](quality-framework.md)** - 11-dimensional scoring
- **[official-features.md](official-features.md)** - Official Agent Skills features

---

## Quick Reference

| Principle | Summary | Key Pattern |
|-----------|---------|-------------|
| **Solve, Don't Punt** | Handle errors explicitly | try/except with fallbacks |
| **No Magic Numbers** | Document all constants | Comments explain WHY |
| **Self-Contained** | Document dependencies | check_dependencies() |
| **Edge Cases** | Handle gracefully | Empty files, permissions |
| **Clear Intent** | Execute vs Reference | Specify in SKILL.md |
| **Exit Codes** | Meaningful codes | 0=success, 1=input, 2=system, 3=blocked |
| **Forward Slashes** | Cross-platform paths | scripts/validate.sh |
| **Plan-Validate-Execute** | Verify intermediate outputs | Validate before execute |
