---
name: update-docs
description: "Sync documentation from source-of-truth when code changes, new features are added, or documentation drift is detected. Keeps docs aligned with codebase."
disable-model-invocation: true
---

<mission_control>
<objective>Sync documentation from source-of-truth to maintain accurate project documentation</objective>
<success_criteria>docs/CONTRIB.md and docs/RUNBOOK.md generated, obsolete docs identified, diff summary shown</success_criteria>
</mission_control>

# Update Documentation Command

Sync documentation from source-of-truth to maintain accurate project documentation.

## What This Command Does

Synchronize documentation by extracting from code:

1. **Read package.json** - Extract scripts and generate reference
2. **Read .env.example** - Document environment variables
3. **Generate docs/CONTRIB.md** - Development workflow guide
4. **Generate docs/RUNBOOK.md** - Deployment and operations guide
5. **Identify obsolete docs** - Find stale documentation (90+ days old)
6. **Show diff summary** - Display changes made

## Source of Truth

Documentation is generated from:

- **package.json** - Scripts, dependencies, metadata
- **.env.example** - Environment variables

**Single source of truth principle**: Documentation reflects actual code, not separate documentation files.

## Generated Documentation

### docs/CONTRIB.md

Development workflow and setup guide:

```markdown
# Contributing Guide

## Development Workflow

1. Clone repository
2. Install dependencies: [package manager install]
3. Start dev server: [dev script]
4. Run tests: [test script]
5. Build for production: [build script]

## Available Scripts

| Script | Command   | Description              |
| ------ | --------- | ------------------------ |
| dev    | [command] | Start development server |
| build  | [command] | Build for production     |
| test   | [command] | Run test suite           |
| lint   | [command] | Run linter               |

## Environment Setup

Required environment variables:

- [Variable] - [Purpose]

## Testing Procedures

1. Run unit tests: [test script]
2. Run integration tests: [test:integration script]
3. Check coverage: [test:coverage script]
```

### docs/RUNBOOK.md

Deployment and operations guide:

```markdown
# Runbook

## Deployment Procedures

1. Run tests: [test script]
2. Build: [build script]
3. Deploy: [deploy script]

## Monitoring and Alerts

- Health check endpoint: [url]
- Error tracking: [service]
- Performance monitoring: [service]

## Common Issues and Fixes

### Issue: [problem description]

**Symptom**: [what users see]
**Fix**: [resolution steps]

### Issue: [another problem]

**Symptom**: [what users see]
**Fix**: [resolution steps]

## Rollback Procedures

1. Identify broken commit: [git command]
2. Revert changes: [git command]
3. Redeploy: [deploy script]
```

## Extraction Patterns

### From package.json

Extract scripts section:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "test": "vitest",
    "test:coverage": "vitest --coverage"
  }
}
```

Generate table:
| Script | Command | Description |
|--------|---------|-------------|
| dev | next dev | Start development server |
| build | next build | Build for production |
| test | vitest | Run test suite |
| test:coverage | vitest --coverage | Run tests with coverage |

### From .env.example

Extract variables:

```
# Database
DATABASE_URL=postgresql://user:pass@host:5432/db
DATABASE_POOL_SIZE=10

# API
API_KEY=your-api-key
API_TIMEOUT=30000

# Auth
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=1h
```

Generate documentation:
| Variable | Required | Description | Default |
|----------|----------|-------------|---------|
| DATABASE_URL | Yes | PostgreSQL connection string | - |
| DATABASE_POOL_SIZE | No | Connection pool size | 10 |
| API_KEY | Yes | External API key | - |
| API_TIMEOUT | No | Request timeout in ms | 30000 |
| JWT_SECRET | Yes | JWT signing secret | - |
| JWT_EXPIRES_IN | No | Token expiration time | 1h |

## Obsolete Documentation Detection

Identify documentation not modified in 90+ days:

- `Bash: find docs/ -type f -mtime +90` → Find files older than 90 days
- `Bash: ls -la docs/` → Show last modified dates
- `Bash: git log -1 --format="%ai" -- docs/FILE.md` → Check git history for specific file

List for manual review:

```
Potentially obsolete docs (> 90 days):
- docs/ARCHITECTURE.md (last modified: 2024-10-15)
- docs/DEPRECATED.md (last modified: 2024-09-20)
- docs/FAQ.md (last modified: 2024-08-30)
```

## Diff Summary

Show changes made:

```
DOCUMENTATION UPDATE SUMMARY
============================

Created files:
- docs/CONTRIB.md (development workflow)
- docs/RUNBOOK.md (deployment procedures)

Updated files:
- README.md (added scripts reference)

Potentially obsolete (> 90 days):
- docs/ARCHITECTURE.md
- docs/FAQ.md

Changes:
+ Added 15 scripts to documentation
+ Added 8 environment variables
+ Updated deployment procedures
```

## Best Practices

- **Keep docs close to code**: Document in code when possible (JSDoc, comments)
- **Single source of truth**: Generate from code, don't duplicate
- **Regular updates**: Run after significant code changes
- **Review obsolete docs**: Manually review old docs for deletion or update

## Integration

This command integrates with:

- `code-review` - Check documentation coverage during review
- `verify` - Ensure documentation is up to date
- `learn` - Extract patterns as reusable skills

## Arguments

This command does not interpret special arguments. Everything after `/update-docs` is treated as additional context for documentation generation.

**Optional context you can provide**:

- Scope ("only update scripts reference")
- Format ("generate markdown, not tables")
- Obsolete threshold ("mark docs older than 60 days")

---

<critical_constraint>
MANDATORY: Generate from source-of-truth (package.json, .env.example) - never manually write
MANDATORY: Identify docs not modified in 90+ days for review
MANDATORY: Show diff summary before generating documentation
MANDATORY: Never overwrite without showing what will change
No exceptions. Documentation must reflect actual code, not manual duplication.
</critical_constraint>
