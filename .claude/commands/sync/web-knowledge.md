---
description: "Fetch web content and sync relevant findings to skills. Use when external documentation, best practices, or examples could enhance existing skills. Not for simple URL bookmarking."
argument-hint: [url] [--depth=N]
---

# Sync Web Knowledge to Skills

<mission_control>
<objective>Fetch external content and enhance skills with current best practices, examples, and patterns</objective>
<success_criteria>Matched skills identified, relevant changes proposed, user approves diffs before applying</success_criteria>
</mission_control>

## Workflow

### 1. Detect

Fetch source URL and analyze content:

**Input**: URL from `$ARGUMENTS` (extract before `--depth`)

1. Use `mcp__simplewebfetch__simpleWebFetch` to get raw markdown content
2. Use `mcp__simplewebfetch__fullWebFetch` to get metadata (title, timestamp)
3. Parse URL for base domain and path structure

**Validate**:

- Protocol is http/https only
- URL is not private IP (localhost, 10.x, 192.168.x, etc.)

### 2. Ask

Crawl related URLs (if `--depth=N` flag provided) and get user confirmation:

**Crawl** (trigger: `--depth=N`, default: 0, max: 3):

1. Use `mcp__simplewebfetch__crawlWebFetch` to discover related URLs
2. Limit crawl to `(N + 2)` levels (user depth + 2 for comprehensive coverage)
3. Filter for high-value pages (documentation, examples, guides)

**Crawl constraints**:

- `maxChars`: 500000 (max)
- `maxConcurrency`: 3
- `respectRobots`: true

**User confirmation** (Phase 6 in original):

Present proposed changes with:

- Affected skills (list with scores)
- Change types (enhance/refine/replace per skill)
- Rationale (why each change matters)

Use `AskUserQuestion` for confirmation.

### 3. Execute

Analyze content and match skills:

**Analyze Content** (original Phase 3):

Use `mcp__simplewebfetch__askWebFetch` to identify:

1. **Best Practices**: Patterns, conventions, approaches
2. **Code Examples**: Working code snippets, templates
3. **Anti-Patterns**: What to avoid, common mistakes
4. **Update Signals**: Information that conflicts with existing docs
5. **Skill Topics**: What skills this content relates to

**Match Skills** (original Phase 4):

1. `Glob: .claude/skills/*/SKILL.md`
2. Extract keywords from fetched content
3. `Grep` for matches in skill descriptions and content

**Propose Changes** (original Phase 5):

For each matched skill (score >= 3):

- **Enhance**: Append new section, add example
- **Refine**: Update specific paragraphs, correct outdated info
- **Replace**: Rewrite section with new content

### 4. Verify

Apply changes (original Phase 7) and confirm success:

For each approved change:

1. **Read** the target skill file
2. **Edit** to apply the diff (Enhance: append, Refine: replace, Replace: rewrite)
3. **Save** the file
4. **Verify** syntax is valid

**Success Criteria**:

- Source URL fetched successfully
- Crawl completed (if depth > 0)
- Content analyzed for best practices, examples, anti-patterns
- Skills matched with relevance scores (threshold >= 3)
- Diffs generated for each matched skill
- User confirmation obtained before applying
- Changes applied cleanly (if approved)
- No regressions introduced

## Usage Patterns

**Simple fetch (no crawl)**:

```
/sync:web-knowledge https://docs.example.com/api-guide
```

**Fetch with light crawl**:

```
/sync:web-knowledge https://docs.example.com --depth=1
```

**Deep crawl for comprehensive sync**:

```
/sync:web-knowledge https://docs.example.com/reference --depth=2
```

<critical_constraint>
MANDATORY: Present proposed changes to user BEFORE applying any modifications

MANDATORY: Crawl depth capped at 3 levels maximum

MANDATORY: Respect robots.txt (respectRobots: true)

MANDATORY: Only apply changes after explicit user approval

No exceptions. User must validate all content before skill modification.
</critical_constraint>
