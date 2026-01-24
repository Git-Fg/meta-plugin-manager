---
name: create-skill
description: "Create new skills with proper structure and validation. Use when scaffolding skills, adding capabilities. Arguments: name, description, context."
user-invocable: true
---

# Create Skill

Scaffolds new skills with proper YAML structure and validation templates.

## Usage

```bash
Skill("create-skill", args="name=my-skill description='Analyze data files. Use when processing CSV data. Not for real-time data.' context=regular")
```

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

The scripts are located in `scripts/` directory and can be executed directly:

```bash
# Via factory skill (recommended)
Skill("create-skill", args="name=my-skill description='My skill'")

# Direct script execution (for testing)
bash .claude/skills/create-skill/scripts/scaffold_skill.sh \
    --name my-skill \
    --description "My skill description"
```

## Completion Marker

## CREATE_SKILL_COMPLETE
