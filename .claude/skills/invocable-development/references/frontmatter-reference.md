# Command Frontmatter Reference

**For complete field specifications, fetch the official documentation:**

```bash
curl -s https://code.claude.com/docs/en/skills.md
```

This reference contains only unique Seed System conventions not covered in official docs.

---

## Naming Conventions

Use consistent naming patterns for command files:

| Pattern       | Example                      | When to Use            |
| ------------- | ---------------------------- | ---------------------- |
| verb-noun     | `deploy-app`, `review-pr`    | Action + target        |
| verb-object   | `generate-docs`, `fix-issue` | Action + result        |
| analysis-noun | `analyze-performance`        | Investigation commands |

**Best practices:**

- Use kebab-case (lowercase with hyphens)
- Keep names 2-4 words
- Include action verb for clarity
- Make purpose clear from name

**Avoid:**

- Generic names: `do-something`, `run-command`
- Overly long: `generate-documentation-for-api-endpoints`
- Ambiguous: `process` (process what?)

---

## Validation

### Common Errors

**Invalid YAML syntax:**

```yaml
---
description: Missing quote
allowed-tools: Read, Write
model: sonnet
--- # ❌ Missing closing quote above
```

**Fix:** Validate YAML syntax

**Incorrect tool specification:**

```yaml
allowed-tools: Bash # ❌ Missing command filter
```

**Fix:** Use `Bash(git:*)` format

**Invalid model name:**

```yaml
model: gpt4 # ❌ Not a valid Claude model
```

**Fix:** Use `sonnet`, `opus`, or `haiku`

### Validation Checklist

Before committing command:

- [ ] YAML syntax valid (no errors)
- [ ] Description under 60 characters
- [ ] allowed-tools uses proper format
- [ ] model is valid value if specified
- [ ] argument-hint matches positional arguments
- [ ] disable-model-invocation used appropriately
