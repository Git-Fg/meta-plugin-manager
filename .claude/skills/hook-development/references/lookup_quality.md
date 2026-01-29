# Hook Quality Reference

**For complete hook documentation, fetch the official documentation:**

```bash
curl -s https://code.claude.com/docs/en/hooks.md
```

This reference contains only unique Seed System quality patterns not covered in official docs.

---

| If you need...                  | Read this section...            |
| ------------------------------- | ------------------------------- |
| Security anti-patterns          | Security Anti-Patterns          |
| Script quality patterns         | Script Quality Anti-Patterns    |
| Hook validation checklist       | Hook Validation Checklist       |
| Timeout and blocking prevention | Timeout and Blocking Prevention |

---

| Context Condition       | Action                            |
| :---------------------- | :-------------------------------- |
| Creating new hook       | Read all sections, apply patterns |
| Reviewing existing hook | Check against anti-patterns       |
| Debugging hook issues   | Check Hook Validation Checklist   |
| Security audit          | Focus on Security Anti-Patterns   |

---

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

---

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

---

## Continuous Improvement

Review and improve hooks periodically:

1. **Audit**: Run quality framework assessment quarterly
2. **Update**: Incorporate new patterns and best practices
3. **Test**: Add tests for new edge cases discovered
4. **Document**: Update comments and documentation
5. **Refactor**: Remove outdated or redundant hooks
