---
name: command-development
description: This skill should be used when the user asks to "create a slash command", "add a command", "write a custom command", "define command arguments", "use command frontmatter", "organize commands", "create command with file references", "interactive command", "use AskUserQuestion in command", or needs guidance on slash command structure, YAML frontmatter fields, dynamic arguments, bash execution in commands, user interaction patterns, or command development best practices for Claude Code.
---

# Command Development: Architectural Refiner

**Role**: Transform intent into portable, self-sufficient commands
**Mode**: Architectural pattern application (ensure output has specific traits)

---

## Architectural Pattern Application

When building a command, apply this process:

1. **Analyze Intent** - What type of command and what traits needed?
2. **Apply Teaching Formula** - Bundle condensed philosophy into output
3. **Enforce Portability Invariant** - Ensure works in isolation
4. **Verify Traits** - Check self-containment, mandatory references, Success Criteria

---

## Core Understanding: What Commands Are

**Metaphor**: Commands are "executable instructions"—they tell Claude exactly what to do and carry their own validation logic.

**Definition**: Commands are Markdown files containing prompts that Claude executes during interactive sessions. They provide reusable workflows, consistency across team usage, and efficient access to complex prompts.

**Key insight**: Commands bundle their own philosophy. They don't depend on external documentation to guide execution.

✅ Good: Command includes mandatory references with "You MUST" language
❌ Bad: Command references external documentation without enforcement
Why good: Commands must self-validate without external dependencies

Recognition: "Would this command work if copied to a project with no rules?" If no, bundle the philosophy.

---

## Command Traits: What Portable Commands Must Have

### Trait 1: Portability (MANDATORY)

**Requirement**: Command works in isolation without external dependencies

**Enforcement**:
- Bundle condensed Seed System philosophy (Delta Standard, Progressive Disclosure, Teaching Formula)
- Include Success Criteria for self-validation
- Use "You MUST" language for mandatory references
- Never reference .claude/rules/ files

**Example**:
```
## Core Philosophy

Think of commands like executable instructions: they tell Claude exactly what to do.

✅ Good: Use specific trigger phrases in description
❌ Bad: Vague descriptions without triggers
Why good: Specific triggers enable pattern matching

Recognition: "Could this command guide execution without external documentation?" If no, add Success Criteria.
```

### Trait 2: Teaching Formula Integration

**Requirement**: Every command must teach through metaphor, contrast, and recognition

**Enforcement**: Include all three elements:
1. **1 Metaphor** - For understanding (e.g., "Think of X like a Y")
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Template**:
```
Metaphor: [Understanding aid]

✅ Good: [Concrete example]
❌ Bad: [Concrete example]
Why good: [Reason]

Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
```

### Trait 3: Self-Containment

**Requirement**: Command owns all its content

**Enforcement**:
- Include all examples directly in command
- Never reference other commands or external files
- Bundle necessary philosophy
- Provide complete, working examples

✅ Good: Examples embedded directly with full syntax
❌ Bad: "See reference files for examples"
Why good: Self-contained commands work without external references

Recognition: "Does command reference files outside itself?" If yes, inline the content.

### Trait 4: Mandatory References Enforcement

**Requirement**: References must be enforced with "You MUST" language

**Enforcement**:
- Use "You MUST read X before doing Y" pattern
- Explain why references are critical
- Provide clear navigation tables

**Example**:
```
## Navigation

| If you are... | You MUST read... |
|---------------|------------------|
| Configuring frontmatter | references/frontmatter-reference.md |
| Adding bash injection | references/executable-examples.md |
| Creating interactive commands | references/interactive-commands.md |

**Critical**: References contain validation rules that prevent silent failures. Skipping references leads to broken commands.
```

### Trait 5: Success Criteria Invariant

**Requirement**: Command includes self-validation logic

**Template**:
```
## Success Criteria

This command is complete when:
- [ ] Valid YAML frontmatter with required fields
- [ ] Description uses third-person with specific trigger phrases
- [ ] Imperative form, no second person
- [ ] All mandatory references enforced with "You MUST" language
- [ ] Teaching Formula: 1 Metaphor + 2 Contrasts + 3 Recognition
- [ ] Portability: Works in isolation, bundled philosophy, no external refs
- [ ] Examples complete and working

Self-validation: Verify each criterion without external dependencies. If all checked, command meets Seed System standards.
```

**Recognition**: "Could a user validate this command using only its content?" If no, add Success Criteria.

---

## Anatomical Requirements

### Required: Command File Structure

**Basic command** (no frontmatter):
```markdown
[Imperative prompt for Claude execution]
```

**With YAML frontmatter**:
```markdown
---
description: [Brief description for /help]
model: [Optional: specify model]
---

[Command prompt]
```

**Quality requirements**:
- **Markdown format**: Valid .md file
- **Imperative form**: Direct instructions to Claude
- **Clear purpose**: Specific workflow definition

### Optional: Frontmatter Fields

**description**:
- Brief description shown in `/help`
- Under 60 characters
- Clear and actionable

**model**:
- Optional model specification
- Overrides conversation default

**allowed-tools**:
- Specify which tools command can use
- Required for skill orchestration: `Skill(skill-name)`

### Optional: Dynamic Features

**Arguments** (`$1`, `$2`):
- Dynamic parameter substitution
- Use with `argument-hint` for guidance

**Bash injection** (`!command`):
- Execute commands and inject output
- Requires `Bash` in `allowed-tools`

**File references** (`@file`):
- Reference files in project
- Requires `Read` in `allowed-tools`

**Recognition**: "Does command use dynamic features?" If yes, ensure proper validation and testing.

---

## Pattern Application Framework

### Step 1: Analyze Intent

**Question**: What type of command and what traits needed?

**Analysis**:
- Simple command? → Focus on imperative prompt clarity
- Complex workflow? → Include frontmatter and allowed-tools
- Interactive command? → Add navigation and validation
- Multi-component? → Include skill/agent orchestration

**Example**:
```
Intent: Build command for code review
Analysis:
- Complex workflow → Need frontmatter with allowed-tools
- Security focus → Bundle validation philosophy
- Reusable → Include Success Criteria
Output traits: Portability + Teaching Formula + Success Criteria
```

### Step 2: Apply Teaching Formula

**Requirement**: Bundle condensed Seed System philosophy

**Elements to include**:
1. **Metaphor**: "Commands are executable instructions..."
2. **Delta Standard**: Good Component = Expert Knowledge - What Claude Knows
3. **Progressive Disclosure**: Navigation tables explained
4. **2 Contrast Examples**: Good vs Bad command structure
5. **3 Recognition Questions**: Binary self-checks for quality

**Template integration**:
```markdown
## Core Philosophy

Metaphor: "Think of commands like [metaphor]..."

✅ Good: description: "Review code for security issues"
❌ Bad: description: "Use this to check code"
Why good: Specific purpose enables pattern matching

Recognition: "Does description include specific user actions?" → If no, add concrete phrases
Recognition: "Are mandatory references enforced?" → If no, use "You MUST" language
Recognition: "Could this work without external documentation?" → If no, bundle philosophy
```

### Step 3: Enforce Portability Invariant

**Requirement**: Ensure command works in isolation

**Checklist**:
- [ ] Condensed philosophy bundled (Delta Standard, Progressive Disclosure, Teaching Formula)
- [ ] Success Criteria included
- [ ] Mandatory references enforced with "You MUST" language
- [ ] No external .claude/rules/ references
- [ ] Examples complete and self-contained

**Verification**: "Could this command survive being moved to a fresh project with no .claude/rules?" If no, fix portability issues.

### Step 4: Verify Traits

**Requirement**: Check all mandatory traits present

**Verification**:
- Portability Invariant ✓
- Teaching Formula (1 Metaphor + 2 Contrasts + 3 Recognition) ✓
- Self-Containment ✓
- Mandatory References Enforcement ✓
- Success Criteria Invariant ✓

**Recognition**: "Does command meet all five traits?" If any missing, add them.

---

## Architecture Patterns

### Pattern 1: Instructions FOR Claude

**Trait**: Commands are written for agent consumption

**Application**: Write as directives TO Claude about what to do

**Example**:
```
✅ Good (instructions for Claude):
Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication issues

Provide specific line numbers and severity ratings.

❌ Bad (messages to user):
This command will review your code for security issues.
You'll receive a report with vulnerability details.
```

### Pattern 2: Mandatory References Navigation

**Trait**: References contain critical validation rules

**Application**: Use navigation tables with "You MUST" enforcement

**Example**:
```
## Navigation

| If you are... | You MUST read... |
|---------------|------------------|
| Configuring frontmatter | references/frontmatter-reference.md |
| Adding bash injection | references/executable-examples.md |

**Critical**: References contain validation rules that prevent silent failures. Skipping references leads to broken commands.
```

### Pattern 3: Self-Validation

**Trait**: Success Criteria enable self-validation

**Application**: Include Success Criteria section at end of command

**Example**:
```markdown
## Success Criteria

This command is complete when:
- [ ] Valid YAML frontmatter with required fields
- [ ] Imperative prompt with clear purpose
- [ ] All mandatory references enforced
- [ ] Teaching Formula integrated

Self-validation: Check each criterion using only command content. No external dependencies required.
```

---

## Critical Enforcements

### CRITICAL: Frontmatter Configuration

**MANDATORY**: You MUST read references/frontmatter-reference.md before configuring any command frontmatter.

Invalid frontmatter causes silent failures. The reference contains:
- Required fields and validation rules
- Common error patterns and fixes
- Testing strategies for frontmatter

**Enforcement**: Configure frontmatter only after reading the reference completely.

### CRITICAL: Bash Injection Validation

**MANDATORY**: Commands with bash injection ("!") or file references (`@`) MUST validate executable syntax before committing.

Test in simulated environment first. Validation steps:
1. Create test scenario with bash injection
2. Verify command syntax is correct
3. Test in isolated environment
4. Confirm no syntax errors

Validation prevents silent failures from invalid bash syntax.

---

## Common Transformations

### Transform Tutorial → Architectural

**Before** (tutorial):
```
Step 1: Understand command basics
Step 2: Configure frontmatter
Step 3: Add features
...
```

**After** (architectural):
```
Analyze Intent → Apply Teaching Formula → Enforce Portability → Verify Traits
```

**Why**: Architectural patterns ensure output has required traits, not just follows steps.

### Transform Reference → Bundle

**Before** (referenced):
```
"See documentation for best practices"
```

**After** (bundled):
```
## Core Philosophy

Bundle condensed principles directly in command:

Think of commands like executable instructions...

✅ Good: [example]
❌ Bad: [example]
Why good: [reason]
```

**Why**: Commands must work in isolation.

---

## Quality Validation

### Portability Test

**Question**: "Could this command work if moved to a project with zero .claude/rules?"

**If NO**:
- Bundle condensed philosophy
- Add Success Criteria
- Remove external references
- Inline examples

### Teaching Formula Test

**Checklist**:
- [ ] 1 Metaphor present
- [ ] 2 Contrast Examples (good/bad) with rationale
- [ ] 3 Recognition Questions (binary self-checks)

**If any missing**: Add them using Teaching Formula Arsenal

### Self-Containment Test

**Question**: "Does command reference files outside itself?"

**If YES**:
- Inline the content
- Bundle necessary philosophy
- Remove external dependencies

### Mandatory References Test

**Question**: "Are references enforced with 'You MUST' language?"

**If NO**: Add navigation tables with "You MUST" enforcement

---

## Success Criteria

This command-development guidance is complete when:

- [ ] Architectural pattern clearly defined (Analyze → Apply → Enforce → Verify)
- [ ] Teaching Formula integrated (1 Metaphor + 2 Contrasts + 3 Recognition)
- [ ] Portability Invariant explained with enforcement checklist
- [ ] All five traits defined (Portability, Teaching Formula, Self-Containment, Mandatory References, Success Criteria)
- [ ] Pattern application framework provided
- [ ] Quality validation tests included
- [ ] Examples demonstrate architectural approach
- [ ] Success Criteria present for self-validation

Self-validation: Verify command-development meets Seed System standards using only this content. No external dependencies required.

---

## Reference: The Five Mandatory Traits

Every command must have:

1. **Portability** - Works in isolation
2. **Teaching Formula** - 1 Metaphor + 2 Contrasts + 3 Recognition
3. **Self-Containment** - Owns all content
4. **Mandatory References** - Enforced with "You MUST" language
5. **Success Criteria** - Self-validation logic

**Recognition**: "Does this command have all five traits?" If any missing, add them.

---

**Remember**: Commands are executable instructions. They tell Claude exactly what to do and carry their own validation logic. Bundle the philosophy. Enforce the invariants. Verify the traits.
