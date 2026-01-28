---
name: build-frontend
description: "Builds the frontend application. Use when user wants to compile, bundle, or prepare frontend for deployment."
---

# Frontend Build

<mission_control>
<objective>Build frontend application for development or production</objective>
<success_criteria>Build artifacts generated, build logs captured, errors reported clearly</success_criteria>
</mission_control>

<trigger>When building frontend, UI, or any client-side application code</trigger>

## Build Commands

| Command         | Purpose              |
| --------------- | -------------------- |
| `npm run build` | Production build     |
| `bun run build` | Bun production build |
| `npm run dev`   | Development server   |

## Detection

- Check for `package.json` with build scripts
- Detect framework from dependencies (react, vue, svelte)
- Use appropriate package manager (npm, pnpm, bun)

## Error Handling

- Capture build output
- Report errors with file:line references
- Suggest fixes for common issues

---

<critical_constraint>
MANDATORY: Detect package manager and framework before building
MANDATORY: Capture full build output for debugging
No exceptions. Build must be reproducible and debuggable.
</critical_constraint>
