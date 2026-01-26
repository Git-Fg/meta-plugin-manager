# Advanced Workflows

Complex patterns combining fd, ripgrep (rg), and fzf for power users and AI agents.

## AI Agent Workflows

### Structured Output for Parsing

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
# Cache file list for repeated searches
fd -t f > /tmp/filelist.txt
rg -f /tmp/filelist.txt "pattern"

# Find recently modified with content
fd --changed-within 1d -t f -x rg -l "TODO"

# Scan by file size (avoid huge files)
fd -t f -x 'du -h {}' | awk '$1 ~ /^[0-9]+K/ {print $2}' | xargs rg "pattern"
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

### Emerging Alternatives

**ugrep** - Modern C++ search with extended features:
```bash
ug -r "pattern" --json
ug -t py "pattern"
```

Note: ugrep still emerging; ripgrep remains standard for 2025-2026.

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

## Shell Functions

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

## Power Workflows

**Find large files:**
```bash
fd -t f -x du -h {} | sort -h | rg "\d{3}M|\dG"
```

**Search and replace (dry-run):**
```bash
rg "old" --files-with-matches | xargs sed -i.bak 's/old/new/g'
```

**Find recently modified files:**
```bash
fd -t f -x stat -f "%Sm %N" -t "%Y-%m-%d" {} | sort -r | head -20
```

**Search multiple patterns:**
```bash
rg -e "TODO" -e "FIXME" -e "HACK"
```

## Project-Specific Patterns

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

## Environment-Specific

**Tmux integration:**
```bash
tmux list-sessions | fzf | xargs tmux switch-client -t
tmux list-windows | fzf | xargs tmux select-window -t
```

**Process management:**
```bash
ps aux | fzf | awk '{print $2}' | xargs kill
```

## Performance Optimization

**2025 Performance Facts:**

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

**Benchmark Results:**
```bash
time rg "TODO" .
time grep -r "TODO" .
time rg -t py "pattern"
time fd -e py "pattern"
time rg "error" .
time rg "Error" .
```

## Output Formatting

**JSON output:**
```bash
rg "pattern" --json | jq -r '.data.lines.text'
rg "pattern" --color=always > results.txt
rg "pattern" -C 2 --html > report.html
```
