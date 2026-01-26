# Documentation Validation Patterns

Use this guide when validating documentation quality, especially for terminal demos, screenshots, and codebase analysis. Uses LLM-as-judge semantic validation rather than brittle string matching.

---

## Philosophy

**Semantic validation > String matching**

Instead of checking exact text matches, use LLM understanding to validate that documentation "looks right"—checking layout, content presence, and visual hierarchy without breaking on minor formatting changes.

---

## Terminal Demo Validation

### Automated Checks (Run First)

```bash
# Check file size (must be < 5MB for GitHub)
ls -lh demo.gif

# Check recording duration from .cast metadata
head -1 demo.cast | jq '.duration // "check manually"'
```

**Expected values:**
- File size: < 2MB ideal, < 5MB max
- Duration: 20-30 seconds

### Visual Validation (LLM-as-Judge)

Extract a frame for analysis:

```bash
# Render specific timestamp (e.g., 15 seconds in)
svg-term --in demo.cast --out demo-preview.svg --at 15000

# Or use freeze for snapshot
asciinema cat demo.cast | head -500 | freeze -o demo-preview.png
```

**Validation prompt:**
```
Analyze this terminal demo screenshot. Check:
1. Is the text readable (not too small/blurry)?
2. Is the command being demonstrated visible?
3. Is there any sensitive info (API keys, /Users/username paths)?
4. Does the terminal look clean (simple prompt, no clutter)?
5. Is the "aha moment" visible - what value does this demo show?

Rate: PASS or FAIL with specific issues.
```

### Content Validation (Parse .cast File)

The `.cast` file is JSON lines - validate content programmatically:

```bash
# Check what commands were typed (input events)
grep '"i"' demo.cast | head -20

# Check recording duration
head -1 demo.cast | jq -r '.duration | floor'

# Look for sensitive patterns
grep -iE '(api.?key|password|secret|/Users/[a-z])' demo.cast && echo "WARNING: Sensitive data found!"
```

### Full Validation Checklist

After running the above, verify:

- [ ] File size < 5MB (automated)
- [ ] Duration 20-30 seconds (automated)
- [ ] No sensitive info in .cast (automated)
- [ ] Text readable in preview frame (visual/LLM)
- [ ] Demo shows feature clearly (visual/LLM)
- [ ] Clean terminal appearance (visual/LLM)

---

## TUI Output Validation

### Built-in Criteria

**`ralph-header`** - Validates Ralph TUI header:
- Iteration counter in `[iter N]` or `[iter N/M]` format
- Elapsed time in `MM:SS` format
- Hat indicator with emoji and name
- Mode indicator (`▶ auto` or `⏸ paused`)
- Optional scroll mode `[SCROLL]`
- Optional idle countdown `idle: Ns`

**`ralph-footer`** - Validates Ralph TUI footer:
- Activity indicator (`◉ active`, `◯ idle`, or `■ done`)
- Last event topic display
- Search mode when active

**`ralph-full`** - Complete TUI layout:
- Header section at top (3 lines)
- Terminal content area (variable height)
- Footer section at bottom (3 lines)
- Proper visual hierarchy

**`tui-basic`** - Generic TUI:
- Has visible content (not blank)
- No rendering artifacts
- Proper terminal dimensions

### Semantic Validation Prompt

```
Analyze this terminal UI output and determine if it meets the following criteria:

CRITERIA:
{criteria_description}

TERMINAL OUTPUT:
{captured_text}

Evaluate each criterion and provide:
1. PASS or FAIL for each requirement
2. Brief explanation for any failures
3. Overall verdict: PASS or FAIL

Be lenient on exact formatting but strict on:
- Required content presence
- Logical layout and hierarchy
- No rendering errors or artifacts
```

---

## Codebase Documentation Validation

### Automated Consistency Checks

```bash
# Check for broken internal links
find . -name "*.md" -exec grep -l "\](.*\.md)" {} \;

# Check for missing code references
grep -r "\`\`\`" docs/ | grep -v "lang" | cut -d: -f1 | sort -u

# Check for outdated version references
grep -r "v1\\.0" docs/ --include="*.md"
```

### Completeness Validation

For each documentation file, verify:

| Section | Required | Validation Method |
|---------|----------|-------------------|
| Overview | Yes | LLM: Clear description of purpose? |
| Installation | Yes | Automated: Commands valid? |
| Usage Examples | Yes | LLM: Examples copy-pasteable? |
| API Reference | Conditional | Automated: All endpoints documented? |
| Troubleshooting | Recommended | LLM: Covers common issues? |

### LLM-as-Judge Prompt

```
Analyze this documentation file for quality:

FILE: {filename}

Evaluate:
1. **Clarity**: Is the purpose clear to a new user?
2. **Completeness**: Are all key concepts covered?
3. **Examples**: Are examples provided and copy-pasteable?
4. **Structure**: Is the information logically organized?
5. **Accuracy**: Are technical details correct?

Rate each category 1-5 and provide specific feedback.
```

---

## Diagram Validation

### Mermaid Diagram Checks

```bash
# Find all Mermaid code blocks
grep -r '```mermaid' docs/ --include="*.md" -A 20

# Validate syntax using Mermaid CLI (if available)
mmdc -i diagram.mermaid -o /dev/null
```

### Visual Validation Checklist

- [ ] Diagram renders without syntax errors
- [ ] All nodes are labeled clearly
- [ ] Arrows/connections make logical sense
- [ ] Text is readable at default zoom
- [ ] Color coding (if used) has legend
- [ ] Diagram adds value beyond text description

---

## Common Anti-Patterns

### 1. Missing Context

❌ **Bad:**
```markdown
## Demo

![demo](./demo.gif)
```

✅ **Good:**
```markdown
## Demo

![feature demo](./docs/demos/feature-demo.gif)

*Shows: Email validation catching invalid formats with specific error messages*
```

### 2. Unclear Screenshots

❌ **Bad:**
Terminal screenshot with tiny font, no context, full user path visible.

✅ **Good:**
Terminal screenshot with:
- 100x24 dimensions (readable when scaled)
- Simple `$ ` prompt
- Descriptive comment below
- No sensitive paths

### 3. Outdated Documentation

❌ **Bad:**
Examples from old API version, deprecated commands shown.

✅ **Good:**
Version-specific documentation, migration guides for breaking changes.

---

## Self-Validation Workflow

When creating documentation:

1. **Create** the content
2. **Run automated checks** (file size, syntax, links)
3. **Extract sample** for visual validation
4. **Apply LLM-as-judge** with criteria
5. **Fix issues** found
6. **Re-validate** until PASS

---

## Quick Reference

| Content Type | Automated Checks | Visual Validation | Content Validation |
|--------------|------------------|-------------------|-------------------|
| Terminal demos | File size, duration | Readability, sensitivity | Commands visible |
| TUI output | Syntax parsing | Layout, hierarchy | Components present |
| Code docs | Link checking | Structure, clarity | Accuracy, examples |
| Diagrams | Syntax validation | Rendering quality | Logical correctness |

---

## Tools Reference

| Tool | Purpose | Command |
|------|---------|---------|
| `asciinema` | Record terminal | `asciinema rec demo.cast` |
| `agg` | Cast to GIF | `agg demo.cast demo.gif` |
| `svg-term-cli` | Cast to SVG | `svg-term --in demo.cast --out demo.svg` |
| `freeze` | Terminal screenshot | `freeze --execute "cmd" -o out.svg` |
| `mmdc` | Mermaid validate | `mmdc -i diagram.mermaid` |

---

For Ralph-specific documentation patterns, see `references/prompt-engineering.md`.
