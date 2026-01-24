# Scripts in Skills

When and how to use scripts effectively in skills.

## When to Use This Reference

Use this guide when:
- Deciding if a script is needed
- Writing scripts for skills
- Understanding script best practices
- Avoiding script anti-patterns

## When to Include Scripts

**Create scripts/ when**:
- Same code is being rewritten repeatedly
- Deterministic reliability is needed
- Performance-critical operations
- Complex validation or processing
- Executable utilities called multiple times

**Don't create scripts/ when**:
- Simple one-liners
- Highly variable tasks
- One-time operations
- Native tools work fine

## Decision Framework

### Question: Is the code complex?

**Complex** (>3-5 lines) → Consider script
**Simple** (1-2 lines) → Use native tools

### Question: Is it reusable?

**Called multiple times** → Consider script
**One-time use** → Direct execution

### Question: Does it need determinism?

**Must work exactly same way** → Script
**Can adapt to context** → Native tools

### Question: Is it performance-sensitive?

**Speed matters** → Script
**Flexibility matters** → Native tools

## Script Best Practices

### 1. Solve, Don't Punt

**Poor** (punts errors to caller):
```python
def read_file(path):
    return open(path).read()  # What if file doesn't exist?
```

**Good** (handles errors):
```python
def read_file(path):
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        print(f"File not found: {path}")
        return ""
```

### 2. Avoid Magic Numbers

**Poor** (undocumented constants):
```python
TIMEOUT = 47  # Why 47?
RETRIES = 5   # Why 5?
```

**Good** (documented rationale):
```python
# 3 retries balance reliability vs speed
MAX_RETRIES = 3
# 30 second timeout prevents hanging
TIMEOUT_SECONDS = 30
```

### 3. Be Self-Contained

**Poor** (assumes environment):
```python
import requests  # What if not installed?
```

**Good** (validates dependencies):
```python
try:
    import requests
except ImportError:
    print("Error: requests library required")
    exit(1)
```

### 4. Handle Edge Cases

**Poor** (crashes on edge cases):
```python
def process(data):
    return data.upper()  # What if data is None?
```

**Good** (handles edge cases):
```python
def process(data):
    if not data:
        return ""
    return data.upper()
```

### 5. Use Meaningful Exit Codes

**Standard exit codes**:
- `0` - Success
- `1` - Input/validation error
- `2` - System/configuration error
- `3` - Permission denied
- `4+` - Application-specific

**Example**:
```bash
#!/usr/bin/env bash

validate_input() {
    if [ -z "$1" ]; then
        echo "Error: Input required"
        exit 1
    fi
}

check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq required"
        exit 2
    fi
}

main() {
    validate_input "$1"
    check_dependencies
    # Process...
    exit 0
}
```

## Script Examples

### Example 1: PDF Rotation (Clear Value)

**When script helps**: Same code rewritten repeatedly

```python
#!/usr/bin/env python3
"""Rotate PDF pages by specified degrees."""

from PyPDF2 import PdfReader, PdfWriter
import sys

def rotate_pdf(input_path, output_path, rotation):
    """Rotate PDF by specified degrees (90, 180, 270)."""
    try:
        reader = PdfReader(input_path)
        writer = PdfWriter()

        for page in reader.pages:
            page.rotate(rotation)
            writer.add_page(page)

        with open(output_path, 'wb') as f:
            writer.write(f)

        return 0
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("Usage: rotate_pdf input output rotation")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]
    rotation = int(sys.argv[3])

    sys.exit(rotate_pdf(input_path, output_path, rotation))
```

**Why script?**
- Complex operation (20+ lines)
- Reusable utility
- Specific library required
- Error handling needed

### Example 2: JSON Validation (Clear Value)

**When script helps**: Deterministic validation

```bash
#!/usr/bin/env bash
"""Validate JSON files in directory."""

validate_json() {
    local file=$1
    if ! jq empty "$file" 2>/dev/null; then
        echo "❌ Invalid JSON: $file"
        return 1
    fi
    echo "✅ Valid: $file"
    return 0
}

main() {
    local directory=${1:-.}
    local found=0

    for file in "$directory"/*.json; do
        if [ -f "$file" ]; then
            validate_json "$file"
            found=1
        fi
    done

    if [ $found -eq 0 ]; then
        echo "No JSON files found in $directory"
        exit 1
    fi
}

main "$@"
```

**Why script?**
- Validation logic is complex
- Called multiple times
- Error messages specific
- Exit codes matter

### Example 3: When NOT to Use Script

**Task**: Count files in directory

**Don't use script**:
```bash
#!/usr/bin/env bash
# Unnecessary script
ls | wc -l
```

**Use native tools directly**:
```markdown
## File Count
Count files using `ls | wc -l`
```

**Why no script?**
- Simple one-liner
- Native tools work fine
- No complexity to manage

## Script Organization

### Directory Structure

```
skill-name/
├── SKILL.md
└── scripts/
    ├── validate.sh        # Validation utility
    ├── process.py         # Processing utility
    └── deploy.sh          # Deployment utility
```

### Naming Conventions

- Use kebab-case: `rotate-pdf.py`, `validate-json.sh`
- Descriptive names: `process-pdf.py` not `proc.py`
- Include extension: `.py`, `.sh`, etc.

### Permissions

Make scripts executable:
```bash
chmod +x scripts/script.sh
```

Or in skill creation:
```bash
touch scripts/script.sh
chmod +x scripts/script.sh
```

## Documentation in Scripts

### Shebang and Description

```bash
#!/usr/bin/env bash
#
# Skill: pdf-processor
# Script: rotate-pdf.sh
# Description: Rotate PDF pages by specified degrees
#
# Usage: ./rotate-pdf.sh input.pdf output.pdf 90
#
# Exit codes:
#   0 - Success
#   1 - Input validation error
#   2 - File not found
#   3 - Processing error
#
set -euo pipefail
```

### Inline Documentation

```python
def rotate_pdf(input_path, output_path, rotation):
    """
    Rotate PDF pages by specified degrees.

    Args:
        input_path: Path to input PDF file
        output_path: Path to output PDF file
        rotation: Rotation in degrees (90, 180, 270)

    Returns:
        0 on success, 1 on error

    Raises:
        FileNotFoundError: If input file doesn't exist
        ValueError: If rotation is not valid
    """
```

## Script Anti-Patterns

### Anti-Pattern: Over-Scripting

**Poor**: Script for simple task
```bash
#!/usr/bin/env bash
# Unnecessary
echo "Hello World"
```

**Good**: Direct instruction
```markdown
## Usage
Print "Hello World" to console
```

### Anti-Pattern: Brittle Paths

**Poor**: Windows-style paths, assumes location
```bash
./scripts\validate.sh
cd ../scripts
```

**Good**: Cross-platform, explicit paths
```bash
./.claude/skills/my-skill/scripts/validate.sh
```

### Anti-Pattern: No Validation

**Poor**: Fails cryptically
```bash
jq '.result' "$FILE"  # Fails if invalid JSON
```

**Good**: Validate first
```bash
if ! jq empty "$FILE" 2>/dev/null; then
    echo "Error: Invalid JSON file: $FILE"
    exit 1
fi
jq '.result' "$FILE"
```

### Anti-Pattern: Silent Failures

**Poor**: Fails silently
```bash
set +e  # Don't do this
command_that_might_fail
echo "Done"  # Even if failed
```

**Good**: Explicit error handling
```bash
set -euo pipefail  # Exit on errors
command_that_might_fail
echo "Done"  # Only if succeeded
```

## Language Selection

### Bash Scripts

**Use when**:
- Simple file operations
- Command orchestration
- Cross-platform compatibility needed
- No complex data structures

**Example**: Validation, deployment, file management

### Python Scripts

**Use when**:
- Complex data processing
- External libraries needed
- Error handling important
- Data transformation

**Example**: PDF processing, data parsing, API interaction

### Choose Based on Task

**Simple file operations** → Bash
**Complex processing** → Python
**Text manipulation** → Either (Bash simpler, Python more robust)
**API calls** → Python (requests library)

## Testing Scripts

### Before Including in Skill

1. **Test with valid input**
   ```bash
   ./scripts/validate.sh test-file.json
   ```

2. **Test with invalid input**
   ```bash
   ./scripts/validate.sh invalid-file.txt
   ```

3. **Test with missing input**
   ```bash
   ./scripts/validate.sh
   ```

4. **Verify exit codes**
   ```bash
   ./scripts/validate.sh test-file.json
   echo $?  # Should be 0
   ```

### Document Test Results

```markdown
## Scripts

### validate.sh
Validates JSON files in directory.

**Tested**:
- ✅ Valid JSON: Passes validation
- ✅ Invalid JSON: Returns error
- ✅ Missing directory: Returns error
- ✅ Empty directory: Returns error
```

## Summary

**Use scripts when**:
- Complex operations (>3-5 lines)
- Repeated execution needed
- Performance matters
- Determinism required

**Don't use scripts when**:
- Simple operations
- One-time tasks
- Variable patterns
- Native tools suffice

**Always**:
- Handle errors explicitly
- Document constants
- Validate dependencies
- Use meaningful exit codes
- Test before deploying

## See Also

- **[creation.md](../core/creation.md)** - Skill creation guide
- **[structure.md](../core/structure.md)** - Directory patterns
- **[anti-patterns.md](anti-patterns.md)** - Common mistakes
