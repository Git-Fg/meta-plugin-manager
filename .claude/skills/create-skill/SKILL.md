---
name: create-skill
description: "Create new skills with proper structure and validation. Use when scaffolding skills, adding capabilities. Arguments: name, description, context."
user-invocable: true
---

# Create Skill

Scaffolds new skills with proper YAML structure and validation templates.

## Usage

Invoke this factory skill to create a new skill with proper YAML structure. Specify the skill name (kebab-case), a What-When-Not description, and optionally the context type (regular or fork).

### Arguments

| Argument | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `name` | string | Yes | - | Skill name (kebab-case) |
| `description` | string | Yes | - | What-When-Not format description |
| `context` | string | No | regular | Context type: regular or fork |
| `force` | boolean | No | false | Overwrite if exists |

## Output

Creates `.claude/skills/<name>/SKILL.md` with:
- Valid YAML frontmatter
- Proper description format (What-When-Not)
- Template content structure
- Optional references/ directory

## Scripts

- **scaffold_skill.sh**: Main scaffolding script (200-300 lines)
- **validate_structure.sh**: Validates YAML structure

## Script Execution

The scripts are located in `scripts/` directory and can be executed directly for testing:

```bash
# Direct script execution (for testing)
bash .claude/skills/create-skill/scripts/scaffold_skill.sh \
    --name my-skill \
    --description "My skill description"
```

## Completion Marker

## CREATE_SKILL_COMPLETE
