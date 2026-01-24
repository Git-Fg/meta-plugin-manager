# Positive Patterns

---

# FOR DIRECT USE

⚠️ **Follow these patterns when building skills and workflows** - proven approaches from official skills and validated frameworks.

## Behavioral Delta Patterns

Content that shapes AI behavior through explicit guidance, rather than relying on inference alone.

### Principle-First Framing

**From official skill-creator (lines 25-46):**

```yaml
# Concise is Key
The context window is a public good. Skills share the context window with everything else Claude needs.

Default assumption: Claude is already very smart. Only add context Claude doesn't already have.

Prefer concise examples over verbose explanations.
```

**Why this works**: Even though Claude "knows" conciseness, stating it explicitly shapes behavior and sets expectations for the entire skill.

### Degrees of Freedom Framework

**From official skill-creator:**

```yaml
# High freedom (text-based instructions)
Use when: multiple approaches are valid, decisions depend on context, heuristics guide approach

# Medium freedom (pseudocode or scripts with parameters)
Use when: preferred pattern exists, some variation acceptable, configuration affects behavior

# Low freedom (specific scripts, few parameters)
Use when: operations are fragile and error-prone, consistency is critical, specific sequence required
```

**Why this works**: Explicitly categorizes task fragility vs. flexibility, guiding AI toward appropriate specificity levels.

### Workflow Decision Trees

**From official docx skill:**

```markdown
### Editing Existing Document
- **Your own document + simple changes**
  Use "Basic OOXML editing" workflow

- **Someone else's document**
  Use "Redlining workflow" (recommended default)

- **Legal, academic, business, or government docs**
  Use "Redlining workflow" (required)
```

**Why this works**: Context-aware branching guides AI to appropriate approach based on document characteristics, not just task type.

---

## Multi-Dimensional Delta Patterns

Project-specific working commands, patterns, and constraints across multiple dimensions.

### Working Commands (Not Generic Instructions)

**Positive pattern** (from official skill-creator):
```bash
# Explicit command with tool specification
scripts/init_skill.py <skill-name> --path <output-directory>

# With concrete output expectations
The script:
- Creates the skill directory at the specified path
- Generates a SKILL.md template with proper frontmatter
- Creates example resource directories
```

**Anti-pattern**: "Create a skill directory" (no tool specification)

### Anatomy Structure Patterns

**From official skill-creator:**

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code
    ├── references/ - Documentation loaded as needed
    └── assets/     - Files used in output
```

**When to use each**:
- **scripts/**: Same code rewritten repeatedly, deterministic reliability needed
- **references/**: Documentation Claude should reference while working (schemas, APIs, policies)
- **assets/**: Files used in final output (templates, images, boilerplate)

### Progressive Disclosure Patterns

**From official skill-creator (lines 128-201):**

**Pattern 1: High-level guide with references**
```markdown
# PDF Processing

## Quick start
Extract text with pdfplumber: [code example]

## Advanced features
- **Form filling**: See [FORMS.md](FORMS.md) for complete guide
- **API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
```

**Pattern 2: Domain-specific organization**
```markdown
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

**Pattern 3: Conditional details**
```markdown
# DOCX Processing

## Creating documents
Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents
For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

**Key principle**: Keep references one level deep from SKILL.md. Structure longer reference files (>100 lines) with table of contents.

---

## Reliability Delta Patterns

Patterns that improve consistency, determinism, and predictable outcomes.

### Sequential Workflows

**From official skill-creator/references/workflows.md:**

```markdown
Filling a PDF form involves these steps:

1. Analyze the form (run analyze_form.py)
2. Create field mapping (edit fields.json)
3. Validate mapping (run validate_fields.py)
4. Fill the form (run fill_form.py)
5. Verify output (run verify_output.py)
```

### Conditional Workflows

**From official skill-creator/references/workflows.md:**

```markdown
1. Determine the modification type:
   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below

2. Creation workflow: [steps]
3. Editing workflow: [steps]
```

### Output Template Patterns

**From official skill-creator/references/output-patterns.md:**

**For strict requirements**:
```markdown
## Report structure

ALWAYS use this exact template structure:

# [Analysis Title]

## Executive summary
[One-paragraph overview of key findings]

## Key findings
- Finding 1 with supporting data
- Finding 2 with supporting data

## Recommendations
1. Specific actionable recommendation
2. Specific actionable recommendation
```

**For flexible guidance**:
```markdown
## Report structure

Here is a sensible default format, but use your best judgment:

# [Analysis Title]

## Executive summary
[Overview]

## Key findings
[Adapt sections based on what you discover]

## Recommendations
[Tailor to the specific context]

Adjust sections as needed for the specific analysis type.
```

### Script Reliability Patterns

**Explicit error handling**:
```bash
# Good: Handle errors with fallbacks
try:
    with open(path) as f:
        return f.read()
except FileNotFoundError:
    print(f"File {path} not found, creating default")
    with open(path, 'w') as f:
        f.write('')
    return ''
```

**Documented constants**:
```bash
# Three retries balance reliability vs speed
MAX_RETRIES=3
```

**Unix-style paths**:
```bash
# Good: Absolute paths or project-relative
./.claude/scripts/validate.sh
```

**Validation before processing**:
```bash
# Validate before processing
if ! jq empty "$FILE" 2>/dev/null; then
    echo "ERROR: Invalid JSON file: $FILE"
    exit 1
fi
```

---

## Refined Current Delta Patterns

Enhanced patterns combining official approaches with framework refinements.

### What-When-Not Description Framework

**From skills-architect description guidelines:**

```yaml
description: "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills with progressive disclosure and autonomy-first design. Not for general programming tasks."
```

**Components**:
- **WHAT**: Build self-sufficient skills (core function)
- **WHEN**: Creating, evaluating, or enhancing skills (triggers/contexts)
- **NOT**: Not for general programming tasks (boundaries)

**Comparison with official approach**:

Official skill-creator description:
```yaml
description: Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.
```

**Key insight**: Official includes "how" language ("guide for creating", "extends capabilities") which provides helpful context. The What-When-Not framework optimizes for discoverability but may omit useful behavioral guidance.

**Balanced approach**: Include what/when/not, plus minimal context that shapes behavior without over-specifying implementation.

### Hub-and-Spoke Aggregation

**Pattern for result aggregation**:

```markdown
Hub Skill (regular, disable-model-invocation: true):
- Delegates to Worker A (context: fork)
- Delegates to Worker B (context: fork)
- Delegates to Worker C (context: fork)
- Aggregates all results for final output
```

**Critical**: ALL workers MUST use `context: fork` for hub to aggregate results. Regular→Regular skill handoffs are one-way only.

### Fork Isolation Patterns

**When to fork** (context: fork):
- Parallel processing (secure isolation)
- Untrusted code execution (security barrier)
- Multi-tenant processing (isolated contexts)
- Noisy operations (keep main context clean)

**When NOT to fork**:
- Need conversation history
- Need user preferences
- Need previous workflow steps
- Simple sequential tasks

**Data transfer via args**:
```yaml
Caller: Skill("analyze-data", args="dataset=production_logs timeframe=24h")
Forked skill receives: Scan $ARGUMENTS for dataset=production_logs timeframe=24h
```

### URL Validation Pattern

**For knowledge skills with external references**:

```markdown
## Mandatory Reference Files

- **MUST READ**: [Official Skills Guide](https://code.claude.com/docs/en/skills)
  - Tool: `mcp__simplewebfetch__simpleWebFetch`
  - Cache: 15 minutes minimum
  - Content: Skill structure, progressive disclosure
```

**Implementation**:
1. Validate all external URLs before skill creation
2. Use `mcp__simplewebfetch__simpleWebFetch` with 15-minute cache
3. Document any failed URLs or redirects

### Documentation Synchronization Pattern

**CLAUDE.md + .claude/rules/ as single unit**:

```markdown
When CLAUDE.md changes → Check .claude/rules/ for updates
When .claude/rules/ change → Check CLAUDE.md for updates
CLAUDE.md may reference .claude/rules/ that no longer exist
```

**Recognition question**: "Did I check both files when updating documentation?"

### Natural Language for Built-in Tools

**When citing TaskList/Agent/Task tools**:

✅ **DO**: Describe workflow and dependencies in natural language
- "First scan the structure, then validate components in parallel"
- "Validation must complete before optimization begins"
- "Generate report only after all validation phases finish"

❌ **DON'T**: Provide code examples showing tool invocation
- No `TaskCreate(subject="...")` examples
- Trust Claude's intelligence to use built-in tools correctly

**Why**: TaskList (Layer 0) and Agent/Task tools (Layer 1) are built-in primitives that Claude already knows how to use. Code examples add context drift risk.

---

# Pure Anti-Patterns (from official skill-creator)

While this file emphasizes positive patterns, the official skill-creator explicitly identifies these **pure anti-patterns** that should be avoided:

## What to Not Include in a Skill

A skill should only contain essential files that directly support its functionality. **Do NOT create** these extraneous documentation or auxiliary files:

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- etc.

**Rationale**: The skill should only contain the information needed for an AI agent to do the job at hand. It should not contain auxiliary context about the process that went into creating it, setup and testing procedures, user-facing documentation, etc. Creating additional documentation files just adds clutter and confusion.

## Content Duplication Anti-Pattern

From official skill-creator (line 91):

> **Avoid duplication**: Information should live in either SKILL.md or references files, not both. Prefer references files for detailed information unless it's truly core to the skill—this keeps SKILL.md lean while making information discoverable without hogging the context window. Keep only essential procedural instructions and workflow guidance in SKILL.md; move detailed reference material, schemas, and examples to references files.

**Key principle**: Information lives in SKILL.md **OR** references/, not both.

---

# TO KNOW WHEN

Understanding these patterns helps recognize when to apply positive guidance.

## Pattern Selection Recognition

**Behavioral Delta**: Content shapes behavior vs. inference → Include principle-first framing
**Multi-Dimensional Delta**: Project-specific commands/patterns → Use working commands, not generics
**Reliability Delta**: Consistency improvements → Add explicit workflows and validation
**Refined Current Delta**: Framework enhancements → Balance official patterns with what/when/not

## Official vs Custom Balance

**Official patterns** (from skill-creator, docx):
- Emphasize progressive disclosure with references
- Include philosophical framing that shapes behavior
- Provide concrete command examples with tool specifications

**Custom enhancements** (2026 toolkit):
- What-When-Not description framework (discoverability optimization)
- Hub-and-spoke aggregation patterns (multi-skill coordination)
- Natural language citations for built-in tools (avoid context drift)

**Recognition pattern**: Use official patterns as foundation, apply custom enhancements where they solve specific framework problems (e.g., skill discoverability, multi-skill orchestration).
