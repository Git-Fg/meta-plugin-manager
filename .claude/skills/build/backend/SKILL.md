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

<critical_constraint>
MANDATORY: Detect language and build system before building
MANDATORY: Output binary to standard location
No exceptions. Backend builds must produce deployable artifacts.
</critical_constraint>
