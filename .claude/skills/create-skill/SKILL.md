---
name: create-skill
description: "This skill should be used when the user asks to 'create a new skill', 'scaffold a skill', 'add a skill to the project', 'generate skill structure', or needs to set up a new skill with proper YAML frontmatter and validation. Creates skills following the Agent Skills standard with proper progressive disclosure structure."
user-invocable: true
---

# Create Skill

Factory skill for scaffolding new skills with proper structure, YAML frontmatter, and validation.

## Core Principle: Context Window Stewardship

The context window is a shared resource. When creating skills, challenge each piece of information: "Does Claude really need this?" Default assumption: Claude is already very smart—only add context Claude doesn't already have.

## Before Scaffolding

Determine these elements before running the scaffolding scripts:

### 1. Identify Skill Type

| Type | Purpose | Execution Pattern |
|------|---------|-------------------|
| **Knowledge Skill** | Pure reference, no execution | Load for understanding |
| **Factory Skill** | Deterministic execution | Script-based automation |
| **Hybrid Skill** | Guidance + utilities | Mixed approach |

### 2. Define the Description

Write the description in third-person format with explicit trigger phrases:

**Pattern:**
```yaml
description: "This skill should be used when the user asks to '[trigger 1]', '[trigger 2]', '[trigger 3]'. [What it does]."
```

**Good Example:**
```yaml
description: "This skill should be used when the user asks to 'create a hook', 'add a PreToolUse hook', 'validate tool use'. Provides comprehensive hooks API guidance."
```

**Bad Examples:**
```yaml
description: "Use when working with hooks."  # Wrong person, vague
description: "Provides hook guidance."        # No trigger phrases
```

### 3. Plan Resources

Analyze concrete usage examples to determine required resources:

| Resource Type | When to Include | Example |
|---------------|-----------------|---------|
| **scripts/** | Deterministic operations, repeated code | `rotate_pdf.py` |
| **references/** | On-demand documentation | `schema.md`, `api.md` |
| **assets/** | Output templates, images | `template.html`, `logo.png` |

**Example Analysis:**

When building a `pdf-editor` skill for "Help me rotate this PDF":
1. Rotating a PDF requires rewriting the same code each time
2. → Include `scripts/rotate_pdf.py`

When building a `brand-guidelines` skill for "Create a branded document":
1. Brand assets need consistent usage
2. → Include `assets/logo.png`, `references/brand-guide.md`

### 4. Set Degrees of Freedom

Match specificity to task fragility:

| Freedom Level | Use When | Approach |
|---------------|----------|----------|
| **High** | Multiple valid approaches | Text-based instructions |
| **Medium** | Preferred pattern exists | Pseudocode with parameters |
| **Low** | Fragile/error-prone operations | Specific scripts, few parameters |

## Skill Creation Workflow

### Step 1: Scaffold the Structure

Run the scaffolding script with required arguments:

```bash
bash .claude/skills/create-skill/scripts/scaffold_skill.sh \
    --name my-skill \
    --description "This skill should be used when the user asks to..."
```

**Arguments:**

| Argument | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `--name` | string | Yes | - | Skill name (kebab-case) |
| `--description` | string | Yes | - | Third-person description with triggers |
| `--context` | string | No | regular | Context type: regular or fork |
| `--force` | flag | No | false | Overwrite if exists |

### Step 2: Validate Structure

Run validation to check YAML compliance:

```bash
bash .claude/skills/create-skill/scripts/validate_structure.sh \
    .claude/skills/my-skill
```

Validation checks:
- YAML frontmatter format
- Required fields (name, description)
- Description uses third-person format
- Skill naming conventions (kebab-case)
- Directory structure compliance

### Step 3: Populate the Skill

Edit the generated SKILL.md following these guidelines:

**Body Writing Style:** Use imperative/infinitive form throughout:
```markdown
✅ Parse the configuration file.
✅ Validate input before processing.
✅ Extract fields with grep.

❌ You should parse the configuration file.
❌ Claude needs to validate input.
❌ The user can extract fields.
```

**Target Size:** 1,500-2,000 words in SKILL.md body. Move detailed content to references/:
- Detailed patterns → `references/patterns.md`
- Advanced techniques → `references/advanced.md`
- API documentation → `references/api.md`

**Reference Resources Clearly:**
```markdown
## Additional Resources

For detailed patterns, consult:
- **`references/patterns.md`** - Common implementation patterns
- **`references/advanced.md`** - Advanced use cases
```

### Step 4: Add Resources

Create necessary subdirectories and files:

```bash
mkdir -p .claude/skills/my-skill/{scripts,references,assets}
```

**Scripts:** Test all added scripts by running them:
```bash
# Verify script works before committing
bash .claude/skills/my-skill/scripts/utility.sh --help
```

**References:** Keep under 5,000 words per file. Include table of contents for files >100 lines.

### Step 5: Final Validation

Re-run validation after all edits:
```bash
bash .claude/skills/create-skill/scripts/validate_structure.sh \
    .claude/skills/my-skill
```

## What NOT to Include

Do NOT create extraneous files:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- User-facing documentation

The skill should only contain information needed for an AI agent to execute the task.

## Output Structure

The scaffolding creates:

```
.claude/skills/<name>/
├── SKILL.md           # Valid YAML frontmatter + template body
└── references/        # Empty, ready for detailed docs
```

## Progressive Disclosure Compliance

Ensure the created skill follows the three-tier pattern:

| Tier | Content | Size Target |
|------|---------|-------------|
| **1: Metadata** | name + description | ~100 tokens |
| **2: SKILL.md body** | Core procedures | <500 lines, 1,500-2,000 words |
| **3: references/** | Detailed docs | Unlimited per file |

## Common Mistakes to Avoid

### Weak Trigger Description
❌ `description: "Provides guidance for hooks."`
✅ `description: "This skill should be used when the user asks to 'create a hook', 'add a PreToolUse hook'..."`

### Everything in SKILL.md
❌ 8,000 words in a single SKILL.md
✅ 1,800 words in SKILL.md + references/patterns.md (2,500 words)

### Second Person Writing
❌ "You should start by reading the configuration."
✅ "Start by reading the configuration."

### Missing Resource References
❌ References exist but SKILL.md doesn't mention them
✅ Clear "Additional Resources" section linking all references

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/scaffold_skill.sh` | Main scaffolding (creates structure + template) |
| `scripts/validate_structure.sh` | Validates YAML and structure compliance |

## Completion Marker

## CREATE_SKILL_COMPLETE
