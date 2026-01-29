---
url: https://agent-browser.dev/cdp-mode
title: agent-browser
fetchTime: 2026-01-29T08:16:24.618Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# CDP Mode
Connect to an existing browser via Chrome DevTools Protocol:
```
# Start Chrome with: google-chrome --remote-debugging-port=9222
# Connect once, then run commands without --cdp
agent-browser connect 9222
agent-browser snapshot
agent-browser tab
agent-browser close
# Or pass --cdp on each command
agent-browser --cdp 9222 snapshot
```
## Remote WebSocket URLs
Connect to remote browser services via WebSocket URL:
```
# Connect to remote browser service
agent-browser --cdp "wss://browser-service.com/cdp?token=..." snapshot
# Works with any CDP-compatible service
agent-browser --cdp "ws://localhost:9222/devtools/browser/abc123" open example.com
```
The `--cdp` flag accepts either:
-   A port number (e.g., `9222`) for local connections via `http://localhost:{port}`
-   A full WebSocket URL (e.g., `wss://...` or `ws://...`) for remote browser services
## Use cases
This enables control of:
-   Electron apps
-   Chrome/Chromium with remote debugging
-   WebView2 applications
-   Remote browser services (via WebSocket URL)
-   Any browser exposing a CDP endpoint
## Global options
| Option | Description |
| --- | --- |
| `--session <name>` | Use isolated session |
| `--profile <path>` | Persistent browser profile directory |
| `-p <provider>` | Cloud browser provider (`browserbase`, `browseruse`) |
| `--headers <json>` | HTTP headers scoped to origin |
| `--executable-path` | Custom browser executable |
| `--args <args>` | Browser launch args (comma-separated) |
| `--user-agent <ua>` | Custom User-Agent string |
| `--proxy <url>` | Proxy server URL |
| `--proxy-bypass <hosts>` | Hosts to bypass proxy |
| `--json` | JSON output for agents |
| `--full, -f` | Full page screenshot |
| `--name, -n` | Locator name filter |
| `--exact` | Exact text match |
| `--headed` | Show browser window |
| `--cdp <port|url>` | CDP connection (port or WebSocket URL) |
| `--debug` | Debug output |
## Cloud providers
Use cloud browser infrastructure when local browsers aren't available:
```
# Browserbase
export BROWSERBASE_API_KEY="your-api-key"
export BROWSERBASE_PROJECT_ID="your-project-id"
agent-browser -p browserbase open https://example.com
# Browser Use
export BROWSER_USE_API_KEY="your-api-key"
agent-browser -p browseruse open https://example.com
# Or via environment variable
export AGENT_BROWSER_PROVIDER=browserbase
agent-browser open https://example.com
```
The `-p` flag takes precedence over `AGENT_BROWSER_PROVIDER`.