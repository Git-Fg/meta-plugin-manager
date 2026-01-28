---
name: build-backend
description: "Builds and packages the backend service. Use when compiling server-side code, creating binaries, or preparing backend for deployment."
---

# Backend Build

<mission_control>
<objective>Build backend service for development or production deployment</objective>
<success_criteria>Binary or deployable artifact generated, build logs captured</success_criteria>
</mission_control>

<trigger>When building backend, API, server, or any service-side application</trigger>

## Build Patterns

| Language   | Build Command                     |
| ---------- | --------------------------------- |
| TypeScript | `tsc` or `ts-node`                |
| Go         | `go build`                        |
| Rust       | `cargo build`                     |
| Python     | `pip install -e .` or build wheel |
| Java       | `mvn package` or `gradle build`   |

## Detection

- Check file extensions (.ts, .go, .rs, .py, .java)
- Look for build configuration (tsconfig.json, Cargo.toml, pom.xml)
- Detect package manager from lock files

## Output

- Binary in `dist/`, `bin/`, or `target/`
- Docker image if Dockerfile present
- Deployable package (zip, tar.gz)

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
MANDATORY: Detect language and build system before building
MANDATORY: Output binary to standard location
No exceptions. Backend builds must produce deployable artifacts.
</critical_constraint>
