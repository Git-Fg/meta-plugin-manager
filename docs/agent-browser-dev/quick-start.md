---
url: https://agent-browser.dev/quick-start
title: agent-browser
fetchTime: 2026-01-29T08:16:15.239Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# Quick Start
## Basic workflow
```
agent-browser open example.com
agent-browser snapshot                    # Get accessibility tree with refs
agent-browser click @e2                   # Click by ref from snapshot
agent-browser fill @e3 "test@example.com" # Fill by ref
agent-browser get text @e1                # Get text by ref
agent-browser screenshot                  # Save to a temporary directory
agent-browser screenshot page.png         # Save to a specific path
agent-browser close
```
## Traditional selectors
CSS selectors and semantic locators also supported:
```
agent-browser click "#submit"
agent-browser fill "#email" "test@example.com"
agent-browser find role button click --name "Submit"
```
## AI workflow
Optimal workflow for AI agents:
```
# 1. Navigate and get snapshot
agent-browser open example.com
agent-browser snapshot -i --json   # AI parses tree and refs
# 2. AI identifies target refs from snapshot
# 3. Execute actions using refs
agent-browser click @e2
agent-browser fill @e3 "input text"
# 4. Get new snapshot if page changed
agent-browser snapshot -i --json
```
## Headed mode
Show browser window for debugging:
```
agent-browser open example.com --headed
```
## JSON output
Use `--json` for machine-readable output:
```
agent-browser snapshot --json
agent-browser get text @e1 --json
agent-browser is visible @e2 --json
```