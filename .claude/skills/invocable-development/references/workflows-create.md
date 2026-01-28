# Skill Creation Workflow

This workflow details the process of creating portable, self-sufficient skills following the Seed System architecture.

---

## Phase 1: Requirements Gathering

Analyze the request to extract:

### Skill Type

- **Workflow skill**: Executes multi-step processes (e.g., `tdd-workflow`)
- **Knowledge skill**: Provides domain expertise (e.g., `backend-patterns`)
- **Context skill**: Manages session state (e.g., `memory-persistence`)

### Domain Expertise

- What specialized knowledge does this skill contain?
- What patterns or best practices does it teach?
- What problems does it solve?

### Complexity Level

- **Simple**: Single workflow, minimal references
- **Moderate**: Multiple workflows, some references
- **Complex**: Multiple workflows, extensive references, scripts

### Integration Requirements

- Does it need to invoke other skills/commands?
- Does it need `context: fork` for isolation?
- Any special tool requirements?

---

## Phase 2: Structure Design

Create skill directory structure:

```
skill-name/
├── SKILL.md                    # Main content (~1500-2000 words)
├── workflows/                  # If multiple flows needed
│   ├── workflow-1.md
│   └── workflow-2.md
├── references/                 # If detailed content needed
│   ├── topic-1.md
│   └── topic-2.md
└── scripts/                    # If automation needed
    └── script.sh
```

**Progressive disclosure rules:**

- SKILL.md: Core content only (~1500-2000 words max)
- workflows/: Multiple execution flows
- references/: Detailed documentation (on-demand loading)

---

## Phase 3: Content Generation

Generate SKILL.md with UHP-compliant structure:

### Frontmatter

```yaml
---
name: skill-name
description: "What the skill does. Use when [trigger condition]."
---
```

### UHP Header (MANDATORY)

```markdown
# Skill Name

<mission_control>
<objective>[What this skill achieves]</objective>
<success_criteria>[How to verify success]</success_criteria>
</mission_control>

<trigger>When [specific condition]. Not for: [exclusion cases].</trigger>

<interaction_schema>
[State flow for reasoning tasks]
</interaction_schema>
```

### Body Content

- Core concepts and patterns
- Usage instructions
- Examples (working, not pseudo-code)
- Progressive disclosure (keep main content lean)

### UHP Footer (MANDATORY)

```markdown
---

<trigger>When [specific condition]</trigger>

<critical_constraint>
MANDATORY: [Non-negotiable rule 1]
MANDATORY: [Non-negotiable rule 2]
No exceptions.
</critical_constraint>
```

---

## Phase 4: Quality Validation

Verify skill meets standards:

### Portability Check

- [ ] Zero external dependencies (no .claude/rules required)
- [ ] Self-contained (all necessary context included)
- [ ] Works in isolation (can be moved to any project)

**CRITICAL for `context: fork` skills:**

- [ ] Philosophy bundle included (forked skills lose .claude/rules access)
- [ ] Bundle contains critical behavioral rules only
- [ ] Skill would work correctly in project with ZERO .claude/rules

See `advanced-execution.md` - "Philosophy Bundles" section for implementation details.

### UHP Compliance

- [ ] `<mission_control>` present with objective and success_criteria
- [ ] `<trigger>` defines when to use
- [ ] `<critical_constraint>` at bottom with non-negotiable rules
- [ ] Recency bias respected (constraints at footer)

### Progressive Disclosure

- [ ] SKILL.md under 2000 words (if possible)
- [ ] Detailed content moved to references/
- [ ] Navigation table provided for references

### Autonomy Check

- [ ] Clear instructions (no "you/your")
- [ ] Concrete patterns and examples
- [ ] Decision criteria provided
- [ ] Target: 80-95% autonomy (0-5 AskUserQuestion rounds per session)

### Description Quality

- [ ] Third-person voice
- [ ] What-When-Not format
- [ ] No skill/command name references
- [ ] Clear and actionable

---

## Phase 5: Testing

Test the skill:

1. **Invoke with explicit trigger**
2. **Verify auto-invoke works**
3. **Check portability** (would work without .claude/rules)
4. **Measure autonomy** (how many questions asked?)

---

## Success Criteria

- Skill created with proper UHP structure
- Portability invariant maintained
- Progressive disclosure in place
- Autonomy target met (80-95%)
- Description follows What-When-Not format
