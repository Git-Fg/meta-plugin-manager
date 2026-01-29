---
url: https://agent-browser.dev/installation
title: agent-browser
fetchTime: 2026-01-29T08:16:15.083Z
---

# agent-browser
[](https://vercel.com "Made with love by Vercel")[agent-browser](https://agent-browser.dev/)
[GitHub](https://github.com/vercel-labs/agent-browser)[npm](https://www.npmjs.com/package/agent-browser)
[Introduction](https://agent-browser.dev/)[Installation](https://agent-browser.dev/installation)[Quick Start](https://agent-browser.dev/quick-start)[Commands](https://agent-browser.dev/commands)[Selectors](https://agent-browser.dev/selectors)[Sessions](https://agent-browser.dev/sessions)[Snapshots](https://agent-browser.dev/snapshots)[Streaming](https://agent-browser.dev/streaming)[Agent Mode](https://agent-browser.dev/agent-mode)[CDP Mode](https://agent-browser.dev/cdp-mode)[Changelog](https://agent-browser.dev/changelog)
# Installation
## npm (recommended)
```
npm install -g agent-browser
agent-browser install  # Download Chromium
```
## From source
```
git clone https://github.com/vercel-labs/agent-browser
cd agent-browser
pnpm install
pnpm build
pnpm build:native
./bin/agent-browser install
pnpm link --global
```
## Linux dependencies
On Linux, install system dependencies:
```
agent-browser install --with-deps
# or manually: npx playwright install-deps chromium
```
## Custom browser
Use a custom browser executable instead of bundled Chromium:
-   **Serverless** - Use `@sparticuz/chromium` (~50MB vs ~684MB)
-   **System browser** - Use existing Chrome installation
-   **Custom builds** - Use modified browser builds
```
# Via flag
agent-browser --executable-path /path/to/chromium open example.com
# Via environment variable
AGENT_BROWSER_EXECUTABLE_PATH=/path/to/chromium agent-browser open example.com
```
### Serverless example
```
import chromium from '@sparticuz/chromium';
import { BrowserManager } from 'agent-browser';
export async function handler() {
  const browser = new BrowserManager();
  await browser.launch({
    executablePath: await chromium.executablePath(),
    headless: true,
  });
  // ... use browser
}
```