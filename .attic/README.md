# Archived Skills

This directory contains skills that have been deprecated and merged into new centralized skills.

---

## Archived Skills

### 1. `refining-claude-md`

**Original Purpose**: Refine and optimize CLAUDE.md files using Delta Standard

**Replaced By**: `claude-md-manager`

**Migration Date**: 2026-01-23

**Reason for Deprecation**: Merged into centralized CLAUDE.md management skill with context-aware workflows

**Key Features Lost**:
- Delta Standard methodology
- Quality framework (5 dimensions)
- Modularization to .claude/rules/

**New Location**: See `.claude/skills/claude-md-manager/` for all merged functionality

---

### 2. `claude-md-improver`

**Original Purpose**: Audit and improve CLAUDE.md files with quality assessment

**Replaced By**: `claude-md-manager`

**Migration Date**: 2026-01-23

**Reason for Deprecation**: Merged into unified skill with context detection

**Key Features Lost**:
- Quality assessment rubric (6 criteria)
- Targeted update methodology
- Project type templates

**New Location**: See `.claude/skills/claude-md-manager/` for all merged functionality

---

## Migration Summary

Both skills have been merged into **`claude-md-manager`**, which provides:

### Enhanced Features

1. **Context-Aware Mode Detection**
   - CREATE: Empty projects → Investigation and creation
   - ACTIVE-LEARN: Mid-conversation → Learning integration
   - REFACTOR: Messy files → Optimization and modularization
   - AUDIT: Good files → Assessment only

2. **Unified Quality Framework**
   - 11-dimensional scoring system
   - Merged from both original skills
   - Production threshold: 80/100

3. **Active Learning Integration**
   - Captures conversation insights
   - Integrates discoveries into CLAUDE.md
   - Creates feedback loop for continuous improvement

4. **Smart Routing**
   - Auto-detects appropriate workflow
   - Routes through toolkit-architect
   - Context-based decision making

### Benefits

- **Reduced Complexity**: One skill instead of two
- **Better UX**: Auto-detection of user intent
- **Higher Quality**: Unified scoring framework
- **More Value**: Active learning capabilities

---

## How to Migrate

### If you were using `refining-claude-md`

**Old**:
```bash
/refining-claude-md audit
/refining-claude-md refine
/refining-claude-md modularize
```

**New**:
```bash
/claude-md-manager
# Auto-detects mode and executes appropriate workflow

# Or force specific mode:
/claude-md-manager audit
/claude-md-manager refactor
/claude-md-manager create
/claude-md-manager active-learn
```

---

### If you were using `claude-md-improver`

**Old**:
```bash
/claude-md-improver
# Would scan and improve
```

**New**:
```bash
/claude-md-manager
# Auto-detects mode (CREATE/ACTIVE-LEARN/REFACTOR/AUDIT)

# Or use toolkit-architect routing:
/toolkit-architect
# Routes to claude-md-manager for memory issues
```

---

## Compatibility

### Backward Compatibility

❌ **Breaking Changes**:
- Skill name changed (old → new)
- Direct invocation syntax changed
- Some internal quality criteria updated

✅ **Preserved Functionality**:
- All refactoring capabilities
- All quality assessment features
- Delta Standard methodology
- Modularization support

### Migration Path

1. **Replace skill references**:
   - Update scripts/automation that call old skills
   - Update documentation mentioning old skills

2. **Update user training**:
   - Teach new auto-detection capabilities
   - Highlight ACTIVE-LEARN mode benefits

3. **Test workflows**:
   - Verify refactoring produces same quality
   - Check quality scores are consistent

---

## Deprecation Timeline

| Date | Action |
|------|--------|
| 2026-01-23 | Merged into claude-md-manager |
| 2026-01-23 | Archived to .attic/ |
| 2026-04-23 | Planned removal (3 months) |

**Note**: Skills remain in .attic/ for 3 months for rollback capability

---

## Rollback Procedure

If you need to rollback:

```bash
# Restore old skills
cp -r .attic/refining-claude-md .claude/skills/
cp -r .attic/claude-md-improver .claude/skills/

# Remove new skill
rm -rf .claude/skills/claude-md-manager
```

**Warning**: Rollback not recommended - new skill provides superior functionality

---

## References

- **New Skill**: `.claude/skills/claude-md-manager/SKILL.md`
- **Documentation**: `.claude/skills/claude-md-manager/references/`
- **Examples**: `.claude/skills/claude-md-manager/examples/`

---

## Contact

For issues with the migration, please open an issue in the repository.
