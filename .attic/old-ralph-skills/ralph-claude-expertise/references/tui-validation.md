# TUI Validation

Validate Terminal User Interface output using screenshots and LLM-as-judge.

## Overview

Validate TUI applications by:
1. Capturing terminal output with `freeze`
2. Using LLM-as-judge for semantic validation
3. Checking layout, content, and visual hierarchy

## Prerequisites

```bash
# Install freeze (Charmbracelet)
brew install charmbracelet/tap/freeze

# Optional: tmux for live capture
brew install tmux
```

## Capture Methods

### From File
```bash
freeze output.txt -o capture.svg
```

### From Command
```bash
freeze --execute "cargo run --example demo" -o capture.svg
```

### From tmux Session
```bash
tmux capture-pane -pet session-name | freeze -o capture.svg
```

## Built-in Criteria

### ralph-header
Validates Ralph TUI header:
- Iteration counter `[iter N]` or `[iter N/M]`
- Elapsed time `MM:SS`
- Hat indicator with emoji and name
- Mode indicator `▶ auto` or `⏸ paused`
- Optional scroll mode `[SCROLL]`
- Optional idle countdown `idle: Ns`

### ralph-footer
Validates Ralph TUI footer:
- Activity indicator `◉ active`, `◯ idle`, or `■ done`
- Last event topic display
- Search mode when active

### ralph-full
Validates complete layout:
- Header section (3 lines)
- Terminal content area
- Footer section (3 lines)
- Proper visual hierarchy

### tui-basic
Generic validation:
- Has visible content
- No rendering artifacts
- Proper terminal dimensions

## Validation Modes

| Mode | Description |
|------|-------------|
| `semantic` | LLM judges meaning and layout |
| `strict` | Also checks exact content presence |
| `visual` | Requires PNG, checks appearance |

## LLM-as-Judge Prompt

```
Analyze this terminal UI output:

CRITERIA:
{criteria_description}

TERMINAL OUTPUT:
{captured_text}

Evaluate:
1. PASS or FAIL for each requirement
2. Brief explanation for failures
3. Overall verdict

Be lenient on formatting, strict on:
- Required content presence
- Logical layout
- No rendering errors
```

## Self-Validation

```bash
# Check file size (< 5MB for GitHub)
ls -lh capture.gif

# Extract frame for analysis
svg-term --in demo.cast --out preview.svg --at 15000

# Check for sensitive data
grep -iE '(api.?key|password|/Users/)' demo.cast
```

## Troubleshooting

### Text Unreadable
- Use `--font-size 14+`
- Set terminal to 100x24

### File Too Large
- Use SVG instead of GIF
- Increase capture speed
- Reduce terminal dimensions

### Rendering Artifacts
- Check TERM environment variable
- Use `--theme base16` for consistency
