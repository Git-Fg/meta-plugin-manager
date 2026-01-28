---
name: build-fix
description: "Incrementally fix TypeScript and build errors when build fails, TypeScript errors occur, or compilation issues arise. Fixes one error at a time with verification."
disable-model-invocation: true
---

<mission_control>
<objective>Incrementally fix TypeScript and build errors one at a time with verification</objective>
<success_criteria>Build errors resolved or isolated, summary of fixed/remaining/new errors provided</success_ccriteria>
</mission_control>

# Build Fix Command

Incrementally fix TypeScript and build errors one at a time with verification.

## What This Command Does

Execute safe, incremental build error resolution:

1. **Run build** - Execute npm/pnpm build and capture errors
2. **Parse errors** - Group by file, sort by severity
3. **Fix iteratively** - For each error:
   - Show error context (5 lines before/after)
   - Explain the issue
   - Propose specific fix
   - Apply the fix
   - Re-run build
   - Verify error resolved

4. **Stop conditions**:
   - Fix introduces new errors
   - Same error persists after 3 attempts
   - User requests pause

5. **Show summary** - Errors fixed, remaining, new errors introduced

**Safety**: Fix one error at a time to prevent cascading failures.

## Build Detection

Automatically detects build command:

- `Bash: npm run build 2>&1 | tail -20` → Run npm build
- `Bash: pnpm build 2>&1 | tail -20` → Run pnpm build

## Error Analysis Process

### Error Grouping

```
Errors grouped by file:
- src/app/api/markets/route.ts: 3 errors
  - Line 15: Type 'string' is not assignable to type 'number'
  - Line 23: Property 'data' does not exist on type 'Response'
  - Line 45: Cannot find module '@/lib/utils'

Sorted by severity:
1. Missing dependencies (blocks all)
2. Type mismatches (blocks specific usage)
3. Minor warnings (cosmetic)
```

### Error Resolution Strategy

For each error:

````markdown
## Error: [File]:[Line]

**Issue**: [Clear explanation of what's wrong]

**Context** (5 lines before/after):

```typescript
Line 40:  const value = parseInt(input)
Line 41:  return value + 1
Line 42:  // Error here
Line 43:  return value.toString()
```
````

**Proposed Fix**:
[Specific code change to fix the error]

**Apply fix?** [Yes/No/Stop]

```

## Stop Conditions

**Stop immediately if**:
- Fix introduces 2+ new errors
- Same error fails after 3 attempts
- User requests pause
- Build error count increases

## Output Format

```

# BUILD FIX SUMMARY

Initial Errors: 12
Fixed: 8
Remaining: 4
New Errors Introduced: 0

STATUS: [IN PROGRESS / COMPLETE / BLOCKED]

Remaining Errors:

1. [File]:[Line] - [Error description]
2. [File]:[Line] - [Error description]

Recommendations:

- [Optional improvement suggestions]

````

## Safety Guidelines

- ✅ Fix one error at a time
- ✅ Verify build after each fix
- ✅ Read error context carefully
- ✅ Understand root cause before fixing
- ❌ Don't fix multiple errors at once
- ❌ Don't ignore error context
- ❌ Don't proceed if new errors appear

## Common Error Patterns

### Missing Dependencies
```typescript
// Error: Cannot find module '@/lib/utils'
// Fix: Install missing package or correct import path
````

### Type Mismatches

```typescript
// Error: Type 'string' is not assignable to type 'number'
// Fix: Check variable types, add type conversion or fix type definition
```

### Property Access

```typescript
// Error: Property 'data' does not exist on type 'Response'
// Fix: Check API response structure, add type definition
```

## Integration

This command integrates with:

- `qa/verify` - Run after fixing to ensure all quality gates pass
- `coding-standards` - Reference for type safety patterns
- `engineering-lifecycle` - Ensure tests still pass after fixes

## Arguments

This command does not interpret special arguments. Everything after `build/fix` is treated as additional context for the build fixing process.

---

<critical_constraint>
MANDATORY: Fix one error at a time - verify before proceeding
MANDATORY: Stop if fix introduces 2+ new errors
MANDATORY: Stop if same error persists after 3 attempts
MANDATORY: Show error context (5 lines before/after) for each fix
No exceptions. Incremental fixes prevent cascading failures.
</critical_constraint>
