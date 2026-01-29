---
url: https://agent-browser.dev/agent-mode
title: agent-browser
fetchTime: 2026-01-29T08:16:24.060Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# Agent Mode
agent-browser works with any AI coding agent. Use `--json` for machine-readable output.
## Compatible agents
-   Claude Code
-   Cursor
-   GitHub Copilot
-   OpenAI Codex
-   Google Gemini
-   opencode
-   Any agent that can run shell commands
## JSON output
```
agent-browser snapshot --json
# {"success":true,"data":{"snapshot":"...","refs":{...}}}
agent-browser get text @e1 --json
agent-browser is visible @e2 --json
```
## Optimal workflow
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
## Integration
### Just ask
The simplest approach:
```
Use agent-browser to test the login flow. Run agent-browser --help to see available commands.
```
The `--help` output is comprehensive.
### AGENTS.md / CLAUDE.md
For consistent results, add to your instructions file:
```
## Browser Automation
Use `agent-browser` for web automation. Run `agent-browser --help` for all commands.
Core workflow:
1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. `agent-browser click @e1` / `fill @e2 "text"` - Interact using refs
4. Re-snapshot after page changes
```
### Claude Code skill
For richer context:
```
cp -r node_modules/agent-browser/skills/agent-browser .claude/skills/
```
Or download:
```
mkdir -p .claude/skills/agent-browser
curl -o .claude/skills/agent-browser/SKILL.md \
  https://raw.githubusercontent.com/vercel-labs/agent-browser/main/skills/agent-browser/SKILL.md
```