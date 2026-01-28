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

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
MANDATORY: All components MUST be self-contained (zero .claude/rules dependency)
MANDATORY: Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)
MANDATORY: Description MUST use What-When-Not format in third person
MANDATORY: No component references another component by name in description
MANDATORY: Progressive disclosure - references/ for detailed content
MANDATORY: Use XML for control (mission_control, critical_constraint), Markdown for data
No exceptions. Portability invariant must be maintained.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

<critical_constraint>
MANDATORY: Detect package manager and framework before building
MANDATORY: Capture full build output for debugging
No exceptions. Build must be reproducible and debuggable.
</critical_constraint>
