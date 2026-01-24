#!/usr/bin/env bash
# validate_structure.sh - Validate skill YAML structure
#
# Dependencies: None (bash built-ins only)
#
# Exit Codes:
#   0 - Validation passed
#   1 - Validation failed

set -euo pipefail

usage() {
    cat << 'EOF'
Usage: validate_structure.sh <skill-path>

Validates skill structure and YAML frontmatter.

ARGUMENTS:
  skill-path    Path to skill directory

EXAMPLES:
  validate_structure.sh .claude/skills/my-skill
EOF
    exit 1
}

validate_skill() {
    local skill_path="$1"

    if [[ ! -d "$skill_path" ]]; then
        echo "❌ FAIL: Skill directory does not exist: $skill_path"
        return 1
    fi

    local skill_file="${skill_path}/SKILL.md"

    if [[ ! -f "$skill_file" ]]; then
        echo "❌ FAIL: SKILL.md not found: $skill_file"
        return 1
    fi

    # Check YAML frontmatter
    if ! grep -q "^---" "$skill_file"; then
        echo "❌ FAIL: Missing YAML frontmatter (no --- delimiter)"
        return 1
    fi

    # Check required fields
    local missing_fields=()

    if ! grep -q "^name:" "$skill_file"; then
        missing_fields+=("name")
    fi

    if ! grep -q "^description:" "$skill_file"; then
        missing_fields+=("description")
    fi

    if [[ ${#missing_fields[@]} -gt 0 ]]; then
        echo "❌ FAIL: Missing required fields: ${missing_fields[*]}"
        return 1
    fi

    # Check line count
    local lines=$(wc -l < "$skill_file")
    if [[ $lines -gt 500 ]]; then
        echo "⚠️  WARNING: SKILL.md exceeds 500 lines (${lines} lines)"
        echo "   Consider moving content to references/"
    else
        echo "✅ PASS: SKILL.md has ${lines} lines (under 500)"
    fi

    # Check for references directory
    if [[ -d "${skill_path}/references" ]]; then
        local ref_count=$(ls -1 "${skill_path}/references" 2>/dev/null | wc -l)
        echo "✅ PASS: references/ directory exists with ${ref_count} files"
    fi

    # Check skill name format (kebab-case)
    local skill_name=$(basename "$skill_path")
    if [[ ! "$skill_name" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
        echo "⚠️  WARNING: Skill name may not follow kebab-case: $skill_name"
    fi

    echo "✅ PASS: Skill structure valid"
    return 0
}

# Parse arguments
if [[ $# -lt 1 ]]; then
    usage
fi

validate_skill "$1"
