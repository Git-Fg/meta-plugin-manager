# Implementation Patterns

**Generic patterns applicable across all components. Component-specific patterns live in their respective meta-skills.**

---

## Writing Style

### Imperative/Infinitive Form (Low Freedom)

Skill content uses strict imperative/infinitive form with NO second person.

**Use this pattern**: Content that requires specific, deterministic execution.

**Examples:**
- Execute before any tool runs
- Parse the YAML frontmatter using sed
- Configure the MCP server with authentication
- Validate file write safety

**Avoid:**
- You should create a hook
- You need to validate settings
- You can use the grep tool

**Recognition**: If writing "you/your", switch to imperative form.

**Rationale**: Imperative form reduces token count while maintaining clarity. Second person adds unnecessary words.

---

## Cross-Reference Patterns

### Project Portability

Skills can reference other skills using project-relative paths.

**For local projects**: Use paths relative to project root or `${CLAUDE_PROJECT_DIR}`

**For plugins/distribution**: Use `${CLAUDE_PLUGIN_ROOT}` for portability

**Dual-mode pattern** (works in both contexts):
```bash
BASE_DIR="${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"
```

```markdown
See [plugin-dev skills](../../../official_example_skills/) for complete examples.
```

**Recognition**: "Will this work in both local and plugin contexts?"

---

### Progressive Disclosure Structure

Information architecture as cognitive load management. Reveal complexity progressively.

### Three Levels

**Tier 1: Metadata** (~100 tokens, always loaded)
- Frontmatter: `name`, `description`
- Purpose: Trigger discovery, convey WHAT/WHEN/NOT
- Recognition: This is Claude's first impression - make it count

**Tier 2: SKILL.md** (400-450 lines max, loaded on activation)
- Core implementation with workflows and examples
- Purpose: Enable task completion
- Recognition: If approaching 450 lines, move content to Tier 3

**Tier 3: References/** (on-demand, loaded when needed)
- Deep details, troubleshooting, comprehensive guides
- Purpose: Specific use cases without cluttering Tier 2
- Recognition: Create only when SKILL.md + references >500 lines total

### Pattern Recognition

**Pattern 1: High-level guide with references**
```markdown
## Quick start
[Basic usage]
## Advanced features
- **Feature X**: See [X.md](X.md) for complete guide
```

**Pattern 2: Domain-specific organization**
```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

**Pattern 3: Conditional details**
```markdown
Basic content here.
**For advanced**: See [ADVANCED.md](ADVANCED.md)
```

**Recognition**: If SKILL.md is bloated with domain-specific or situational content, split it into references/.

---

### Reference File Anti-Pattern

Reference files (Tier 3, in `references/` directories) should never contain instructions about when to read themselves.

**Anti-pattern**:
```markdown
# Executable Command Examples

**Load this file when you need to see actual working command examples.**

This reference contains...
```

**Why it fails**: The reader has already loaded the file. Telling them "when to read" what they're already reading is redundant and creates circular logic.

**Correct pattern - SKILL.md (Tier 2)**:
```markdown
## Navigation

| If you are... | You MUST read... |
|---------------|------------------|
| Creating commands | `references/executable-examples.md` |
| Configuring frontmatter | `references/frontmatter-reference.md` |

## Bash Execution

Commands can inject bash output using exclamation mark followed by command in backticks.

**You MUST read `references/executable-examples.md` before writing commands.**
```

**Correct pattern - Reference file (Tier 3)**:
```markdown
# Executable Command Examples

This reference contains complete, executable command examples using real syntax.

[Content only - no meta-instructions about when to read]
```

**Recognition**: If a `references/` file starts with "Load this when..." or "Read this for...", remove it.

**Progressive disclosure structure**:
- **Tier 1 (Metadata)**: Frontmatter - always loaded, triggers discovery
- **Tier 2 (SKILL.md)**: Core content + navigation directives pointing to references
- **Tier 3 (references/)**: Deep content only - assumes reader chose to load it

---

## Directory Structure Patterns

### Skill Structure

```
skill-name/
├── SKILL.md              # 400-450 lines max (Tier 2)
├── examples/             # Working code examples (not snippets)
│   ├── working-example.md
│   └── templates/
├── scripts/              # Executable utilities
│   └── validate.sh
└── references/           # Domain-specific organization
    ├── patterns.md       # 8,000-12,000 words
    ├── advanced.md       # 10,000-15,000 words
    └── [domain].md       # Domain-specific deep dives
```

**Key patterns**:
- `examples/` directory with complete, runnable code
- `scripts/` directory with executable utilities
- Domain-specific `references/` organization

**Recognition**: Do I have working examples? Should I split to references/?

---

## Content Organization Patterns

### Single Source of Truth

Each concept should be documented in ONE place, with cross-references from other locations.

**Good pattern**:
- Component-specific patterns live in component's meta-skill
- Generic patterns live in `.claude/rules/patterns.md`
- CLAUDE.md references both

**Anti-pattern**: Same description pattern documented in skill-development, command-development, and patterns.md

**Recognition**: "Is this concept already documented elsewhere?"

---

### Degrees of Freedom

Match specificity to task fragility.

**High Freedom (Text-based Instructions)**
- Use when: Multiple approaches are valid, decisions depend on context
- Characteristics: "Consider X when Y", trust judgment based on context
- Example: "When organizing skills, group by domain if that aids discovery"

**Medium Freedom (Pseudocode or Scripts with Parameters)**
- Use when: A preferred pattern exists, some variation is acceptable
- Characteristics: Suggested structure with flexibility
- Example: "Skill structure: SKILL.md (required), references/ (optional)"

**Low Freedom (Specific Scripts, Few Parameters)**
- Use when: Operations are fragile and error-prone, consistency is critical
- Characteristics: Exact steps to follow, limited configuration
- Example: "Validation requires: 1) Check YAML format, 2) Verify required fields"

**Recognition**: If the operation breaks easily or has high failure risk, reduce freedom.

---

## Recognition Questions

**Writing Style**:
- "Am I using 'you/your'?" → Switch to imperative form
- "Is this instructions or messages?" → Write FOR Claude, not TO user

**Content Organization**:
- "Is this concept documented elsewhere?" → Cross-reference instead
- "Is this component-specific?" → Move to relevant meta-skill
- "Is this generic?" → Keep in rules/

**Progressive Disclosure**:
- "Is SKILL.md approaching 450 lines?" → Move content to references/
- "Do I have working examples?" → Add examples/ directory
- "Is this telling readers when to read what they're already reading?" → Remove meta-instructions

**Teaching > Prescribing**: Patterns enable intelligent adaptation. Process prescriptions create brittle systems.
