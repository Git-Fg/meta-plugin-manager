---
description: "List all available skills with their names and descriptions. Use when user asks to list skills, show all skills, or see what skills are available."
---

<mission_control>
<objective>List all available skills with names, descriptions, and usage guidance</objective>
<success_criteria>Skill inventory displayed with names, descriptions, and statistics</success_criteria>
</mission_control>

# Skills Inventory

List all available skills in the project.

## All Skills

| Skill                                          | Description |
| ---------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | ----------------------- | ----------------------------------------------------------------------------- | ------ | --- | -------------------------------- |
| !`find .claude/skills -name "SKILL.md" -type f | sort        | while read skill; do dir=\$(dirname "\$skill"); name=\$(basename "\$dir"); desc=\$(sed -n '/^description:/s/^description: \*//p' "\$skill" 2>/dev/null | head -1 | sed 's/^"\(.\*\)"$/\1/' | sed 's/^[[:space:]]_//;s/[[:space:]]_$//'); if [ -n "\$desc" ]; then printf " | **%s** | %s  | \n" "\$name" "\$desc"; fi; done` |

## Usage

To use a skill, invoke it by name:

- `/skill-name` for user-invocable skills
- Skills are automatically loaded when relevant to the task

## Skill Statistics

!`echo "Total skills: \$(find .claude/skills -name "SKILL.md" -type f | wc -l | tr -d ' ')"`

---

**Tip**: Use `/explore .claude/skills/skill-name` to analyze a specific skill in detail.

<critical_constraint>
MANDATORY: Display skills with names, descriptions, and statistics
MANDATORY: Provide usage guidance for skill invocation
No exceptions. Skills inventory must be comprehensive and up-to-date.
</critical_constraint>
