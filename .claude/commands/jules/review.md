---
name: jules:review
description: Delegate component review to Jules (async, ~10min). Creates PR with suggestions for: portability, quality, patterns. Use when: reviewing complex skills, validating before merge, getting second opinion.
argument-hint: [component-path or "auto" to detect recent]
---

# Jules Component Review

<mission_control>
<objective>Create asynchronous Jules session for comprehensive component review with PR generation</objective>
<success_criteria>Session created with ID/URL returned, Jules creates review PR with findings and fixes</success_criteria>
</mission_control>

Creates an asynchronous Jules session to review a component for portability, quality standards, and best practices.

## Usage

```
# Auto-detect recent component
/jules:review

# Review specific skill
/jules:review .claude/skills/invocable-development

# Review specific command
/jules:review .claude/commands/toolkit/audit

# Review with custom focus
/jules:review .claude/skills/my-skill "Focus on test coverage and runnable examples"
```

## Context Inference

### Auto-Detection Priority

1. **No argument**: Auto-detect recent component
   - `Grep: "\.md\|\.SKILL" conversation history` - Check for recent .md operations
   - `Glob: commands/**/*.md skills/*/SKILL.md` - Sort by mtime → Target most recent
   - If found → Auto-target that component

2. **Path argument**: Target that specific path
   - Validates path exists
   - Determines component type (skill/command/agent)

3. **Custom prompt**: Third argument becomes review focus
   - Overrides default review prompt
   - Provides targeted review criteria

## What Jules Checks

1. **Portability Compliance** (CRITICAL)
   - Zero `.claude/rules` dependencies
   - No external path references
   - Self-contained genetic code
   - Works in isolation

2. **Frontmatter Validation** (HIGH)
   - Valid `name` format (kebab-case for commands)
   - Valid `description` (third-person, no skill name mentions)
   - Required fields present
   - No deprecated fields

3. **Progressive Disclosure Structure** (HIGH)
   - Tier 1: Metadata (~100 tokens)
   - Tier 2: Core content (1.5k-2k words)
   - Tier 3: References/ (on-demand)
   - Proper use of XML vs Markdown

4. **Quality Standards** (MEDIUM)
   - Examples are correct and runnable
   - No AI slop (unnecessary comments)
   - Clear imperative voice
   - Accurate type information

5. **Best Practices** (LOW)
   - Semantic anchoring present
   - Success criteria defined
   - Error handling documented
   - Edge cases covered

## Implementation

### Step 1: Detect Component

```bash
# If no argument, find most recent component
if [[ -z "$COMPONENT" ]]; then
  COMPONENT=$(find .claude/commands .claude/skills -name "*.md" -type f -not -path "*/references/*" -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
fi
```

### Step 2: Create Jules Session

```bash
# Get repo info
OWNER=$(git config --get remote.origin.url | sed -E 's/.*github.com[:/]//; s/\.git$//' | cut -d'/' -f1)
REPO=$(git config --get remote.origin.url | sed -E 's/.*github.com[:/]//; s/\.git$//' | cut -d'/' -f2)

# Default review prompt
DEFAULT_PROMPT="Review this component for the Seed System. Check:
1. Portability: Zero .claude/rules dependencies, no external paths
2. Frontmatter: Valid name/description format, required fields
3. Structure: Progressive disclosure (metadata → core → references)
4. Quality: Examples are runnable, no AI slop, clear imperative voice
5. Standards: Meets quality-standards skill criteria

Create a PR with your findings and suggested fixes."

PROMPT="${CUSTOM_PROMPT:-$DEFAULT_PROMPT}"

# Create session
python .claude/skills/jules-api/jules_client.py create \
  "$PROMPT" \
  "$OWNER" \
  "$REPO" \
  "$(git branch --show-current)" \
  --automation-mode "AUTO_CREATE_PR"
```

### Step 3: Return Session Info

```bash
✅ Created Jules session
📊 Session ID: 1234567890
🔗 URL: https://jules.google.com/session/1234567890
⏱️  Expected completion: ~10 minutes

Monitor with:
  curl https://jules.googleapis.com/v1alpha/sessions/1234567890 \
    -H "X-Goog-Api-Key: $JULES_API_KEY"

Or use:
  /jules:status 1234567890
```

## Output Format

```
✅ Jules review session created

Component: .claude/skills/invocable-development
Review Focus: Full component audit
Session ID: 1234567890
Session URL: https://jules.google.com/session/1234567890
State: QUEUED
Created: 2026-01-28T20:55:00Z

⏱️  Expected completion: ~10 minutes
📧 Jules will create a PR with review findings

Monitor with:
  /jules:status
  /jules:status 1234567890

When complete, Jules will create PR with:
  - Review findings by severity
  - Suggested fixes for violations
  - Improved examples if needed
  - Documentation updates
```

## Example Sessions

### Example 1: Auto-Detect and Review

```
User: /jules:review

Claude: Detected recent component: .claude/skills/quality-standards/SKILL.md
      Creating Jules review session...

      ✅ Jules review session created

      Component: .claude/skills/quality-standards
      Session ID: 9876543210
      URL: https://jules.google.com/session/9876543210

      Monitor: /jules:status 9876543210
```

### Example 2: Targeted Review

```
User: /jules:review .claude/commands/toolkit/audit "Focus on portability"

Claude: Creating Jules session for .claude/commands/toolkit/audit.md
      Review focus: Portability compliance only

      ✅ Session created: 1234567890
      🔗 https://jules.google.com/session/1234567890
```

### Example 3: Review After Changes

```
User: Just finished updating invocable-development skill
      /jules:review .claude/skills/invocable-development

Claude: Creating review session for invocable-development...

      ✅ Session created: 1111111111
      ⏱️  Jules will check all portability requirements
      📧 PR expected in ~10 minutes
```

## Related Commands

- `/jules:status` - Check session progress
- `/toolkit:audit` - Synchronous local audit
- `/jules:improve` - Get AI-suggested improvements
- `/qa/code-review` - Local security and quality review

## Notes

- Sessions run asynchronously (~10 min typical)
- Jules creates PR when review is complete
- You can continue other work while Jules reviews
- Use `/jules:status` to monitor progress
- Comment on PR to iterate with Jules (auto-resume feature)

<critical_constraint>
MANDATORY: Always verify Jules PR before merging
MANDATORY: Check that suggested fixes don't introduce new issues
MANDATORY: Test any code changes in PR
</critical_constraint>
