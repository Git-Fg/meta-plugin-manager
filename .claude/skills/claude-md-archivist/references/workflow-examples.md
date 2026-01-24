# Inspiration Patterns

Use these patterns as **starting points**. Adapt them to the specific project reality.

## 1. The High-Signal Command List
*Don't just list scripts. Explain unique flags and environments.*

```markdown
## Commands
| Command | Context |
|---------|---------|
| `npm ci` | **CI Only**. Strict dependency install. |
| `npm run dev -- --host 0.0.0.0` | Required for Docker/WSL2. |
| `npm test -- -t "auth"` | Run only auth tests (slow otherwise). |
```

## 2. The "Gotchas" Section
*The most valuable section. Save future you from pain.*

```markdown
## Known Issues
- **Hydration Errors**: Caused by `Date.now()` in components. Use `useEffect`.
- **Build OOM**: Node 18+ needs `NODE_OPTIONS="--max-old-space-size=4096"`.
- **API Rate Limits**: Dev tokens limited to 100 req/min. Mock in tests.
```

## 3. Architecture Decisions
*Why is it built this way?*

```markdown
## Decisions
- **Zustand over Redux**: Simplicity preferred. No complex state needed yet.
- **Tailwind**: enforced via `prettier-plugin-tailwindcss`.
- **Auth**: Firebase Auth (client-side) + Custom Claims (server-side).
```

## 4. Active Learning Integration
*How to add new learnings mid-stream.*

**Input**: _"I found out that we need to restart the swift compiler after changing bridging headers."_

**Update**:
```markdown
## MacOS Native
- **Bridging Header**: changes require full rebuild (clean build folder).
```
