---
name: agent-browser
description: "Automate browser interactions when you need to execute JavaScript, submit forms, or test visual workflows. Not for static HTML scraping or simple API calls."
user-invocable: true
---

# Browser Automation

Browser automation for JavaScript-rendered content, form interactions, visual testing, and multi-step workflows.

## When to Use

**Use agent-browser when:**

- Content requires JavaScript execution
- Form submission and validation needed
- Visual verification required
- Multi-step workflows with state

**Use fetch tools when:**

- Static content retrieval
- API calls
- Documentation gathering

## Core Workflow

**Pattern:** open → snapshot -i → interact with @refs → re-snapshot

```bash
agent-browser open <url>          # Navigate to page
agent-browser snapshot -i         # Get interactive elements with refs
agent-browser click @e1           # Click element by ref
agent-browser fill @e2 "text"     # Fill input by ref
agent-browser close               # Close browser
```

**Remember:** Re-snapshot after navigation or significant DOM changes to get updated refs.

## Essential Commands

### Navigation & Discovery

```bash
agent-browser open <url>           # Navigate to URL
agent-browser snapshot -i          # Get interactive elements (recommended)
agent-browser close                # Close browser
```

### Core Interactions

```bash
agent-browser click @e1            # Click element
agent-browser fill @e2 "text"      # Fill input
agent-browser wait @e1             # Wait for element
agent-browser screenshot path.png  # Capture screenshot
```

### State Management

```bash
agent-browser state save auth.json     # Save session state
agent-browser state load auth.json     # Load session state
agent-browser record start demo.webm   # Record session
agent-browser record stop              # Stop recording
```

## Examples

### Form Submission

```bash
agent-browser open https://example.com/form
agent-browser snapshot -i
# Output: refs like @e1, @e2 for interactive elements

agent-browser fill @e1 "user@example.com"
agent-browser click @e2
agent-browser wait --load networkidle
agent-browser screenshot success.png
```

### Authentication with Saved State

**Initial login and save:**

```bash
agent-browser open https://app.example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "username"
agent-browser fill @e2 "password"
agent-browser click @e3
agent-browser wait --url "**/dashboard"
agent-browser state save auth.json
```

**Subsequent sessions:**

```bash
agent-browser state load auth.json
agent-browser open https://app.example.com/dashboard
```

**Recognition test:** Need to avoid re-authenticating? Use `state save` after login.

## Quick Reference

**Happy Path:** open → snapshot -i → interact with @refs → re-snapshot

**Debugging:**

- Add `--headed` flag to see browser
- Use `console` command to check errors
- Use `record start/stop` for visual debugging

**State Management:**

- Save/load sessions to avoid re-authentication
- Record sessions for later review

---

<critical_constraint>
MANDATORY: Take snapshot before interaction to enable diff comparison
MANDATORY: Use isolated CDP endpoint for clean browser state
MANDATORY: Save session to avoid re-authentication on restart
MANDATORY: Verify actions through snapshot comparison
No exceptions. Browser automation requires state tracking for verification.
</critical_constraint>
