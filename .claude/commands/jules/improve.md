---
name: jules:improve
description: Get AI-suggested improvements from Jules based on TODO scanning, performance analysis, and pattern detection. Proactively identifies: optimizations, missing tests, doc gaps, refactoring opportunities.
argument-hint: [component-path or "--all" for full scan]
---

# Jules Improve

<mission_control>
<objective>Leverage Jules Suggested Tasks to find improvement opportunities in components</objective>
<success_criteria>Suggestions listed with confidence scores, one-click session creation available</success_criteria>
</mission_control>

Leverages Jules Suggested Tasks to proactively find improvement opportunities in your components.

## Usage

```
# Scan for suggestions across all components
/jules:improve --all

# Check specific skill
/jules:improve .claude/skills/quality-standards

# Check specific command
/jules:improve .claude/commands/toolkit/audit

# Scan for specific type of issue
/jules:improve --all --type performance
/jules:improve --all --type testing
/jules:improve --all --type documentation
```

## Suggestion Types

### 1. Performance Optimizations

**Detects**:

- Inefficient patterns (grep vs Read, bash vs native tools)
- Missing caching opportunities
- Redundant validation checks
- Slow search patterns

**Example Output**:

```
[85%] Performance: Replace grep loops with native Grep tool
  Location: .claude/skills/file-search/SKILL.md:45
  Impact: 3x faster searches, 50% less token usage
  Fix: Use mcp__vscode-mcp-server__find_files_code instead
```

### 2. Testing Gaps

**Detects**:

- Missing test files for skills/commands
- Untested code paths
- Missing edge case coverage
- No validation for examples

**Example Output**:

```
[90%] Testing: No test coverage for audit workflows
  Component: .claude/skills/toolkit-audit
  Missing: Tests for auto-detection, reference routing
  Suggestion: Generate test suite with TDD approach
```

### 3. Documentation Gaps

**Detects**:

- Missing examples.md
- Empty or minimal examples
- Outdated references
- Undocumented parameters

**Example Output**:

```
[75%] Documentation: Examples use old frontmatter format
  Location: .claude/skills/agent-development/examples.md:15
  Issue: Using deprecated `disable-model-invocation` field
  Fix: Update to new semantic anchoring pattern
```

### 4. Refactoring Opportunities

**Detects**:

- Code duplication
- Long functions that could be split
- Missing abstractions
- Inconsistent patterns

**Example Output**:

```
[70%] Refactor: Duplicate session creation logic
  Locations:
    - .claude/skills/jules-api/SKILL.md:120
    - .claude/skills/jules-api/examples.md:45
  Suggestion: Extract to jules_client.py helper function
```

### 5. TODO Items

**Detects**:

- Actionable TODO comments
- Deprecated code markers
- Temporary workarounds
- Technical debt markers

**Example Output**:

```
[95%] TODO: "Add progressive disclosure validation"
  Location: .claude/skills/invocable-development/SKILL.md:89
  Context: Need workflow for tier validation
  Effort: Medium (2-4 hours)
```

## Implementation

### Step 1: Scan Component(s)

```bash
# Scan single component
jules_client.scan_component(path)

# Scan all components
jules_client.scan_all_components()
```

### Step 2: Analyze with Jules

```python
# Use Jules Suggested Tasks feature
response = jules_client.get_suggested_tasks(component_path)

suggestions = response.get('suggestedTasks', [])
for suggestion in suggestions:
    print(f"[{suggestion['confidence']}] {suggestion['type']}: {suggestion['title']}")
    print(f"  Location: {suggestion['location']}")
    print(f"  Impact: {suggestion['impact']}")
    print(f"  Fix: {suggestion['suggestion']}")
```

### Step 3: Present Options

```bash
Found 5 suggestions:

[90%] Testing: Add test coverage for portability validation
[85%] Performance: Replace grep with native tools in file-search
[75%] Documentation: Update examples to semantic anchoring
[70%] Refactor: Extract duplicate Jules API call logic
[60%] TODO: Implement progressive disclosure validator

Create session for suggestion #1? [y/n/all/quit]
```

### Step 4: Create Improvement Session

```bash
if [[ "$CREATE_SESSION" == "y" ]]; then
  SESSION=$(python .claude/skills/jules-api/jules_client.py create \
    "Implement the suggested fix: $SUGGESTION" \
    "$OWNER" \
    "$REPO" \
    "$(git branch --show-current)" \
    --automation-mode "AUTO_CREATE_PR")

  echo "✅ Created session: $SESSION"
fi
```

## Output Format

```
🔍 Jules Suggested Improvements

Component: .claude/skills/quality-standards
Scan Date: 2026-01-28T21:00:00Z

Found 4 suggestions:

[90%] HIGH - Testing: Add test coverage for audit functions
   Location: .claude/skills/quality-standards/SKILL.md:45
   Impact: Critical quality gate needs validation
   Effort: Medium (2-3 hours)
   Fix: Create test suite with TDD approach for all audit workflows

[85%] MEDIUM - Performance: Cache reference file loading
   Location: .claude/skills/quality-standards/SKILL.md:78
   Impact: 30% faster command execution
   Effort: Low (30 minutes)
   Fix: Implement caching for loaded reference files

[75%] MEDIUM - Documentation: Examples use old frontmatter
   Location: .claude/skills/quality-standards/examples.md:12
   Impact: Examples don't match current patterns
   Effort: Low (15 minutes)
   Fix: Update to semantic anchoring format

[60%] LOW - TODO: "Add workflow for multi-skill audit"
   Location: .claude/skills/quality-standards/SKILL.md:92
   Impact: Feature gap for batch operations
   Effort: High (4-6 hours)
   Fix: Design and implement batch audit workflow

Actions:
  1. Create session for suggestion #1 [y]
  2. Create session for suggestion #2 [y]
  3. Create session for suggestion #3 [y]
  4. Create session for suggestion #4 [n]
  5. Create sessions for all [a]
  6. Skip all [q]
```

## Example Sessions

### Example 1: Scan All Components

```
User: /jules:improve --all

Claude: 🔍 Scanning all components for improvements...

      Skills (48):
        ✓ .claude/skills/quality-standards - 3 suggestions
        ✓ .claude/skills/invocable-development - 1 suggestion
        ...

      Commands (35):
        ✓ .claude/commands/toolkit/audit - 2 suggestions
        ✓ .claude/commands/qa/verify - 0 suggestions
        ...

      Total: 24 suggestions found

      Top 5 by confidence:
        [95%] Testing: Add tests for quality-standards
        [90%] Performance: Optimize grep patterns in file-search
        [85%] Documentation: Update examples in 12 skills
        [80%] Refactor: Extract duplicate Jules logic
        [75%] TODO: Implement progressive disclosure validator

      Process in batch? [y/n/q]
```

### Example 2: Focus on Performance

```
User: /jules:improve --all --type performance

Claude: 🔍 Scanning for performance opportunities...

      Found 7 performance suggestions:

      [90%] Replace grep with Grep tool (file-search skill)
         Impact: 3x faster, 50% fewer tokens
         Fix: Use mcp__vscode-mcp-server__find_files_code

      [85%] Cache reference file loading (quality-standards)
         Impact: 30% faster execution
         Fix: Implement file content caching

      [80%] Use Read instead of cat (examples in 5 files)
         Impact: Native tool efficiency
         Fix: Replace bash cat with Read tool

      Create batch session for all performance fixes? [y/n]
```

### Example 3: Process Specific Suggestion

```
User: /jules:improve .claude/skills/quality-standards

Claude: Found 3 suggestions:

      [90%] Add test coverage for audit functions
      [75%] Update examples to semantic anchoring
      [60%] Implement multi-skill audit workflow

      Process suggestion #1? [y]

Claude: ✅ Creating Jules session for test generation...

      Session ID: 1234567890
      URL: https://jules.google.com/session/1234567890

      Jules will create test suite with TDD approach.
      Expected completion: ~10 minutes.
```

## Interactive Workflow

```
1. Scan completes, suggestions listed
2. User selects which to process
3. Jules session(s) created
4. Sessions run asynchronously
5. PR(s) created when complete
6. User reviews and merges
```

## Related Commands

- `/jules:review` - Full component review (async)
- `/toolkit:audit` - Local synchronous audit
- `/jules:test` - Generate tests for component
- `/jules:refactor` - Refactor component patterns

## Configuration

Suggestion confidence thresholds can be adjusted:

```
--min-confidence 80  # Only show high-confidence suggestions
--max-suggestions 10   # Limit results
--type performance    # Filter by type
```

<critical_constraint>
MANDATORY: Review Jules suggestions before creating sessions
MANDATORY: High-confidence doesn't mean automatic approval
MANDATORY: Test all changes in PR before merging
</critical_constraint>
