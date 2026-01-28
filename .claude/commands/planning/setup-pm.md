---
name: setup-pm
description: "Configure your preferred package manager when setting up a new project, switching package managers, or standardizing team workflow."
disable-model-invocation: true
---

<mission_control>
<objective>Configure package manager preference through detection priority system</objective>
<success_criteria>Package manager configured and verified through detection hierarchy</success_criteria>
</mission_control>

# Package Manager Setup Command

Configure your preferred package manager for this project or globally.

## What This Command Does

Establish package manager preference through detection priority:

1. **Detect current package manager** - Check all detection levels
2. **Show current priority** - Display which method is active
3. **Configure preference** - Set project or global preference
4. **Verify configuration** - Confirm detection order

## Detection Priority

When determining which package manager to use, the following order is checked:

1. **Environment variable**: `CLAUDE_PACKAGE_MANAGER`
2. **Project config**: `.claude/package-manager.json`
3. **package.json**: `packageManager` field
4. **Lock file**: Presence of package-lock.json, yarn.lock, pnpm-lock.yaml, or bun.lockb
5. **Global config**: `~/.claude/package-manager.json`
6. **Fallback**: First available package manager (pnpm > bun > yarn > npm)

## Configuration Methods

### Method 1: Environment Variable

Set `CLAUDE_PACKAGE_MANAGER` to override all other detection methods:

- `Bash: export CLAUDE_PACKAGE_MANAGER=pnpm` → Set on macOS/Linux
- `Bash: $env:CLAUDE_PACKAGE_MANAGER = "pnpm"` → Set in PowerShell
- `Bash: set CLAUDE_PACKAGE_MANAGER=pnpm` → Set in Windows CMD

**Best for**: Temporary override, CI/CD environments

### Method 2: Project Configuration

Create `.claude/package-manager.json`:

```json
{
  "packageManager": "pnpm"
}
```

**Best for**: Project-specific preference, team consistency

### Method 3: package.json Field

Add to package.json:

```json
{
  "packageManager": "pnpm@8.6.0"
}
```

**Best for**: Node.js standard, Corepack compatibility

### Method 4: Global Configuration

Create `~/.claude/package-manager.json`:

```json
{
  "packageManager": "pnpm"
}
```

**Best for**: Personal default across all projects

## Detection Workflow

Detection follows this priority order:

1. Check for `CLAUDE_PACKAGE_MANAGER` environment variable
2. Check for `.claude/package-manager.json`
3. Check `package.json` "packageManager" field
4. Detect lock file (package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb)
5. Check `~/.claude/package-manager.json`
6. Fall back to available (pnpm > bun > yarn > npm)

## Lock File Detection

| Lock File           | Package Manager |
| ------------------- | --------------- |
| `pnpm-lock.yaml`    | pnpm            |
| `bun.lockb`         | bun             |
| `yarn.lock`         | yarn            |
| `package-lock.json` | npm             |

## Integration

This command integrates with:

- `verify` - Ensure package manager consistency
- `build-fix` - Use correct package manager for builds
- `engineering-lifecycle` - Test commands use detected package manager

## Arguments

This command interprets special arguments to set configuration:

- `/setup-pm pnpm` → Set project preference to pnpm
- `/setup-pm global bun` → Set global preference to bun
- `/setup-pm detect` → Show current detection result
- `/setup-pm list` → Show available package managers

**Available package managers**: npm, pnpm, yarn, bun

<critical_constraint>
MANDATORY: Follow detection priority (env var > project config > package.json > lock file > global > fallback)
MANDATORY: Verify configuration after setting
No exceptions. Package manager must be consistently detected across all tools.
