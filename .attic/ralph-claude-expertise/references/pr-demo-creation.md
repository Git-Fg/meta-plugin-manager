# PR Demo Creation

Create terminal recordings for pull requests using asciinema.

## Tool Chain

| Goal | Tools | Output |
|------|-------|--------|
| CLI demo for GitHub | asciinema → agg | GIF (< 5MB) |
| Smaller file | asciinema → svg-term-cli | SVG (< 500KB) |
| TUI screenshot | tmux → freeze | SVG/PNG |

## Prerequisites

```bash
# macOS
brew install asciinema
cargo install --git https://github.com/asciinema/agg
npm install -g svg-term-cli  # Optional for SVG
```

## Workflow

### 1. Script First (Required)

```markdown
## Demo: [feature name]
Duration: ~20-30 seconds

1. [0-3s] Show command being typed
2. [3-10s] Command executes, show key output
3. [10-25s] Highlight the "aha moment"
4. [25-30s] Clean exit
```

**Keep it short.** 20-30 seconds max. Show ONE thing well.

### 2. Prepare Environment

```bash
clear
export PS1='$ '              # Simple prompt
export TERM=xterm-256color   # Consistent colors
# Terminal size: 100x24
```

### 3. Record

```bash
asciinema rec demo.cast --cols 100 --rows 24

# Execute your script
# Press Ctrl+D when done
```

### 4. Convert to GIF

```bash
# Basic conversion
agg demo.cast demo.gif

# With speed adjustment (1.5x faster)
agg --speed 1.5 demo.cast demo.gif

# With custom font size
agg --font-size 14 demo.cast demo.gif
```

### 5. Embed in PR

```markdown
## Demo

![feature demo](./docs/demos/feature-demo.gif)

*Shows: [one-sentence description]*
```

## Quick Reference

| Setting | Recommended |
|---------|-------------|
| Duration | 20-30 seconds |
| Terminal size | 100x24 |
| Speed multiplier | 1.0-1.5x |
| File size | < 2MB ideal, < 5MB max |
| Font size (agg) | 14-16 |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Demo too long | Script it first, show ONE thing |
| Text unreadable | Use --font-size 14+, terminal 100x24 |
| File too large | Use svg-term-cli or increase speed |
| Cluttered terminal | Clean PS1, clear history |
| No context in PR | Add description below GIF |

## File Organization

```
docs/demos/
├── feature-name.gif      # The demo
├── feature-name.cast     # Source recording
└── README.md             # Recording instructions
```
