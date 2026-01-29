---
url: https://agent-browser.dev/
title: agent-browser
fetchTime: 2026-01-29T08:15:47.301Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# agent-browser
Headless browser automation CLI for AI agents. Fast Rust CLI with Node.js fallback.
```
npm install -g agent-browser
```
## Features
-   **Universal** - Works with any AI agent: Claude Code, Cursor, Codex, Copilot, Gemini, opencode, and more
-   **AI-first** - Snapshot returns accessibility tree with refs for deterministic element selection
-   **Fast** - Native Rust CLI for instant command parsing
-   **Complete** - 50+ commands for navigation, forms, screenshots, network, storage
-   **Sessions** - Multiple isolated browser instances with separate auth
-   **Cross-platform** - macOS, Linux, Windows with native binaries
-   **Serverless** - Custom executable path for lightweight Chromium builds
## Example
```
# Navigate and get snapshot
agent-browser open example.com
agent-browser snapshot -i
# Output:
# - heading "Example Domain" [ref=e1]
# - link "More information..." [ref=e2]
# Interact using refs
agent-browser click @e2
agent-browser screenshot page.png
agent-browser close
```
## Why refs?
The `snapshot` command returns an accessibility tree where each element has a unique ref like `@e1`, `@e2`. This provides:
-   **Deterministic** - Ref points to exact element from snapshot
-   **Fast** - No DOM re-query needed
-   **AI-friendly** - LLMs can reliably parse and use refs
## Architecture
Client-daemon architecture for optimal performance:
1.  **Rust CLI** - Parses commands, communicates with daemon
2.  **Node.js Daemon** - Manages Playwright browser instance
Daemon starts automatically and persists between commands.
## Platforms
Native Rust binaries for macOS (ARM64, x64), Linux (ARM64, x64), and Windows (x64).