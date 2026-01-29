# Advanced Workflows

## Navigation

| If you need...                         | Read...                                 |
| :------------------------------------- | :-------------------------------------- |
| AI agent structured output             | ## PATTERN: Structured Output           |
| Large repository navigation            | ## PATTERN: Large Repository Navigation |
| Cross-reference analysis               | ## PATTERN: Cross-Reference Analysis    |
| Performance-optimized batch processing | ## PATTERN: Batch Processing            |
| Git integration patterns               | ## PATTERN: Git Integration             |
| Shell functions                        | ## PATTERN: Shell Functions             |
| Project-specific patterns              | ## PATTERN: Project-Specific            |
| Performance optimization facts         | ## REFERENCE: Performance Facts         |

## Critical Read

<critical_read>
FIRST: Scan the navigation table above for your workflow type.
KEY PATTERN: Advanced combinations of ripgrep, fd, and fzf for specialized use cases.
COMMON MISTAKE: Forgetting JSON output when parsing programmatically—use --json flag.
REMEMBER: This reference contains the full source truth—read it, don't rely on summaries elsewhere.
</critical_read>

## PATTERN: Structured Output

JSON output for AI agent processing:

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

## PATTERN: Large Repository Navigation

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

## PATTERN: Cross-Reference Analysis

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

## PATTERN: Batch Processing

```bash
export OMP_NUM_THREADS=8
find . -type f -name "*.py" | xargs -P 8 rg -l "pattern"
rg --threads auto "pattern" --json
find . -type f -newermt "2024-01-01" -name "*.js" | xargs rg "TODO"
```

## PATTERN: Git Integration

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

## PATTERN: Shell Functions

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Interactive file search with preview
fif() {
  fd -t f | fzf --preview 'bat --color=always {}'
}

# Search and edit
se() {
  local file=$(rg -l "$1" | fzf --preview "rg -C 3 \"$1\" {}")
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# Find and cd
cdl() {
  local dir=$(fd -t d | fzf)
  [ -n "$dir" ] && cd "$dir"
}
```

## PATTERN: Project-Specific

**Monorepo navigation:**

```bash
# Find packages
fd -t d -p "package" | fzf

# Search specific package
fd -t d -p "package" | fzf | xargs -I {} rg "pattern" {}
```

**Test file matching:**

```bash
# Find test for source file
fd "app.js" | xargs -I {} fd "{}.test.js"
```

## REFERENCE: Performance Facts

**2025-2026 Performance Facts:**

- **ripgrep:** Uses ARM64 NEON SIMD instructions on Apple Silicon
- **Multi-threading:** Automatically detects core count (auto or --threads)
- **Smart filtering:** Respects .gitignore, skips binary files automatically
- **Case sensitivity:** Lowercase = case-insensitive (optimization)
- **Regex compilation:** Literal strings (-F) avoid regex overhead

**Parallel execution:**

```bash
fd -t f | xargs -P 8 -I {} rg "pattern" {}
rg --threads auto "pattern"
```

**Cache expensive searches:**

```bash
fd -t f > /tmp/filelist.txt
rg "pattern" -f /tmp/filelist.txt
export FZF_DEFAULT_COMMAND='fd --type file --hidden'
```

**MacBook Pro M1 Specific:**

```bash
rg --version | grep -i neon
rg --threads auto "pattern"
sysctl -n machdep.cpu.brand_string
```

## REFERENCE: Benchmark Results

```bash
time rg "TODO" .
time grep -r "TODO" .
time rg -t py "pattern"
time fd -e py "pattern"
time rg "error" .
time rg "Error" .
```

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Use JSON output (--json) when parsing programmatically—text format varies.
MANDATORY: Respect .gitignore and binary file detection—forced searches waste time.
FORBIDDEN: Summary sections—create spoilers that let agents skip reading the actual content.
</critical_constraint>
