---
description: "List all validated Ralph artifacts awaiting review"
disable-model-invocation: false
---

# List Validated Artifacts

Display all Ralph validation artifacts in `ralph_validated/` with their status.

## Usage

```bash
ralph run -p "list validated artifacts"
```

## Output Format

For each artifact, displays:
- Run ID (timestamp)
- Component name and type
- Validation result (PASS/FAIL)
- Confidence score
- Age of artifact

## Example Output

```
Validated Artifacts (3 total):

[1] 2026-01-27_1430-auth-skill
    Component: authentication-skill (skill)
    Status: PASS (confidence: 92)
    Age: 2 hours ago
    Report: ralph_validated/2026-01-27_1430-auth-skill/REPORT.md

[2] 2026-01-26_2205-api-command
    Component: api-endpoint-builder (command)
    Status: PASS (confidence: 88)
    Age: 1 day ago
    Report: ralph_validated/2026-01-26_2205-api-command/REPORT.md

[3] 2026-01-25_1830-test-hook
    Component: pre-commit-validator (hook)
    Status: FAIL (confidence: 65)
    Age: 2 days ago
    Report: ralph_validated/2026-01-25_1830-test-hook/REPORT.md
```

## Quick Actions

```bash
# View a specific report
cat ralph_validated/<RUN_ID>/REPORT.md

# Stage a passing artifact to production
ralph run -p "stage release ralph_validated/<RUN_ID>"

# Remove a failed artifact
rm -rf ralph_validated/<RUN_ID>/
```
