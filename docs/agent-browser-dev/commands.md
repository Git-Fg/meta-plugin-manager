---
url: https://agent-browser.dev/commands
title: agent-browser
fetchTime: 2026-01-29T08:16:15.275Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# Commands
## Core
```
agent-browser open <url>              # Navigate (aliases: goto, navigate)
agent-browser click <sel>             # Click element
agent-browser dblclick <sel>          # Double-click
agent-browser fill <sel> <text>       # Clear and fill
agent-browser type <sel> <text>       # Type into element
agent-browser press <key>             # Press key (Enter, Tab, Control+a)
agent-browser hover <sel>             # Hover element
agent-browser select <sel> <val>      # Select dropdown option
agent-browser check <sel>             # Check checkbox
agent-browser uncheck <sel>           # Uncheck checkbox
agent-browser scroll <dir> [px]       # Scroll (up/down/left/right)
agent-browser screenshot [path]       # Screenshot (--full for full page)
agent-browser snapshot                # Accessibility tree with refs
agent-browser eval <js>               # Run JavaScript
agent-browser close                   # Close browser
```
## Get info
```
agent-browser get text <sel>          # Get text content
agent-browser get html <sel>          # Get innerHTML
agent-browser get value <sel>         # Get input value
agent-browser get attr <sel> <attr>   # Get attribute
agent-browser get title               # Get page title
agent-browser get url                 # Get current URL
agent-browser get count <sel>         # Count matching elements
agent-browser get box <sel>           # Get bounding box
```
## Check state
```
agent-browser is visible <sel>        # Check if visible
agent-browser is enabled <sel>        # Check if enabled
agent-browser is checked <sel>        # Check if checked
```
## Find elements
Semantic locators with actions (`click`, `fill`, `check`, `hover`, `text`):
```
agent-browser find role <role> <action> [value]
agent-browser find text <text> <action>
agent-browser find label <label> <action> [value]
agent-browser find placeholder <ph> <action> [value]
agent-browser find testid <id> <action> [value]
agent-browser find first <sel> <action> [value]
agent-browser find nth <n> <sel> <action> [value]
```
Examples:
```
agent-browser find role button click --name "Submit"
agent-browser find label "Email" fill "test@test.com"
agent-browser find first ".item" click
```
## Wait
```
agent-browser wait <selector>         # Wait for element
agent-browser wait <ms>               # Wait for time
agent-browser wait --text "Welcome"   # Wait for text
agent-browser wait --url "**/dash"    # Wait for URL pattern
agent-browser wait --load networkidle # Wait for load state
agent-browser wait --fn "condition"   # Wait for JS condition
agent-browser wait --download [path]  # Wait for download
```
## Downloads
```
agent-browser download <sel> <path>   # Click element to trigger download
agent-browser wait --download [path]  # Wait for any download to complete
```
## Mouse
```
agent-browser mouse move <x> <y>      # Move mouse
agent-browser mouse down [button]     # Press button
agent-browser mouse up [button]       # Release button
agent-browser mouse wheel <dy> [dx]   # Scroll wheel
```
## Settings
```
agent-browser set viewport <w> <h>    # Set viewport size
agent-browser set device <name>       # Emulate device ("iPhone 14")
agent-browser set geo <lat> <lng>     # Set geolocation
agent-browser set offline [on|off]    # Toggle offline mode
agent-browser set headers <json>      # Extra HTTP headers
agent-browser set credentials <u> <p> # HTTP basic auth
agent-browser set media [dark|light]  # Emulate color scheme
```
## Cookies & storage
```
agent-browser cookies                 # Get all cookies
agent-browser cookies set <name> <val> # Set cookie
agent-browser cookies clear           # Clear cookies
agent-browser storage local           # Get all localStorage
agent-browser storage local <key>     # Get specific key
agent-browser storage local set <k> <v>  # Set value
agent-browser storage local clear     # Clear all
agent-browser storage session         # Same for sessionStorage
```
## Network
```
agent-browser network route <url>              # Intercept requests
agent-browser network route <url> --abort      # Block requests
agent-browser network route <url> --body <json>  # Mock response
agent-browser network unroute [url]            # Remove routes
agent-browser network requests                 # View tracked requests
```
## Tabs & frames
```
agent-browser tab                     # List tabs
agent-browser tab new [url]           # New tab
agent-browser tab <n>                 # Switch to tab
agent-browser tab close [n]           # Close tab
agent-browser frame <sel>             # Switch to iframe
agent-browser frame main              # Back to main frame
```
## Debug
```
agent-browser trace start [path]      # Start trace
agent-browser trace stop [path]       # Stop and save trace
agent-browser console                 # View console messages
agent-browser errors                  # View page errors
agent-browser highlight <sel>         # Highlight element
agent-browser state save <path>       # Save auth state
agent-browser state load <path>       # Load auth state
```
## Navigation
```
agent-browser back                    # Go back
agent-browser forward                 # Go forward
agent-browser reload                  # Reload page
```