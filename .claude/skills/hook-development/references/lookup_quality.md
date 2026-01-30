# Hook Quality Reference

**For complete hook documentation, fetch the official documentation:**

```bash
curl -s https://code.claude.com/docs/en/hooks.md
```

This reference contains only unique Seed System quality patterns not covered in official docs.

---

## Navigation

| If you need...                  | Read this section...            |
| ------------------------------- | ------------------------------- |
| Security anti-patterns          | SKILL.md ## Security Anti-Patterns (in ## Common Mistakes) |
| Hook validation checklist       | SKILL.md ## Validation Checklist |
| Team collaboration              | SKILL.md ## Team Collaboration Best Practices |

---

| Context Condition       | Action                            |
| :---------------------- | :-------------------------------- |
| Creating new hook       | Read SKILL.md Quick Start + Implementation Patterns |
| Team collaboration      | See SKILL.md ## Team Collaboration Best Practices |
| Advanced patterns       | See `references/pattern_advanced.md` |

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

## Continuous Improvement

Review and improve hooks periodically:

1. **Audit**: Run quality framework assessment quarterly
2. **Update**: Incorporate new patterns and best practices
3. **Test**: Add tests for new edge cases discovered
4. **Document**: Update comments and documentation
5. **Refactor**: Remove outdated or redundant hooks

**Note:** Team Collaboration Best Practices are now in SKILL.md to ensure agents don't skip them.
