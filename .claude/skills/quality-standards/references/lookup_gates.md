# Gate Commands by Project Type

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Build validation | ## Build Gate |
| Type checking | ## Type Gate |
| Linting | ## Lint Gate |
| Test execution | ## Test Gate |
| Security scan | ## Security Gate |
| Diff verification | ## Diff Gate |
| Exit code meanings | ## Exit Codes |

## Build Gate

| Project Type | Command                                 | Success Criteria |
| ------------ | --------------------------------------- | ---------------- |
| Node.js      | `npm run build` or `pnpm build`         | Exit 0           |
| Python       | `python -m build` or `pip install -e .` | Exit 0           |
| Rust         | `cargo build`                           | Exit 0           |
| Go           | `go build`                              | Exit 0           |
| Java         | `mvn compile` or `gradle build`         | Exit 0           |
| No build     | Skip                                    | Exit 0           |

## Type Gate

| Project Type   | Command                            | Success Criteria |
| -------------- | ---------------------------------- | ---------------- |
| TypeScript     | `tsc --noEmit`                     | 0 type errors    |
| Python         | `mypy` or `pyright`                | 0 type errors    |
| Go             | `go vet`                           | 0 issues         |
| Rust           | `cargo check`                      | 0 errors         |
| Java           | `mvn type-check` or `gradle check` | Exit 0           |
| No type system | Skip                               | Exit 0           |

## Lint Gate

| Project Type | Command                                       | Success Criteria |
| ------------ | --------------------------------------------- | ---------------- |
| JS/TS        | `eslint .` and `prettier --check .`           | 0 errors         |
| Python       | `pylint .` or `flake8 .` or `black --check .` | 0 errors         |
| Rust         | `cargo clippy`                                | 0 warnings       |
| Go           | `gofmt -d .` and `golint .`                   | 0 diffs          |
| No linter    | Skip                                          | Warning          |

## Test Gate

| Project Type | Command                            | Success Criteria |
| ------------ | ---------------------------------- | ---------------- |
| Node.js      | `npm test -- --coverage`           | All pass, ≥80%   |
| Python       | `pytest --cov --cov-fail-under=80` | All pass, ≥80%   |
| Rust         | `cargo test --coverage`            | All pass, ≥80%   |
| Go           | `go test ./... -cover`             | All pass         |
| No tests     | Warning                            | Skip allowed     |

## Security Gate

### Secrets Detection

```bash
Grep: Search git diff for -iE pattern "(api_key|password|secret|token)"
```

### Console Logs Detection

```bash
Grep: Search git diff for console.log|print\(|fmt\.Print
```

### Vulnerability Scanning

| Project Type | Command                        |
| ------------ | ------------------------------ |
| Node.js      | `npm audit --audit-level=high` |
| Python       | `pip-audit`                    |
| Rust         | `cargo audit`                  |
| Go           | `govulncheck ./...`            |

## Diff Gate

| Check          | Command Pattern                                     |
| -------------- | --------------------------------------------------- | ----- | ---- |
| Commented code | Grep diff for `^[[:space:]]*//` or `^[[:space:]]*#` |
| TODOs          | Grep diff for `TODO                                 | FIXME | XXX` |
| Formatting     | `prettier --check .` or `black --check .`           |

## Exit Codes

| Code | Meaning                         |
| ---- | ------------------------------- |
| 0    | Gate passed                     |
| 1    | Gate failed (stop verification) |
| 2    | Gate skipped (not applicable)   |

## Sequential Execution

```bash
# Run all gates in sequence
.claude/scripts/gates/build-gate.sh && \
.claude/scripts/gates/type-gate.sh && \
.claude/scripts/gates/lint-gate.sh && \
.claude/scripts/gates/test-gate.sh && \
.claude/scripts/gates/security-gate.sh && \
.claude/scripts/gates/diff-gate.sh
```

## Pre-Commit Hook Configuration

```json
{
  "hooks": {
    "PreCommit": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/gates/verification-loop.sh",
            "description": "Run 6-phase verification before commit"
          }
        ]
      }
    ]
  }
}
```
