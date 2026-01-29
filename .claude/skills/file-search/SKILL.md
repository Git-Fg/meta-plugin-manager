---
name: file-search
description: "Search files and content in a codebase using ripgrep, fd, and fzf. Use when investigating codebases, finding patterns, locating specific files, or exploring project structure. Includes content search, file globbing, interactive selection, and multi-pattern matching. Not for reading file content, editing files, or simple directory listing."
user-invocable: true
---

# File Search

<mission_control>
<objective>Provide high-performance file search using ripgrep (content), fd (files), and fzf (interactive)</objective>
<success_criteria>Correct tool for each task: ripgrep for 90% content search, fd for 8% file discovery, fzf for 2% interactive</success_criteria>
</mission_control>

<guiding_principles>

## The Path to High-Speed Codebase Discovery

### 1. Tool Selection Predicts Success (90-8-2 Rule)

**Why:** Starting with the right tool prevents wasted iterations and context switches.

ripgrep handles 90% of search tasks—content search, pattern matching, code analysis. fd covers 8%—file discovery, extension filtering, time-based queries. fzf addresses the remaining 2%—interactive exploration requiring human judgment.

When you select ripgrep first for content questions, fd first for file questions, and reach for fzf only when interaction is essential, you complete searches 3-5x faster than tool-hopping.

### 2. Fast Tools Enable Deep Exploration

**Why:** Performance matters when searching large codebases repeatedly.

ripgrep's SIMD optimization and multi-threading make it 10-100x faster than grep. fd's simple syntax and .gitignore awareness make file discovery 5-20x faster than find. This speed enables exploring multiple search angles without waiting.

When you use these tools, you can iterate rapidly—testing 3-4 search patterns in the time it takes grep to complete one.

### 3. Structured Output Supports AI Processing

**Why:** AI agents need predictable, parseable output for multi-step workflows.

JSON output (`--json`) provides structured data for programmatic processing. Line numbers (`-n`) enable precise navigation. File lists (`-l`) support batch operations. Count mode (`-c`) generates metrics.

When you use structured output modes, you enable complex workflows like cross-reference analysis, dependency tracking, and batch processing.

### 4. Progressive Refinement Handles Unknowns

**Why:** Initial searches often miss the right terminology or scope.

Start broad with case-insensitive search (`-i`), then refine with specific patterns. Use file type filters (`-t py`) to scope results. Add context (`-C 3`) to understand matches. When simple search insufficient, iterative-retrieval provides 4-phase progressive refinement.

When you refine iteratively, you discover patterns that single-shot searches miss—especially with unknown terminology or vague requirements.

</guiding_principles>

## Quick Start

**Content search:** `Grep` → Pattern matching with context

**File discovery:** `Glob` → Find by name/extension pattern

**Interactive select:** fzf → When human choice is essential (rare)

**Why:** ripgrep covers 90% of searches, fd for 8%, fzf only 2%—start with Grep, add tools only when needed.

## Operational Patterns

This skill follows these behavioral patterns:

- **Discovery**: Locate files matching patterns using search tools
- **Content Search**: Search file contents for pattern matching
- **Tracking**: Maintain a visible task list for search iterations

Use native tools to fulfill these patterns. The System Prompt selects the correct implementation for semantic directives like "Locate files matching patterns" or "Search file contents."

## Navigation

| If you need...           | Read...                                    |
| :----------------------- | :----------------------------------------- |
| Content search           | ## Tool Selection                          |
| File discovery           | ## Tool Selection                          |
| Interactive selection    | ## Tool Selection → fzf                    |
| AI agent workflows       | ## AI Agent Workflows                      |
| Git integration          | ## Git Integration                         |
| Advanced search patterns | `references/pattern_advanced-workflows.md` |

## Implementation Patterns

**Find specific pattern**:

```bash
# Basic content search
rg "TODO"

# With context (3 lines before/after)
rg -C 3 "function_name"

# Case-insensitive
rg -i "error"

# Literal string (faster, no regex)
rg -F "exact phrase"

# File names only
rg -l "pattern"

# JSON output for AI parsing
rg --json "pattern"
```

**Explore directory structure**:

```bash
# Find files by name
fd config

# By extension
fd -e py
fd -e js -e ts

# By type
fd -t f          # Files only
fd -t d          # Directories only

# Time-based
fd --changed-within 1d     # Modified today
fd --changed-before 2024-01-01
```

**Combined search (find files then search within)**:

```bash
# Find Python files containing async def
fd -e py -x rg "async def" {}

# Find files with TODO
fd -t f -x rg -l "TODO" {}

# Interactive selection with preview
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}'
```

---

## workflows

### Find Specific Pattern

`Grep`: Search for pattern in codebase

### Explore Directory Structure

`Glob`: Find files by pattern

### Combined Search

`Glob + Grep`: Find files then search within

### Interactive Selection

`Glob + Grep + fzf`: Find files, search within, select interactively

---

## Troubleshooting

**Issue**: No results found

- **Symptom**: Empty search results
- **Solution**: Try case-insensitive (`-i`), check spelling, verify file types (`-t py`)

**Issue**: Too many results

- **Symptom**: >50 matches
- **Solution**: Add context (`-C 3`), limit file types (`-t py`), add `--max-count 20`

**Issue**: Hidden files not found

- **Symptom**: Files starting with `.` missing
- **Solution**: Add `--hidden` flag to ripgrep, `-H` to fd

**Issue**: Large codebase slow

- **Symptom**: Search takes >10 seconds
- **Solution**: Use `--follow --hidden -g '!{.git,node_modules,dist}/**/*'` to skip ignored dirs

**Issue**: Unknown terminology

- **Symptom**: Can't find what you're looking for
- **Solution**: Use **iterative-retrieval** skill for 4-phase progressive refinement

## Tool Selection

**ripgrep** (Primary - 90% of tasks)

Content search, pattern matching, code analysis. SIMD optimized, multi-threaded, .gitignore aware. Recognition: "Know what content to find?" → Use ripgrep.

**fd** (Secondary - 8% of tasks)

File discovery, extension filtering, recent changes. Simple syntax, colorized output, intuitive. Recognition: "Need to find files, not content?" → Use fd.

**fzf** (Tertiary - 2% of tasks)

Interactive exploration, manual navigation, preview selection. Fuzzy matching, preview windows, multi-select. Recognition: "Need human selection from results?" → Use fzf.

**Decision flow:** ripgrep first → add fd if needed → fzf only when interaction is essential.

## ripgrep (Priority 1)

```bash
rg "TODO"                    # Simple search
rg -i "error"                # Case-insensitive
rg -F "exact phrase"         # Literal string (faster, no regex)
```

**By file type:**

```bash
rg -t py "import"            # Python files only
rg -t js -t ts "async"       # JS and TS
rg -t md "ripgrep"           # Markdown files
```

**Context control:**

```bash
rg -C 3 "function"           # 3 lines before/after
rg -B 5 "class"              # 5 lines before
rg -A 2 "return"             # 2 lines after
```

**Output modes:**

```bash
rg -l "TODO"                 # File names only
rg -c "TODO"                 # Count per file
rg -n "pattern"              # Line numbers
rg --json "pattern"          # Structured output (for AI parsing)
```

## fd Integration (Priority 2)

**Find by name:**

```bash
fd config                    # Files containing "config"
fd -e py                     # Python files
fd "test.*\.js$"            # Regex pattern
```

**By type:**

```bash
fd -t f config               # Files only
fd -t d src                  # Directories only
fd -t l                      # Symlinks only
```

**Time-based filters:**

```bash
fd --changed-within 1d       # Modified in last day
fd --changed-before 2024-01-01  # Modified before date
fd --size +10M               # Files larger than 10MB
```

## fzf (Priority 3)

```bash
fd | fzf                     # Find and select
fd | fzf --preview 'bat --color=always {}'
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}'
```

## Combined Workflows

```bash
fd -e py -x rg "async def" {}     # Search Python files for async def
fd -t f -x rg -l "TODO" {}        # Find files with TODO
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}' | xargs vim
```

## AI Agent Workflows

Structured output patterns for AI agent processing:

```bash
# JSON for programmatic processing
rg --json "pattern" | jq '.data.lines[].text'

# Line numbers without headers
rg -n --no-heading "pattern"

# Count per file (for metrics)
rg -c "TODO" --json

# Complete JSON structure with metadata
rg --json "pattern"
```

### Large Repository Navigation

```bash
# Use Glob tool for file discovery
Glob: Find all files matching pattern

# Use Grep tool for content search
Grep: Search for "pattern" in matched files

# Find recently modified with content
Glob: Find files changed within 1 day → Grep for "TODO"

# Scan by file size (avoid huge files)
Glob: Find files → Grep for "pattern" (Grep skips binary files automatically)
```

### Cross-Reference Analysis

```bash
# Find classes and their usages
rg "class \w+" --json | jq '.data.lines[].text'
rg "ClassName" -n

# Import dependency analysis
rg "from \w+ import" -n | sort | uniq

# Function definitions and calls
rg "def \w+" -n | head -20
rg "functionName\(" -n
```

### Performance-Optimized Batch Processing

```bash
export OMP_NUM_THREADS=8
find . -type f -name "*.py" | xargs -P 8 rg -l "pattern"
rg --threads auto "pattern" --json
find . -type f -newermt "2024-01-01" -name "*.js" | xargs rg "TODO"
```

## Git Integration

**Search in tracked files only:**

```bash
rg "pattern" --glob '!{.git,node_modules}'
```

**Find modified files:**

```bash
fd -t f -x git status -s {} | rg "^ M"
```

**Search Git history:**

```bash
git log -S "pattern" --oneline    # Find when pattern was added
git log -p --all -S "function"    # Full diff with changes
```

## Large Codebase Optimization

```bash
# Smart scoping (respects .gitignore automatically)
rg "pattern" --follow --hidden -g '!{.git,node_modules,dist}/**/*'

# Parallel processing
find . -type f -name "*.py" | xargs -P 8 rg "pattern"

# Find large files first
fd -t f -x du -h {} | sort -hr | head -20

# Extract specific line ranges
rg -n "pattern" | head -50          # First 50 matches
rg --json "pattern"                 # JSON output for structured parsing
```

## Quick Reference

| Task                    | Command                                                |
| ----------------------- | ------------------------------------------------------ |
| Content search          | `rg -C 3 "pattern"`                                    |
| Find files with pattern | `rg -l "pattern"`                                      |
| Search by file type     | `rg -t py "pattern"`                                   |
| Case-insensitive        | `rg -i "pattern"`                                      |
| Files by extension      | `fd -e py`                                             |
| Recent files            | `fd --changed-within 1d`                               |
| Interactive selection   | `fd \| fzf`                                            |
| JSON output             | `rg --json "pattern"`                                  |
| Large codebase          | `rg "pattern" --follow -g '!{node_modules,.git}/**/*'` |

## Performance

| Use Case           | ripgrep        | fd        | grep     | find |
| ------------------ | -------------- | --------- | -------- | ---- |
| Content search     | 10-100x faster | N/A       | Baseline | N/A  |
| File by extension  | 5-20x faster   | Fastest   | 1x       | 1x   |
| .gitignore respect | Automatic      | Automatic | No       | No   |
| Multi-threading    | Yes            | No        | No       | No   |
| SIMD optimized     | Yes (NEON)     | Yes       | No       | No   |

**Recognition:** "Need maximum performance on large codebases?" → Use ripgrep with proper flags.

## For Complex Searches

When simple search is insufficient (unknown terminology, too many/too few results), use **iterative-retrieval**:

```
# Basic search (this skill)
rg "authentication"

# Iterative retrieval with progressive refinement
/search "authentication patterns"
```

**iterative-retrieval** provides:

- **4-phase loop**: DISPATCH → EVALUATE → REFINE → LOOP
- **Relevance scoring**: 0-1 score for each file
- **Progressive refinement**: Search query evolves based on results
- **Termination conditions**: Max 3 iterations, 3+ high-relevance files found

**When to use:**

- Initial search returns >20 files (too many)
- Initial search returns <3 files (too few)
- Domain-specific terminology is unknown
- Context gap is unclear

For simple searches: Use this skill (file-search) directly.
For complex searches: Use iterative-retrieval (uses file-search as initial dispatch).

---

<critical_constraint>
Portability invariant: This skill must work in zero .claude/rules environments.
</critical_constraint>

---
