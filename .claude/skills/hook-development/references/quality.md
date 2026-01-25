# Hook Quality Framework

Comprehensive quality assessment framework for hooks in local projects. Use this framework to evaluate hook implementations and identify areas for improvement.

## Scoring System (0-100 Points)

### Dimension 1: Security Coverage (25 points)

Hooks protect critical operations from unintended or malicious actions.

| Score | Criteria |
|-------|----------|
| **25** | Comprehensive security checks on all dangerous operations (file writes, bash commands, MCP tools). Path traversal protection, sensitive file guarding, credential filtering. |
| **20** | Strong security on most operations, minor gaps in edge cases. |
| **15** | Basic security present but incomplete (e.g., file write validation without bash command checks). |
| **10** | Minimal security (only one type of operation protected). |
| **5** | Security hooks present but mostly ineffective. |
| **0** | No security hooks. |

**Recognition questions:**
- Does the hook validate file paths for traversal attempts (`..`)?
- Are sensitive files (`.env`, credentials) protected from modification?
- Are dangerous bash commands (`rm`, `dd`, `mkfs`) validated?
- Do MCP deletion hooks require confirmation?

### Dimension 2: Validation Patterns (20 points)

Input validation and sanitization in command hooks.

| Score | Criteria |
|-------|----------|
| **20** | All inputs validated and sanitized. JSON parsing with error handling. Type checking on all fields. |
| **16** | Strong validation with minor edge cases uncovered. |
| **12** | Basic validation present but incomplete. |
| **8** | Minimal validation (only one field checked). |
| **4** | Validation attempted but ineffective. |
| **0** | No input validation. |

**Recognition questions:**
- Does the hook use `jq` with error checking for JSON input?
- Are all required fields validated before use?
- Are unexpected field types handled gracefully?
- Is input sanitized before use in commands?

### Dimension 3: Exit Code Usage (15 points)

Correct use of exit codes for hook decisions.

| Score | Criteria |
|-------|----------|
| **15** | Perfect exit code discipline: 0 (allow), 1 (warning), 2 (deny). Clear decision semantics. |
| **12** | Correct exit codes with minor inconsistency. |
| **9** | Mostly correct with some incorrect codes. |
| **6** | Exit codes used but incorrectly mapped. |
| **3** | Exit codes present but unpredictable. |
| **0** | No exit code discipline. |

**Exit code reference:**
| Code | Meaning | Use For |
|------|---------|---------|
| `0` | Success/approve | Operation allowed |
| `1` | Warning | Non-blocking issue, operation allowed |
| `2` | Deny/block | Operation denied, must stop |

**Recognition questions:**
- Does the hook use exit 2 for blocking errors?
- Is exit 0 used for successful approval?
- Are exit codes consistent with intended behavior?

### Dimension 4: Script Quality (20 points)

Well-written, maintainable bash scripts.

| Score | Criteria |
|-------|----------|
| **20** | Clean, idiomatic bash with `set -euo pipefail`. All variables quoted. Error handling present. Comments explain non-obvious logic. |
| **16** | Good quality with minor style issues. |
| **12** | Functional but with quality concerns (unquoted variables, no error handling). |
| **8** | Script works but is brittle or hard to maintain. |
| **4** | Script has significant issues but sometimes works. |
| **0** | No script or completely broken. |

**Recognition questions:**
- Does the script use `set -euo pipefail` for error handling?
- Are all variables quoted (`"$VAR"` not `$VAR`)?
- Is there proper error handling (try/except patterns)?
- Are commands portable (no hardcoded paths, use `${CLAUDE_PROJECT_DIR}` or `.claude/scripts/`)?

### Dimension 5: Configuration Hierarchy (20 points)

Modern, appropriate configuration approach for local projects.

| Score | Criteria |
|-------|----------|
| **20** | Proper use of settings.json/settings.local.json. Clear separation of team vs personal hooks. Component-scoped hooks used appropriately. No legacy hooks.json. |
| **16** | Good modern approach with minor organizational issues. |
| **12** | Mix of modern and legacy patterns. |
| **8** | Primarily legacy patterns (hooks.json). |
| **4** | Inappropriate configuration scope. |
| **0** | No configuration or completely broken. |

**Configuration hierarchy for local projects:**
1. **Team-wide settings** (`.claude/settings.json`) - Committed to git, shared across team
2. **Personal overrides** (`.claude/settings.local.json`) - Gitignored, personal customization
3. **Component-scoped** (YAML frontmatter) - Skill/agent specific hooks with auto-cleanup
4. **Legacy global** (`.claude/hooks.json`) - Deprecated, avoid

**Recognition questions:**
- Are hooks in `.claude/settings.json` rather than legacy `hooks.json`?
- Is team-wide configuration properly separated from personal overrides?
- Are component-scoped hooks used for skill/agent-specific validation?
- Is `.claude/settings.local.json` in `.gitignore`?

## Quality Thresholds

| Grade | Score Range | Interpretation |
|-------|-------------|----------------|
| **A** | 90-100 | Exemplary security posture and implementation |
| **B** | 75-89 | Good security with minor gaps or improvements needed |
| **C** | 60-74 | Adequate security, needs improvement for production |
| **D** | 40-59 | Poor security, significant issues present |
| **F** | 0-39 | Failing security, critical vulnerabilities |

## Validation Checklist

Use this checklist before deploying hooks:

### Security
- [ ] PreToolUse hooks validate file paths for `..` traversal
- [ ] Sensitive files (`.env`, credentials) are protected
- [ ] Dangerous bash commands trigger confirmation
- [ ] MCP deletion hooks require approval

### Input Validation
- [ ] All JSON input is parsed with `jq` and error-checked
- [ ] Required fields are validated before use
- [ ] Unexpected types are handled gracefully

### Exit Codes
- [ ] Exit 2 used for blocking errors
- [ ] Exit 0 used for approval
- [ ] Exit 1 used for warnings

### Script Quality
- [ ] `set -euo pipefail` for error handling
- [ ] All variables quoted
- [ ] `${CLAUDE_PROJECT_DIR}` or project-relative paths used
- [ ] Error handling present for critical operations

### Configuration
- [ ] Using `.claude/settings.json` not legacy `hooks.json`
- [ ] Team hooks in settings.json (committed)
- [ ] Personal hooks in settings.local.json (gitignored)
- [ ] Component-scoped hooks where appropriate

### Git Integration
- [ ] `.claude/settings.local.json` in `.gitignore`
- [ ] Team hooks documented in project README
- [ ] Hook scripts executable (`chmod +x`)

## Anti-Patterns to Avoid

### Security Anti-Patterns

**Trusting user input:**
```bash
# BAD: Direct use of input
rm -rf "$file_path"

# GOOD: Validation before use
if [[ "$file_path" == *".."* ]]; then
  echo '{"decision": "deny", "reason": "Path traversal"}' >&2
  exit 2
fi
```

**Missing sensitive file checks:**
```bash
# BAD: No .env protection
# GOOD: Explicit check
if [[ "$file_path" == *".env"* ]]; then
  echo '{"decision": "deny", "reason": "Protected file"}' >&2
  exit 2
fi
```

### Script Quality Anti-Patterns

**Unquoted variables:**
```bash
# BAD: Injection risk
echo $file_path

# GOOD: Quoted
echo "$file_path"
```

**Missing error handling:**
```bash
# BAD: No error handling
result=$(jq '.field' "$file")

# GOOD: With error handling
if ! result=$(jq -e '.field' "$file" 2>/dev/null); then
  echo '{"error": "Invalid JSON"}' >&2
  exit 2
fi
```

### Configuration Anti-Patterns

**Legacy hooks.json:**
```json
// BAD: Deprecated format
{
  "PreToolUse": [...]
}

// GOOD: Modern settings.json
{
  "hooks": {
    "PreToolUse": [...]
  }
}
```

**Hardcoded paths:**
```json
// BAD: Not portable
"command": "/home/user/scripts/validate.sh"

// GOOD: Portable with ${CLAUDE_PROJECT_DIR}
"command": "bash ${CLAUDE_PROJECT_DIR}/.claude/scripts/validate.sh"

// GOOD: Project-relative
"command": "bash .claude/scripts/validate.sh"
```

**Wrong configuration file:**
```json
// BAD: Personal hooks in committed file
// .claude/settings.json - should only have team hooks
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash .claude/scripts/my-personal-setup.sh"
      }
    ]
  }
}

// GOOD: Personal hooks in settings.local.json (gitignored)
// .claude/settings.local.json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash .claude/scripts/my-personal-setup.sh"
      }
    ]
  }
}
```

## Testing Quality

Validate hook quality through testing:

1. **Manual testing**: Test each hook with sample inputs
2. **Edge cases**: Test boundary conditions (empty input, malformed JSON)
3. **Security tests**: Attempt path traversal, sensitive file access
4. **Exit code tests**: Verify correct exit codes for all scenarios
5. **Performance tests**: Measure hook execution time

Use the provided scripts in `scripts/`:
- `validate-hook-schema.sh` - Validate settings.json structure
- `test-hook.sh` - Test hooks with sample input
- `hook-linter.sh` - Check for common issues

## Team Collaboration Best Practices

### Shared vs Personal Hooks

**Team-wide hooks** (`.claude/settings.json`):
- Committed to version control
- Enforce project standards across team
- Security policies, quality gates
- Build/test requirements

**Personal hooks** (`.claude/settings.local.json`):
- Gitignored (add to `.gitignore`)
- Personal development preferences
- Local debugging tools
- Custom workflow automation

### Hook Independence

Design hooks assuming parallel execution:
- Hooks don't see each other's output
- No ordering guarantees
- Each hook should be independently useful
- Avoid duplicate functionality across team and personal hooks

## Continuous Improvement

Review and improve hooks periodically:

1. **Audit**: Run quality framework assessment quarterly
2. **Update**: Incorporate new patterns and best practices
3. **Test**: Add tests for new edge cases discovered
4. **Document**: Update comments and documentation
5. **Refactor**: Remove outdated or redundant hooks

## External Resources

- **Official Hooks Docs**: https://code.claude.com/docs/en/hooks
- **Security Patterns**: See `patterns.md` for proven security patterns
- **Examples**: See `examples/` for working hook implementations
