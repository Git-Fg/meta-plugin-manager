---
name: agent-browser
description: "Automate browser interactions including navigation, element interaction, and visual workflow testing. Use when executing JavaScript, submitting forms, testing visual workflows, or scraping dynamic content. Includes element location, form handling, JavaScript execution, and visual validation. Not for static HTML scraping, simple API calls, or non-browser automation."
user-invocable: true
---

<mission_control>
<objective>Automate browser interactions including navigation, element interaction, and visual workflow testing.</objective>
<success_criteria>Browser opened, actions performed, results captured, browser closed properly</success_criteria>
</mission_control>

## The Path to Reliable Browser Automation Success

1. **Structured Workflow Enables Verification**: Following the open → snapshot → interact → re-snapshot → close sequence ensures every browser action is verifiable through state comparison. This approach catches issues early because you can compare before/after states systematically.

2. **Headless Mode Provides Reliability**: Running browsers headless by default eliminates visual dependencies and ensures automation works consistently across environments—servers, CI/CD pipelines, and background processes all benefit from browser automation that doesn't require a display.

3. **Element References Create Stability**: Using snapshot-generated refs (`@e1`, `@e2`) instead of CSS selectors creates automation that survives page redesigns. The snapshot command finds elements by their semantic role, so your interactions remain stable even when class names or IDs change.

4. **State Persistence Saves Time**: Saving browser state to files (`state save auth.json`) eliminates repetitive authentication flows. This enables faster iteration during development and more reliable testing by reusing authenticated sessions instead of re-login for every test run.

5. **Screenshots Capture Debugging Evidence**: Taking screenshots at key points provides visual debugging evidence that survives the session. This makes troubleshooting easier because you can review what the browser actually displayed, rather than relying solely on text logs or DOM dumps.

## Quick Start

**Automate browser interactions systematically:**

1. **If you need to navigate:** `open <url>` → `snapshot -i` → Result: Browser ready with element refs
2. **If you need to interact:** Use `@<ref>` patterns with `click` or `fill` → Result: Form submission or navigation
3. **If you need to verify:** Re-snapshot after actions → `close` → Result: Confirmed state change

**Why:** Structured workflow ensures actions are verifiable and state is tracked—essential for reliable automation.

---

## System Requirements

- **Browser**: Chrome/Chromium (for Playwright)
- **Node.js**: >= 18
- **Playwright**: `npm install playwright`

## Operational Patterns

This skill follows these behavioral patterns:

- **Tracking**: Maintain a visible task list for browser automation
- **Management**: Manage task lifecycle for browser interaction sequences

## Navigation

| If you need...         | Read...                                       |
| :--------------------- | :-------------------------------------------- |
| Navigate browser       | ## Quick Start → navigate                     |
| Interact with elements | ## Quick Start → interact                     |
| Verify state changes   | ## Quick Start → verify                       |
| Basic navigation       | ## Implementation Patterns → Basic Navigation |
| Form handling          | ## Implementation Patterns → Form Handling    |
| JavaScript execution   | See execution patterns in body                |

## Implementation Patterns

### Basic Navigation and Interaction

```bash
# Navigate and get snapshot
agent-browser open https://example.com
agent-browser snapshot -i
# Output:
# - heading "Example Domain" [ref=e1]
# - link "More information..." [ref=e2]

# Interact using refs
agent-browser click @e2
agent-browser screenshot page.png
agent-browser close
```

### Form Filling

```bash
agent-browser open https://forms.example.com
agent-browser snapshot -i
# Identify form fields by refs
agent-browser fill @email_field "user@example.com"
agent-browser fill @password_field "securepassword"
agent-browser click @submit_button
agent-browser snapshot -i  # Verify submission
```

### State Management

```bash
# Save session to avoid re-authentication
agent-browser state save auth.json

# Load previous session
agent-browser state load auth.json

# Record session for debugging
agent-browser record start demo.webm
# ... perform actions
agent-browser record stop
```

### Visual Debugging

```bash
# Run with visible browser for debugging
agent-browser open --headed https://example.com
agent-browser snapshot -i
# Check browser window for visual feedback
agent-browser close
```

---

## Troubleshooting

**Issue**: Elements not found

- **Symptom**: Click or fill fails with "element not found"
- **Solution**: Re-snapshot after navigation or DOM changes to get fresh refs

**Issue**: Actions timing out

- **Symptom**: Command hangs or times out
- **Solution**: Add `--headed` flag to see browser state, check for modal dialogs blocking interaction

**Issue**: Session lost on restart

- **Symptom**: Need to re-authenticate after browser close
- **Solution**: Use `state save` to persist session, `state load` to restore

**Issue**: Visual verification fails

- **Symptom**: Screenshot doesn't show expected content
- **Solution**: Ensure page fully loaded before screenshot, check for lazy-loaded content

---

## EDGE: Command Documentation

Before using commands, fetch current syntax from:

- https://agent-browser.dev/commands (Core, Get info, Check state)
- https://agent-browser.dev/selectors (Refs, CSS, Semantic locators)
- https://agent-browser.dev/sessions (Session isolation, profiles)

**Extraction Focus**:

1. Core navigation and interaction commands
2. Get info and state check commands
3. Selector syntax (refs preferred)
4. Session and profile commands

### Essential Commands

**Navigation & Discovery:**

```bash
agent-browser open <url>           # Navigate to URL
agent-browser snapshot -i          # Get interactive elements (recommended)
agent-browser close                # Close browser
```

### State Management

```bash
agent-browser state save auth.json     # Save session state
agent-browser state load auth.json     # Load session state
agent-browser record start demo.webm   # Record session
agent-browser record stop              # Stop recording
```

## Examples

| If you need...                              | Read...                      |
| ------------------------------------------- | ---------------------------- |
| Form filling, validation, submission        | `examples/forms.md`          |
| Login flows, session reuse, headers auth    | `examples/authentication.md` |
| Screenshots, data extraction, scrolling     | `examples/extraction.md`     |
| Multi-step workflows, error handling, SPA   | `examples/workflows.md`      |
| Wait patterns, scoped snapshots, comparison | `examples/patterns.md`       |

**Example Pattern**: When you work on a use case matching one from examples, you MUST read the corresponding file from `examples/`:

- **Forms**: Form filling, validation, submission patterns
- **Authentication**: Login flows, session state, headers-based auth
- **Extraction**: Screenshots, text/attribute extraction, scroll-and-load
- **Workflows**: Multi-step processes, error recovery, pagination
- **Patterns**: Utility patterns (wait, scoped snapshot, comparison, upload)

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

## Common Mistakes to Avoid

### Mistake 1: Using CSS Selectors Instead of Element Refs

❌ **Wrong:**
```bash
agent-browser click ".login-form > div:nth-child(2) > input"
```
Fragile: Breaks when CSS classes change

✅ **Correct:**
```bash
agent-browser snapshot -i  # Gets refs like @e1, @e2
agent-browser click @email_field
```
Stable: Refs based on semantic role, not CSS

### Mistake 2: No State Save Between Sessions

❌ **Wrong:**
Close browser → Re-authenticate next time → Wasted time on login flows

✅ **Correct:**
```bash
agent-browser state save auth.json  # Before closing
# Next session:
agent-browser state load auth.json  # Skip login
```

### Mistake 3: Not Re-snapshotting After Actions

❌ **Wrong:**
Click button → Immediately try to click another element → Element not found error

✅ **Correct:**
```bash
agent-browser click @submit_button
agent-browser snapshot -i  # Get fresh refs after DOM change
agent-browser click @next_element  # Now works
```

### Mistake 4: Missing Screenshot Evidence

❌ **Wrong:**
Test failed → Only have text logs → Can't see what browser actually showed

✅ **Correct:**
```bash
agent-browser open https://example.com
agent-browser snapshot -i
agent-browser screenshot before.png
# ... perform actions ...
agent-browser screenshot after.png
# Review visuals for debugging
```

### Mistake 5: Running Headed in CI/Automation

❌ **Wrong:**
CI pipeline fails → No display available → Browser can't start

✅ **Correct:**
```bash
agent-browser open https://example.com  # Headless by default
# For debugging only:
agent-browser open --headed https://example.com
```

### Mistake 6: Not Waiting for Page Load

❌ **Wrong:**
Open URL → Immediately interact → Element not found (page still loading)

✅ **Correct:**
```bash
agent-browser open https://example.com
agent-browser snapshot -i  # Wait for page to be interactive
# Now safe to interact
```

---

## Validation Checklist

Before claiming browser automation complete:

**Browser State:**
- [ ] Browser opened successfully
- [ ] Page loaded (snapshot returns elements)
- [ ] Element refs obtained (@e1, @e2, etc.)

**Interactions:**
- [ ] Element references valid (snapshot obtained fresh)
- [ ] Click/fill actions performed successfully
- [ ] Form submission worked (if applicable)

**State Management:**
- [ ] State saved if authentication performed
- [ ] Session can be restored with state load

**Verification:**
- [ ] Re-snapshot after actions to verify state change
- [ ] Screenshot captured for key steps (debugging evidence)
- [ ] No timeout errors or element not found errors

**Cleanup:**
- [ ] Browser closed properly
- [ ] No hanging browser processes

---

## Best Practices Summary

✅ **DO:**
- Use `snapshot -i` to get element refs (@e1, @e2) instead of CSS selectors
- Re-snapshot after DOM changes to get fresh refs
- Save state with `state save` to avoid re-authentication
- Take screenshots at key points for debugging evidence
- Run headless by default (no display required)
- Use `--headed` flag only for debugging visible issues
- Follow workflow: open → snapshot → interact → re-snapshot → close

❌ **DON'T:**
- Use fragile CSS selectors instead of stable refs
- Skip re-snapshotting after page navigation or DOM changes
- Forget to save state (lose authentication on close)
- Skip screenshots (lose visual debugging evidence)
- Run headed mode in CI/CD or server environments
- Interact before page fully loads (wait for snapshot)
- Leave browser open without proper close

---

<critical_constraint>
Portability invariant: This skill must work in zero .claude/rules environments.
Evidence requirement: Claims about browser behavior must be verified through actual execution.
</critical_constraint>
