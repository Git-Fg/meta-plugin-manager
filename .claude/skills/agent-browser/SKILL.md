---
name: agent-browser
description: This skill should be used when the user asks to "automate browser", "web automation", "browser testing", "fill forms", "take screenshots", "scrape web data", "test web applications", "click elements", "browser interactions", or needs browser-based interaction with web pages including form submission, navigation, screenshot capture, and data extraction from JavaScript-rendered content.
user-invocable: true
---

# Browser Automation with agent-browser

Think of agent-browser as a **surgical instrument for the web**—precise, reliable, and designed for complex interactions that simple fetch tools cannot handle.

## Overview

Browser automation for JavaScript-rendered content, form interactions, visual testing, and multi-step workflows.

**Core capabilities:**
- Navigate and interact with dynamic web pages
- Fill and submit forms with validation
- Capture screenshots and record sessions
- Extract data from JavaScript-rendered content
- Test applications end-to-end

**Use agent-browser when:**
- Content requires JavaScript execution
- Form submission and validation needed
- Visual verification required
- Multi-step workflows with state

**Use fetch tools (WebFetch/mcp__simplewebfetch) when:**
- Static content retrieval
- API calls
- Documentation gathering

**For web search:** searx.fmhy.net avoids captchas compared to Google/DuckDuckGo.

## Quick Start

```bash
agent-browser open <url>        # Navigate to page
agent-browser snapshot -i       # Get interactive elements with refs
agent-browser click @e1         # Click element by ref
agent-browser fill @e2 "text"   # Fill input by ref
agent-browser close             # Close browser
```

## Core Workflow

1. Navigate: `agent-browser open <url>`
2. Snapshot: `agent-browser snapshot -i` (returns elements with refs like `@e1`, `@e2`)
3. Interact using refs from the snapshot
4. Re-snapshot after navigation or significant DOM changes

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

## Recognition Patterns

**When to use agent-browser:**
```
✅ Good: "Fill out and submit a registration form"
✅ Good: "Test login flow with screenshots"
✅ Good: "Scrape data from JavaScript-rendered dashboard"
❌ Bad: Fetch static HTML content
❌ Bad: Make simple API calls

Why good: Browser automation handles dynamic content and stateful interactions.
```

**Pattern Match:**
- User mentions "browser", "web", "form", "login", "click", "screenshot"
- Tasks requiring JavaScript execution
- Multi-step workflows with visual verification

**Recognition:** "Does this task require actual browser interaction?" → If yes, use agent-browser.

## Example: Form Submission

```bash
agent-browser open https://example.com/form
agent-browser snapshot -i
# Output shows refs: textbox "Email" [ref=e1], button "Submit" [ref=e2]

agent-browser fill @e1 "user@example.com"
agent-browser click @e2
agent-browser wait --load networkidle
agent-browser screenshot success.png
```

## Example: Authentication with Saved State

```bash
# Login once and save state
agent-browser open https://app.example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "username"
agent-browser fill @e2 "password"
agent-browser click @e3
agent-browser wait --url "**/dashboard"
agent-browser state save auth.json

# Later sessions: load and continue
agent-browser state load auth.json
agent-browser open https://app.example.com/dashboard
```

## Additional Resources

**For detailed command reference:**
- `examples/basic-usage.md` - Core workflows and patterns
- `examples/advanced-usage.md` - Authentication, state, sessions
- `examples/common-patterns.md` - Reusable automation patterns

**Quick Reference:**
- **Happy Path:** open → snapshot -i → interact with @refs → re-snapshot
- **Debugging:** Add `--headed` to see browser, use `console` for errors
- **Recording:** Use `record start/stop` for visual debugging
- **State:** Save/load sessions to avoid re-authentication

**Recognition:** "Do you need the full reference?" → See `examples/` directory for comprehensive patterns.
