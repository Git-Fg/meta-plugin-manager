# Component Validation Checklist

## Gate 1: Structure Verification

| Check               | Criteria                              | Verification              |
| ------------------- | ------------------------------------- | ------------------------- |
| YAML frontmatter    | Valid `name` and `description` fields | Read file, validate YAML  |
| File structure      | Follows component conventions         | Glob and compare          |
| No extraneous files | No README, INSTALLATION, CHANGELOG    | Glob for unexpected files |
| Naming              | Follows naming conventions            | Check path and filename   |

## Gate 2: Progressive Disclosure

| Tier   | Content                           | Max Tokens/Lines |
| ------ | --------------------------------- | ---------------- |
| Tier 1 | YAML metadata (What-When-Not)     | ~100 tokens      |
| Tier 2 | Core workflows, mission, patterns | <500 lines       |
| Tier 3 | References/ directory for details | Unlimited        |

Verification: Confirm Tier 2 is lean, Tier 3 exists with details.

## Gate 3: Portability Verification

| Check          | Criteria                                 | Verification             |
| -------------- | ---------------------------------------- | ------------------------ |
| Dependencies   | Zero external .claude/rules dependencies | Check imports/references |
| Self-contained | All context bundled in component         | Verify no absolute paths |
| References     | Use command/skill names, not file paths  | Audit references         |

## Gate 4: Content Quality

| Check            | Criteria                                   |
| ---------------- | ------------------------------------------ |
| Trigger phrases  | Description has clear trigger conditions   |
| Imperative voice | Instructions use infinitive form           |
| Expert-only      | No Claude-obvious content (Delta Standard) |
| Examples         | Clear, working examples provided           |

## Gate 5: Test Coverage

| Check             | Criteria                                |
| ----------------- | --------------------------------------- |
| Tests exist       | Component has test coverage             |
| Behavior verified | Tests verify actual behavior, not mocks |
| Edge cases        | Non-trivial edge cases covered          |
| Pass              | Tests run successfully                  |

## Quick Validation Commands

```bash
# Check YAML frontmatter
grep -E "^name:|^description:" SKILL.md

# Check for absolute paths
grep -E "/Users/.*/claude/" SKILL.md || echo "No absolute paths"

# Check for external references
grep -E "\.claude/rules|\.\./" SKILL.md

# Verify tier structure
wc -l SKILL.md
ls references/ 2>/dev/null || echo "No references/"
```

## Component-Specific Checks

### Skills

- Has `SKILL.md` with YAML frontmatter
- Has `workflows/` for guided processes (optional)
- Has `references/` for deep details (optional)

### Commands

- Single `.md` file
- Auto-invocable description
- No external dependencies

### Agents

- Has `agent.md` with YAML frontmatter
- Context isolation defined
- Tools properly declared

### Hooks

- Has `hook.md` with YAML frontmatter
- Event trigger specified
- Safe defaults configured

### MCPs

- Has `.mcp.json`
- Transport specified
- Authentication configured
