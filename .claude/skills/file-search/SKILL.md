---
name: file-search
description: This skill should be used when the user asks to "search large codebase", "analyze long text file", "perform primal exploration", "search with fd/ripgrep/fzf", or needs guidance on modern file search using fd, ripgrep (rg), and fzf for analysis of large files and codebases.
user-invocable: true
---
# File Search

Modern file and content search using fd, ripgrep (rg), and fzf.

**Assumes fd, ripgrep (rg), fzf, and bat are installed.**

## The 3-Tier Performance Hierarchy

For maximum speed and efficiency, follow this hierarchy:

1. **Tier 1: ripgrep** (Primary - 90% of tasks)
   - Use when: You know what you're searching for
   - Fastest for: Content search, pattern matching, code analysis
   - Advantages: SIMD optimized, multi-threaded, .gitignore aware

2. **Tier 2: fd** (Secondary - 8% of tasks)
   - Use when: You don't know which files contain the content
   - Fastest for: File discovery, extension filtering, recent changes
   - Advantages: Simple syntax, colorized output, intuitive

3. **Tier 3: fzf** (Tertiary - 2% of tasks)
   - Use when: Interactive exploration needed, human input required
   - Fastest for: Manual navigation, preview selection
   - Advantages: Fuzzy matching, preview windows, multi-select

**Rule of Thumb:** Always try ripgrep first. If it doesn't solve the problem, add fd. Only use fzf when human interaction is essential.

## ripgrep Mastery (Priority 1)

**Simple search:**
```bash
rg "TODO"                    # Find TODO
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
rg -l "TODO"                 # File names only (files-with-matches)
rg -c "TODO"                 # Count per file
rg -n "pattern"              # Line numbers
rg --no-heading "pattern"     # No filename headers (for parsing)
rg --json "pattern"          # Structured output (for AI parsing)
```

**Multi-pattern search:**
```bash
rg -e "TODO" -e "FIXME" -e "HACK"    # Multiple patterns
rg "(TODO|FIXME|HACK)"              # Regex alternation
```

**Case sensitivity (smart):**
```bash
rg "error"                  # Case-insensitive (lowercase)
rg "Error"                  # Case-sensitive (mixed case)
rg -i "ERROR"               # Force case-insensitive
rg -s "Error"               # Force case-sensitive
```

**Advanced filtering:**
```bash
rg "pattern" --follow       # Follow symlinks
rg "pattern" --hidden       # Include hidden files
rg "pattern" -g '!*.min.js' # Exclude pattern
rg "pattern" -g '*.{py,js}' # Include specific patterns
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

**Exclude patterns:**
```bash
fd -E node_modules           # Exclude directory
fd -E "*.min.js"             # Exclude pattern
fd --ignore-file .gitignore  # Use .gitignore
```

**Execute command on results:**
```bash
fd -e py -x wc -l            # Line count per Python file
fd -t f -x chmod 644 {}      # Set permissions
fd -e py -x rg "TODO" {}     # Search within found files
```

**Time-based filters:**
```bash
fd --changed-within 1d       # Modified in last day
fd --changed-before 2024-01-01  # Modified before date
fd --size +10M               # Files larger than 10MB
```

## fzf for Interactive (Priority 3)

**Basic usage:**
```bash
fd | fzf                     # Find and select
```

**With preview:**
```bash
fd | fzf --preview 'bat --color=always {}'
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}'
```

**Multi-select:**
```bash
fd -e ts | fzf -m | xargs code    # Open multiple files
```

## Combined Workflows (Priority 1)

**Find files, search content:**
```bash
fd -e py -x rg "async def" {}     # Search Python files for async def
fd -t f -x rg -l "TODO" {}        # Find files with TODO
```

**Search, select, open:**
```bash
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}' | xargs vim
```

**Interactive directory navigation:**
```bash
fd -t d | fzf | cd               # Select and change directory
```

**Parallel processing:**
```bash
find . -type f -name "*.py" | xargs -P 8 rg "pattern"
fd -t f -e py -x rg -l "pattern"  # Execute in parallel
```

## AI Agent Optimization (Priority 1)

For AI agents working with codebases and large text files:

**Large Codebases:**
```bash
# Cache frequently accessed paths
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'

# Smart scoping (respects .gitignore automatically)
rg "pattern" --follow --hidden -g '!{.git,node_modules,dist}/**/*'

# Parallel processing for very large searches
find . -type f -name "*.py" | xargs -P 8 rg "pattern"
```

**Long Text Files:**
```bash
# Find large files first
fd -t f -x du -h {} | sort -hr | head -20

# Extract specific line ranges
rg -n "pattern" | head -50          # First 50 matches
rg -n "pattern" | tail -50         # Last 50 matches

# JSON output for structured parsing
rg --json "pattern"
```

**Structured Output for AI Parsing:**
```bash
# Machine-readable output
rg --json "pattern"                 # Complete JSON structure
rg --no-heading "pattern"           # No filename headers
rg -n "pattern"                     # Line numbers only
rg -c "TODO" --json                 # Count per file in JSON
```

**MacBook Pro M1 Optimization:**
```bash
# Verify ARM64 SIMD support
rg --version | grep NEON

# Native performance (multi-threaded by default)
rg --threads auto "pattern"
```

## Quick Reference

| Task                          | Best Command |
|------------------------------|-----------------------------------|
| Content search (most common)  | rg -C 3 "pattern" |
| Find files with pattern       | rg -l "pattern" |
| Search by file type          | rg -t py "pattern" |
| Case-insensitive             | rg -i "pattern" |
| Literal string (faster)      | rg -F "exact phrase" |
| Multi-pattern               | rg -e "TODO" -e "FIXME" |
| Files by extension           | fd -e py |
| Recent files                | fd --changed-within 1d |
| Interactive selection        | fd \| fzf |
| With preview               | fd \| fzf --preview 'bat {}' |
| AI parsing (JSON)          | rg --json "pattern" |
| Large codebase             | rg "pattern" --follow -g '!{node_modules,.git}/**/*' |

## Performance Facts (2025 Benchmarks)

| Use Case | ripgrep | fd | grep | find |
|----------|---------|----|------|------|
| Content search | 10-100x faster | N/A | Baseline | N/A |
| File by extension | 5-20x faster | Fastest | 1x | 1x |
| .gitignore respect | Automatic | Automatic | No | No |
| Binary file skip | Automatic | No | No | No |
| Multi-threading | Yes | No | No | No |
| SIMD optimized | Yes (NEON) | Yes | No | No |

### Verified Performance Characteristics
- **ripgrep:** SIMD + multi-threading = 10-100x vs grep
- **Smart case:** "error" (case-insensitive) vs "Error" (case-sensitive)
- **Automatic .gitignore respect** (no node_modules noise)
- **Binary file detection** (no binary garbage)
- **Structured output** (--json, --no-heading) for AI parsing

## Advanced Patterns

For complex workflows, Git integration, and shell functions, see:
- [references/advanced-workflows.md](references/advanced-workflows.md)
