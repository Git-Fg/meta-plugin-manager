# Portability Invariant Validation System

## Overview

The Portability Invariant Validation System ensures that Seed System components work in isolation without external dependencies. It validates that components carry their own "genetic code" and can survive being moved to any environment.

## What It Validates

### 1. External References Check
- **What**: Scans for references to `.claude/rules/`
- **Why**: External references break portability
- **Pass**: No external `.claude/rules/` references found
- **Fail**: External references detected

### 2. Success Criteria Check
- **What**: Verifies Success Criteria section exists and is self-validating
- **Why**: Components must self-validate without external dependencies
- **Pass**: Success Criteria with "self-validation without external dependencies"
- **Fail**: Missing or non-self-validating Success Criteria

### 3. Teaching Formula Check
- **What**: Validates 1 Metaphor + 2 Contrast Examples + 3 Recognition Questions
- **Why**: Teaching Formula is mandatory for all Seed System components
- **Pass**: All three elements present
- **Fail**: Missing or incomplete Teaching Formula

### 4. Self-Containment Check
- **What**: Verifies examples are inlined and no external file references
- **Why**: Components must own all their content
- **Pass**: Examples inlined, no external references
- **Fail**: External file references found

### 5. Portability Invariant Check
- **What**: Confirms bundled philosophy and Portability requirement stated
- **Why**: Components must bundle their own philosophy
- **Pass**: Bundled philosophy and Portability requirement present
- **Fail**: Missing Portability enforcement

## Usage

### Validate All Meta-Skills
```bash
.claude/scripts/validate-portability.sh all
```

### Validate Specific Component
```bash
.claude/scripts/validate-portability.sh validate .claude/skills/skill-development/SKILL.md
```

### Test Isolation
```bash
.claude/scripts/validate-portability.sh test .claude/skills/command-development/SKILL.md
```

### Show Help
```bash
.claude/scripts/validate-portability.sh help
```

## Validation Output

### Success Example
```
============================================
OVERALL PORTABILITY VALIDATION RESULTS
============================================
Total Components: 5
Passed: 5
Failed: 0

✓ ALL COMPONENTS ARE PORTABLE
Seed System creates portable organisms!
```

### Failure Example
```
============================================
OVERALL PORTABILITY VALIDATION RESULTS
============================================
Total Components: 5
Passed: 3
Failed: 2

✗ PORTABILITY ISSUES FOUND
Some components need fixes.
```

## Exit Codes

- **0**: All validations passed
- **1**: One or more validations failed

## The Isolation Test

The validation system includes an **isolation test** that:
1. Copies the component to a fresh directory
2. Removes all .claude/rules/ context
3. Validates the component works without external dependencies

This simulates moving the component to a "project with zero .claude/rules" as required by the Portability Invariant.

## Integration with CI/CD

### Git Pre-Commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

if ! .claude/scripts/validate-portability.sh all; then
    echo "Portability validation failed. Fix issues before committing."
    exit 1
fi
```

### GitHub Actions
```yaml
name: Portability Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate Portability
        run: .claude/scripts/validate-portability.sh all
```

## Component-Specific Validation

### Skills
- Must include bundled skill-development philosophy
- Progressive Disclosure enforcement
- Self-contained examples

### Commands
- Must include mandatory references with "You MUST" language
- Instructions FOR Claude (not TO user)
- Complete frontmatter configuration

### Agents
- Must include autonomous context
- Complete system prompt
- Triggering examples with <example> blocks

### Hooks
- Must include event validation logic
- Security patterns
- JSON response format

### MCP Servers
- Must include transport configuration
- Authentication patterns
- Server primitives definition

## Manual Validation Checklist

When creating a new component, verify:

- [ ] No references to `.claude/rules/`
- [ ] Success Criteria with self-validation
- [ ] Teaching Formula (1 Metaphor + 2 Contrasts + 3 Recognition)
- [ ] All examples inlined
- [ ] Bundled condensed philosophy
- [ ] Portability requirement stated
- [ ] Works in isolation test

## Troubleshooting

### "External references found"
**Fix**: Replace external references with bundled philosophy

### "Success Criteria not self-validating"
**Fix**: Add "Self-validation: Verify without external dependencies"

### "Teaching Formula incomplete"
**Fix**: Add missing elements using Teaching Formula Arsenal

### "Examples not inlined"
**Fix**: Embed examples directly in component

### "Bundled philosophy missing"
**Fix**: Add condensed Seed System philosophy

## Success Criteria

A component passes Portability Validation when:

- ✅ No external `.claude/rules/` references
- ✅ Success Criteria with self-validation
- ✅ Complete Teaching Formula
- ✅ Self-contained examples
- ✅ Bundled philosophy
- ✅ Passes isolation test

**Result**: The component works in a project with ZERO .claude/rules!

## Philosophy

> "The Seed System creates portable 'organisms,' not project-dependent tools."

Every component bundles its own philosophy and self-validation logic. The Portability Invariant ensures this genetic code is complete and functional in any environment.
