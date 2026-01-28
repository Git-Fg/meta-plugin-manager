---
name: jules:docsync
description: Sync CLAUDE.md and architecture docs with latest component changes. Updates skill lists, pattern references, and architectural decisions. Use when: components added/removed, patterns changed, documentation drift detected.
argument-hint: [--dry-run] [--section <name>]
---

# Jules Documentation Sync

<mission_control>
<objective>Automatically synchronize project documentation with current component state using Jules</objective>
<success_criteria>Documentation files updated with latest component changes, PR created for review</success_criteria>
</mission_control>

Keep project documentation (CLAUDE.md, architecture docs) synchronized with codebase changes using Jules.

## Usage

```
# Sync all documentation
/jules:docsync

# Dry run to see what would change
/jules:docsync --dry-run

# Sync specific section only
/jules:docsync --section skills
/jules:docsync --section architecture
/jules:docsync --section changelog

# Force full sync (skip change detection)
/jules:docsync --force
```

## What Syncs

### 1. CLAUDE.md

**Updates**:

- **Skill List**: Add new skills, remove deleted ones
- **Command List**: Update available commands
- **Agent List**: Reflect current agents
- **New Features**: Document recently added capabilities
- **Quick Navigation**: Update file listings

**Example Changes**:

```markdown
## Quick Navigation

### For Component Factory (Building Offspring)

- `/toolkit:build:command` - Create one-file commands
- `/toolkit:build:skill` - Create skills with workflows/
- `/jules:review` - Async AI component review (NEW)
- `/jules:improve` - AI-suggested improvements (NEW)

### For Health Maintenance (Current Session)

- `/ops:drift` - Detect and fix context drift
- `/ops:reflect` - Review session for improvements
```

### 2. architecture.md

**Updates**:

- **New Patterns**: Document recently added patterns
- **Updated Structures**: Reflect current directory layouts
- **New Tag Formats**: Semantic anchoring examples
- **Workflow Changes**: Updated interaction patterns

**Example Changes**:

```markdown
## Semantic Anchoring Pattern (UPDATED Jan 2026)

Components now use semantic XML anchors for robust parsing:

<semantic>
  <role>Factory Layer</role>
  <target>command creation</target>
</semantic>
```

### 3. quality.md

**Updates**:

- **New Validation Rules**: Recent quality checks
- **Updated Anti-patterns**: Newly discovered issues
- **Recognition Questions**: Updated detection queries
- **Verification Protocols**: New verification steps

### 4. Changelog

**Updates**:

- **Recent Updates**: Add latest feature additions
- **Bug Fixes**: Document fixes and improvements
- **Breaking Changes**: Note any breaking API changes
- **Migration Guides**: Update for new patterns

## Implementation

### Step 1: Detect Changes

```python
# Get current state of components
skills = glob('.claude/skills/*/SKILL.md')
commands = glob('.claude/commands/**/*.md')
agents = glob('.claude/agents/*/AGENT.md')

# Get last sync timestamp (from .claude/.last-docsync)
last_sync = datetime.fromisoformat(open('.claude/.last-docsync').read())

# Find components modified since last sync
modified = []
for component in skills + commands + agents:
    mtime = datetime.fromtimestamp(os.path.getmtime(component))
    if mtime > last_sync:
        modified.append(component)
```

### Step 2: Create Jules Session

```bash
# Build prompt for Jules
PROMPT="Sync documentation with latest component changes.

Components modified since last sync:
$(echo "${modified[@]}")

For CLAUDE.md:
1. Update skill/command lists to reflect current state
2. Add new features/capabilities to Quick Navigation
3. Update any version numbers or dates
4. Maintain existing structure and tone

For architecture.md:
1. Document any new patterns or structures
2. Update examples with current formats
3. Add new tag formats if applicable

For quality.md:
1. Add new validation rules or anti-patterns
2. Update recognition questions
3. Document new verification protocols

Create a PR with the documentation updates."

# Create session
SESSION=$(python .claude/skills/jules-api/jules_client.py create \
  "$PROMPT" \
  "$OWNER" \
  "$REPO" \
  "$(git branch --show-current)" \
  --automation-mode "AUTO_CREATE_PR")

echo "✅ Created Jules session: $SESSION"
```

### Step 3: Update Last Sync

```bash
# After successful sync, update timestamp
date -u +"%Y-%m-%dT%H:%M:%SZ" > .claude/.last-docsync
```

## Output Format

### Dry Run

```
🔍 Documentation Sync: Dry Run

Components modified since last sync (2026-01-27T10:00:00Z):

  NEW:
    📄 .claude/commands/jules/review.md
    📄 .claude/commands/jules/improve.md
    📄 .claude/commands/jules/status.md
    📄 .claude/commands/jules/docsync.md

  MODIFIED:
    📄 .claude/skills/jules-api/SKILL.md
    📄 CLAUDE.md

Documentation updates needed:
  ✓ CLAUDE.md - Add 4 new commands to jules namespace
  ✓ CLAUDE.md - Update Quick Navigation with new features
  ✓ architecture.md - Document Jules integration patterns
  ✓ quality.md - Add validation for async commands

Estimated effort: ~15 minutes for Jules to complete

Create sync session? [y/n]
```

### Actual Sync

```
🔄 Creating Jules documentation sync session...

Changes detected:
  - 4 new commands added
  - 2 files modified
  - 2 components deleted

✅ Jules session created: 1234567890
📊 URL: https://jules.google.com/session/1234567890
⏱️  Expected completion: ~10 minutes

Jules will:
  1. Scan all component files
  2. Update CLAUDE.md with new commands
  3. Update architecture.md with Jules patterns
  4. Create PR with all documentation updates

Monitor with: /jules:status 1234567890
```

### Completion

```
✅ Documentation sync complete!

Session: 1234567890
State: COMPLETED
PR: https://github.com/MiaouLeChat929/thecattoolkit_v3/pull/126

Changes:
  ✓ CLAUDE.md - Added jules namespace commands
  ✓ CLAUDE.md - Updated Quick Navigation
  ✓ architecture.md - Added Jules integration section
  ✓ quality.md - Added async command validation

Updated last-docsync timestamp: 2026-01-28T21:00:00Z
```

## Section-Specific Sync

### Sync Skills Only

```bash
/jules:docsync --section skills
```

Updates:

- Skill list in CLAUDE.md
- Skills index in architecture.md
- Skill-related validation rules

### Sync Commands Only

```bash
/jules:docsync --section commands
```

Updates:

- Command list in CLAUDE.md
- Command patterns in architecture.md
- Command-related workflows

### Sync Architecture Only

```bash
/jules:docsync --section architecture
```

Updates:

- Pattern documentation
- Structure examples
- Tag format references

## Automatic Triggers

Consider setting up automatic docsync:

### Option 1: Git Hook (Recommended)

```bash
# .git/hooks/post-commit
#!/bin/bash
# Run docsync if documentation files changed
if git diff --name-only HEAD~1 HEAD | grep -E "CLAUDE\.md|\.claude/(skills|commands|agents)/"; then
    echo "📚 Documentation changes detected. Run: /jules:docsync"
fi
```

### Option 2: Scheduled (via Jules)

```
Schedule: Weekly (Sundays 2am)
Prompt: Run full documentation sync to ensure docs stay synchronized with weekly development changes
```

## Example Sessions

### Example 1: Full Sync After Major Changes

```
User: Just finished adding the jules namespace commands
      /jules:docsync

Claude: 🔍 Detecting documentation changes...

      Found 5 new commands in .claude/commands/jules/
      Found 1 modified skill (.claude/skills/jules-api/)

      Changes to apply:
        ✓ CLAUDE.md - Add jules namespace (4 commands)
        ✓ CLAUDE.md - Update Quick Navigation
        ✓ CLAUDE.md - Document new async capabilities
        ✓ architecture.md - Document Jules integration patterns
        ✓ quality.md - Add validation for async commands

      Create sync session? [y/n] > y

      ✅ Jules session created: 1234567890
      📊 Monitor: https://jules.google.com/session/1234567890
```

### Example 2: Dry Run Before Sync

```
User: /jules:docsync --dry-run

Claude: 🔍 Documentation Sync: Dry Run

      No changes needed - documentation is up to date!

      Last sync: 2026-01-28T20:00:00Z
      Current state: All components documented
```

### Example 3: Sync After Component Deletion

```
User: /jules:docsync

Claude: 🔍 Detecting changes...

      DELETED:
        📄 .claude/skills/deprecated-skill (removed)
        📄 .claude/commands/old-command.md (removed)

      Updates needed:
        ✓ CLAUDE.md - Remove from skill/command lists
        ✓ architecture.md - Remove related patterns
        ✓ quality.md - Remove related validation rules

      Create sync session? [y/n] > y

      ✅ Session created: 9876543210
      Jules will update docs and create PR
```

## Related Commands

- `/jules:review` - Review component before syncing docs
- `/learning:update-docs` - Manual documentation update
- `/ops:drift` - Detect documentation drift
- `/toolkit:audit` - Validate component before documenting

## Notes

- Documentation sync runs asynchronously (~10 min)
- Jules creates PR with all changes for review
- Always review generated docs before merging
- Use `--dry-run` to preview changes
- Last sync timestamp stored in `.claude/.last-docsync`

<critical_constraint>
MANDATORY: Review Jules-generated documentation for accuracy
MANDATORY: Verify all new commands/skills are properly documented
MANDATORY: Check that no sensitive information is included
MANDATORY: Test all examples in generated docs
</critical_constraint>
