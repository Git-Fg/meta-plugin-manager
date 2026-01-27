---
description: "List all skills in the project with their names and descriptions. Use when: user mentions 'list skills', 'show all skills', 'what skills are available', needs to see skill inventory."
disable-model-invocation: true
---

# Skills Inventory

List all available skills in the project.

## All Skills

| Skill | Description |
|-------|-------------|
!`find .claude/skills -name "SKILL.md" -type f | sort | while read skill; do dir=\$(dirname "\$skill"); name=\$(basename "\$dir"); desc=\$(sed -n '/^description:/s/^description: *//p' "\$skill" 2>/dev/null | head -1 | sed 's/^"\(.*\)"$/\1/' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'); if [ -n "\$desc" ]; then printf "| **%s** | %s |\n" "\$name" "\$desc"; fi; done`

## Usage

To use a skill, invoke it by name:
- `/skill-name` for user-invocable skills
- Skills are automatically loaded when relevant to the task

## Skill Statistics

!`echo "Total skills: \$(find .claude/skills -name "SKILL.md" -type f | wc -l | tr -d ' ')"`

---

**Tip**: Use `/explore .claude/skills/skill-name` to analyze a specific skill in detail.
