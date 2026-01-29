---
url: https://agent-browser.dev/sessions
title: agent-browser
fetchTime: 2026-01-29T08:16:15.365Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# Sessions
Run multiple isolated browser instances:
```
# Different sessions
agent-browser --session agent1 open site-a.com
agent-browser --session agent2 open site-b.com
# Or via environment variable
AGENT_BROWSER_SESSION=agent1 agent-browser click "#btn"
# List active sessions
agent-browser session list
# Output:
# Active sessions:
# -> default
#    agent1
# Show current session
agent-browser session
```
## Session isolation
Each session has its own:
-   Browser instance
-   Cookies and storage
-   Navigation history
-   Authentication state
## Persistent profiles
By default, browser state is lost when the browser closes. Use `--profile` to persist state across restarts:
```
# Use a persistent profile directory
agent-browser --profile ~/.myapp-profile open myapp.com
# Login once, then reuse the authenticated session
agent-browser --profile ~/.myapp-profile open myapp.com/dashboard
# Or via environment variable
AGENT_BROWSER_PROFILE=~/.myapp-profile agent-browser open myapp.com
```
The profile directory stores:
-   Cookies and localStorage
-   IndexedDB data
-   Service workers
-   Browser cache
-   Login sessions
## Authenticated sessions
Use `--headers` to set HTTP headers for a specific origin:
```
# Headers scoped to api.example.com only
agent-browser open api.example.com --headers '{"Authorization": "Bearer <token>"}'
# Requests to api.example.com include the auth header
agent-browser snapshot -i --json
agent-browser click @e2
# Navigate to another domain - headers NOT sent
agent-browser open other-site.com
```
Useful for:
-   **Skipping login flows** - Authenticate via headers
-   **Switching users** - Different auth tokens per session
-   **API testing** - Access protected endpoints
-   **Security** - Headers scoped to origin, not leaked
## Multiple origins
```
agent-browser open api.example.com --headers '{"Authorization": "Bearer token1"}'
agent-browser open api.acme.com --headers '{"Authorization": "Bearer token2"}'
```
## Global headers
For headers on all domains:
```
agent-browser set headers '{"X-Custom-Header": "value"}'
```