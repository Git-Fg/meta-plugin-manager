---
name: file-search
description: This skill should be used when the user asks to "search large codebase", "analyze long text file", "perform primal exploration", "search with fd/ripgrep/fzf", or needs guidance on modern file search using fd, ripgrep (rg), and fzf for analysis of large files and codebases.
user-invocable: true
---

# File Search

Think of file search as a **hierarchy of tools**—like a surgeon's scalpel (ripgrep) for precision cuts, followed by a metal detector (fd) for discovery, and finally a human hand (fzf) when you need to physically select something.

## The 3-Tier Performance Hierarchy

Follow this hierarchy for maximum speed:

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

**Recognition:** "Do you know what you're searching for?" → Use ripgrep. "Don't know which files?" → Add fd. "Need human selection?" → Use fzf.

## Recognition Patterns

**When to use file-search:**
```
✅ Good: "Search for 'TODO' across the codebase"
✅ Good: "Find all Python files modified recently"
✅ Good: "Analyze a large codebase structure"
❌ Bad: Simple file reads (use Read tool)
❌ Bad: Direct file edits (use Edit tool)

Why good: Modern search tools handle large codebases efficiently with intelligent filtering.
```

**Pattern Match:**
- User mentions "search", "find", "grep", "codebase"
- Need to analyze large files or directories
- Looking for patterns, TODO/FIXME markers
- Need to discover file structure

## Core Workflows

### ripgrep (Priority 1)

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
rg -l "TODO"                 # File names only
rg -c "TODO"                 # Count per file
rg -n "pattern"              # Line numbers
rg --json "pattern"          # Structured output (for AI parsing)
```

### fd Integration (Priority 2)

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

### fzf for Interactive (Priority 3)

**Basic usage:**
```bash
fd | fzf                     # Find and select
```

**With preview:**
```bash
fd | fzf --preview 'bat --color=always {}'
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}'
```

### Combined Workflows

**Find files, search content:**
```bash
fd -e py -x rg "async def" {}     # Search Python files for async def
fd -t f -x rg -l "TODO" {}        # Find files with TODO
```

**Search, select, open:**
```bash
rg -l "pattern" | fzf --preview 'rg -C 3 "pattern" {}' | xargs vim
```

## AI Agent Optimization

**Large Codebases:**
```bash
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
rg --json "pattern"                 # JSON output for structured parsing
```

## Quick Reference

| Task | Best Command |
|------|--------------|
| Content search (most common) | `rg -C 3 "pattern"` |
| Find files with pattern | `rg -l "pattern"` |
| Search by file type | `rg -t py "pattern"` |
| Case-insensitive | `rg -i "pattern"` |
| Files by extension | `fd -e py` |
| Recent files | `fd --changed-within 1d` |
| Interactive selection | `fd \| fzf` |
| AI parsing (JSON) | `rg --json "pattern"` |
| Large codebase | `rg "pattern" --follow -g '!{node_modules,.git}/**/*'` |

## Performance Facts

| Use Case | ripgrep | fd | grep | find |
|----------|---------|----|------|------|
| Content search | 10-100x faster | N/A | Baseline | N/A |
| File by extension | 5-20x faster | Fastest | 1x | 1x |
| .gitignore respect | Automatic | Automatic | No | No |
| Multi-threading | Yes | No | No | No |
| SIMD optimized | Yes (NEON) | Yes | No | No |

**Key advantages:**
- SIMD + multi-threading = 10-100x vs grep
- Smart case: "error" (case-insensitive) vs "Error" (case-sensitive)
- Automatic .gitignore respect (no node_modules noise)
- Binary file detection (no binary garbage)

**Recognition:** "Do you need maximum performance on large codebases?" → Use ripgrep with proper flags.

**For detailed command reference:**
- `references/advanced-workflows.md` - Complex workflows and Git integration
- `references/performance-tuning.md` - Platform-specific optimizations
- `references/shell-functions.md` - Reusable shell functions
