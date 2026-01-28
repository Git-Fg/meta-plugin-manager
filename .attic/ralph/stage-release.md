---
description: "Move a validated Ralph artifact from staging to production"
disable-model-invocation: true
---

# Stage Validated Artifact

Move a validated component from `ralph_validated/` to production `.claude/`.

## Usage

First, list available validated artifacts:

```bash
ls -la ralph_validated/
```

Review the validation report:

```bash
cat ralph_validated/<RUN_ID>/REPORT.md
```

If satisfied, stage to production:

```bash
ralph run -p "stage release ralph_validated/<RUN_ID>"
```

## Process

Read the report and verify:

1. Validation status is "PASS"
2. Confidence score >= 80
3. All acceptance criteria met
4. No critical issues in recommendations

If validation passes:

1. Move `artifacts/.claude/*` to project `.claude/`
2. Archive evidence to `.attic/ralph/<RUN_ID>/`
3. Clean staged directory
4. Record release in memory

## Safety Features

- Requires explicit RUN_ID (prevents accidental releases)
- Preserves full audit trail in `.attic/ralph/`
- Does NOT overwrite existing files (manual conflict resolution)
- Aborts if validation report shows issues

## Example

```bash
# Review the artifact
cat ralph_validated/2026-01-27_1430-auth-skill/REPORT.md

# Stage to production
ralph run -p "stage release ralph_validated/2026-01-27_1430-auth-skill"

# Result: Component now in .claude/, evidence preserved in .attic/ralph/
```
