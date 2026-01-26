#!/bin/bash
# validate_skill.sh - Validates the manual-e2e-testing skill structure

# Get project root from script location
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
SKILL_DIR="${PROJECT_ROOT}/.claude/skills/manual-e2e-testing"

echo "=== Manual E2E Testing Skill Validation ==="
echo ""

# Check if skill directory exists
if [ ! -d "$SKILL_DIR" ]; then
  echo "✗ Skill directory not found: $SKILL_DIR"
  exit 1
fi

echo "✓ Skill directory exists"

# Check SKILL.md exists and is readable
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "✗ SKILL.md not found"
  exit 1
fi

echo "✓ SKILL.md exists"

# Check YAML frontmatter
if grep -q "^---" "$SKILL_DIR/SKILL.md"; then
  echo "✓ YAML frontmatter present"
else
  echo "✗ YAML frontmatter missing"
  exit 1
fi

# Check required frontmatter fields
if grep -q "^name: manual-e2e-testing" "$SKILL_DIR/SKILL.md"; then
  echo "✓ Name field present"
else
  echo "✗ Name field missing or incorrect"
  exit 1
fi

if grep -q "^description:" "$SKILL_DIR/SKILL.md"; then
  echo "✓ Description field present"
else
  echo "✗ Description field missing"
  exit 1
fi

# Check references directory
if [ -d "$SKILL_DIR/references" ]; then
  echo "✓ References directory exists"

  # Check each reference file
  ref_files=(
    "detailed-procedures.md"
    "element-discovery.md"
    "state-validation.md"
    "error-recovery.md"
    "test-reports.md"
  )

  for file in "${ref_files[@]}"; do
    if [ -f "$SKILL_DIR/references/$file" ]; then
      echo "  ✓ $file"
    else
      echo "  ✗ $file missing"
      exit 1
    fi
  done
else
  echo "✗ References directory missing"
  exit 1
fi

# Check scripts directory
if [ -d "$SKILL_DIR/scripts" ]; then
  echo "✓ Scripts directory exists"
else
  echo "✗ Scripts directory missing"
  exit 1
fi

# Validate markdown structure
echo ""
echo "=== Markdown Structure Validation ==="

# Check for proper headers
if grep -q "^# " "$SKILL_DIR/SKILL.md"; then
  echo "✓ Main headers present"
else
  echo "⚠ Main headers may be missing"
fi

# Check for code blocks
if grep -q '```bash' "$SKILL_DIR/SKILL.md"; then
  echo "✓ Code blocks present"
else
  echo "⚠ Code blocks may be missing"
fi

# Check references are linked
echo ""
echo "=== Cross-Reference Validation ==="

ref_count=$(grep -c '\[' "$SKILL_DIR/SKILL.md" | grep -c 'references/' || echo "0")
if [ $ref_count -gt 0 ] 2>/dev/null; then
  echo "✓ Cross-references to reference files found"
else
  echo "⚠ No cross-references found"
fi

# File sizes
echo ""
echo "=== File Size Summary ==="
echo "SKILL.md: $(wc -l < "$SKILL_DIR/SKILL.md") lines"
echo "detailed-procedures.md: $(wc -l < "$SKILL_DIR/references/detailed-procedures.md") lines"
echo "element-discovery.md: $(wc -l < "$SKILL_DIR/references/element-discovery.md") lines"
echo "state-validation.md: $(wc -l < "$SKILL_DIR/references/state-validation.md") lines"
echo "error-recovery.md: $(wc -l < "$SKILL_DIR/references/error-recovery.md") lines"
echo "test-reports.md: $(wc -l < "$SKILL_DIR/references/test-reports.md") lines"

echo ""
echo "=== Validation Complete ==="
echo "✓ All checks passed!"
echo ""
echo "Skill structure is valid and ready to use."
echo "The skill can be invoked with: /manual-e2e-testing"
