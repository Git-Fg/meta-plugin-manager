---
name: command-development
description: Create portable, self-contained slash commands that orchestrate workflows and provide human-invoked "buttons" for complex operations.
---

# Command Development

Commands are human-invoked orchestrators that bundle skills and tools into coherent workflows. Unlike skills (which Claude can invoke contextually), commands are explicit actions users trigger with `/name`.

**Core principle**: Commands should work standalone without depending on external files or documentation.

---

## Quick Navigation

| If you are... | MANDATORY READ WHEN... | File |
|---------------|------------------------|------|
| Creating your first command | **BEFORE ANYTHING ELSE** | `references/executable-examples.md` |
| Using bash injection (! syntax) | **BEFORE USING** | `references/executable-examples.md` |
| Using file references (@ syntax) | **BEFORE USING** | `references/executable-examples.md` |
| Configuring frontmatter | **WHEN ADDING FRONTMATTER** | `references/frontmatter-reference.md` |
| Creating interactive commands | **WHEN USING ASKUSERQUESTION** | `references/interactive-commands.md` |
| Testing your command | **BEFORE TESTING** | `references/testing-strategies.md` |
| Documenting complex commands | **WHEN ADDING DOCS** | `references/documentation-patterns.md` |
| Designing multi-step workflows | **WHEN DESIGNING WORKFLOWS** | `references/advanced-workflows.md` |
| Preparing for marketplace | **WHEN PUBLISHING** | `references/marketplace-considerations.md` |
| Using plugin-specific features | **WHEN USING PLUGIN FEATURES** | `references/plugin-features-reference.md` |

**CRITICAL**: `executable-examples.md` contains bash injection and file reference syntax. Using these without understanding causes silent failures and syntax errors. **READ COMPLETELY. DO NOT SKIP.**

---

## What Makes Good Commands

### 1. Human-Facing "Buttons"

Commands are verbs you can invoke intentionally:
- `/plan` - Create implementation plan with confirmation gate
- `/deploy` - Deploy to environment with safety checks
- `/verify` - Run comprehensive verification pipeline
- `/tdd` - Enforce test-driven development workflow

### 2. Orchestration Focus

Commands don't implement logic—they orchestrate. They delegate to agents, skills, or tools:

**Example from /plan**:
```
This command invokes the planner agent to create a comprehensive
implementation plan before writing any code.
```

**Example from /tdd**:
```
This command invokes the tdd-guide agent to enforce test-driven
development methodology.
```

### 3. Safety and Gating

Commands protect against destructive or high-impact operations:

```yaml
---
description: Deploy current branch to staging. WAIT for confirmation.
disable-model-invocation: true
---
```

```yaml
---
description: Create plan and WAIT for user CONFIRM before touching code.
disable-model-invocation: true
---
```

---

## Real Command Examples

### Example 1: /code-review - Minimal Imperative Command

**No frontmatter** - Just direct instructions:

```markdown
# Code Review

Comprehensive security and quality review of uncommitted changes:

1. Get changed files: git diff --name-only HEAD

2. For each changed file, check for:

**Security Issues (CRITICAL):**
- Hardcoded credentials, API keys, tokens
- SQL injection vulnerabilities
- XSS vulnerabilities
- Missing input validation
- Insecure dependencies
- Path traversal risks

**Code Quality (HIGH):**
- Functions > 50 lines
- Files > 800 lines
- Nesting depth > 4 levels
- Missing error handling
- console.log statements
- TODO/FIXME comments
- Missing JSDoc for public APIs

**Best Practices (MEDIUM):**
- Mutation patterns (use immutable instead)
- Emoji usage in code/comments
- Missing tests for new code
- Accessibility issues (a11y)

3. Generate report with:
   - Severity: CRITICAL, HIGH, MEDIUM, LOW
   - File location and line numbers
   - Issue description
   - Suggested fix

4. Block commit if CRITICAL or HIGH issues found

Never approve code with security vulnerabilities!
```

**Best practices embodied**:
- ✅ No frontmatter needed for simple commands
- ✅ Clear severity buckets (CRITICAL/HIGH/MEDIUM)
- ✅ Blocking rule ("Block commit if...")
- ✅ Concise, imperative instructions

### Example 2: /build-fix - Minimal Workflow Command

```markdown
# Build and Fix

Incrementally fix TypeScript and build errors:

1. Run build: npm run build or pnpm build

2. Parse error output:
   - Group by file
   - Sort by severity

3. For each error:
   - Show error context (5 lines before/after)
   - Explain the issue
   - Propose fix
   - Apply fix
   - Re-run build
   - Verify error resolved

4. Stop if:
   - Fix introduces new errors
   - Same error persists after 3 attempts
   - User requests pause

5. Show summary:
   - Errors fixed
   - Errors remaining
   - New errors introduced

Fix one error at a time for safety!
```

**Best practices embodied**:
- ✅ Clear workflow steps
- ✅ Stop conditions defined
- ✅ Safety constraint ("one error at a time")
- ✅ Summary output format

### Example 3: /plan - Full Structured Command with Frontmatter

**Frontmatter**:
```yaml
---
description: Restate requirements, assess risks, and create step-by-step implementation plan. WAIT for user CONFIRM before touching any code.
---
```

**Structure**:
- **What This Command Does**: Clear bullet list
- **When to Use**: Specific situations
- **How It Works**: Step-by-step explanation
- **Example Usage**: Complete session demonstration
- **Important Notes**: CRITICAL constraints
- **Integration with Other Commands**: Workflow connections
- **Related Agents**: Specific agent reference

**Best practices embodied**:
- ✅ Frontmatter as guardrail ("WAIT for user CONFIRM")
- ✅ Clear gating for high-impact changes
- ✅ Shows command interoperability
- ✅ Structured output template
- ✅ Delegates to named agent (planner)

### Example 4: /tdd - Agent-Invoking Workflow Command

**Frontmatter**:
```yaml
---
description: Enforce test-driven development workflow. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage.
---
```

**Structure**:
- **What This Command Does**: RED → GREEN → REFACTOR cycle
- **When to Use**: New features, bug fixes, refactoring
- **How It Works**: TDD cycle with diagram
- **TDD Cycle**: Explicit RED → GREEN → REFACTOR diagram
- **Example Usage**: Full session with code
- **TDD Best Practices**: DO/DON'T lists
- **Test Types to Include**: Unit/Integration/E2E
- **Coverage Requirements**: 80% minimum, 100% for critical code
- **Important Notes**: MANDATORY workflow
- **Integration with Other Commands**: Workflow connections
- **Related Agents**: Specific agent reference

**Best practices embodied**:
- ✅ Strong frontmatter with success criteria (80%+ coverage)
- ✅ Human-oriented "when to use" section
- ✅ Structured behavior with numbered steps
- ✅ Delegates to named agent (tdd-guide)
- ✅ Best practices section with DO/DON'T

### Example 5: /orchestrate - Multi-Agent Workflow Command

```markdown
# Orchestrate Command

Sequential agent workflow for complex tasks.

## Usage
`/orchestrate [workflow-type] [task-description]`

## Workflow Types
### feature
Full feature implementation workflow:
planner -> tdd-guide -> code-reviewer -> security-reviewer

### bugfix
Bug investigation and fix workflow:
explorer -> tdd-guide -> code-reviewer

## Execution Pattern
For each agent in the workflow:
1. Invoke agent with context from previous agent
2. Collect output as structured handoff document
3. Pass to next agent in chain
4. Aggregate results into final report

## Arguments
$ARGUMENTS:
- `feature <description>` - Full feature workflow
- `bugfix <description>` - Bug fix workflow
- `custom <agents> <description>` - Custom agent sequence
```

**Best practices embodied**:
- ✅ Defines workflow types
- ✅ Shows agent sequences
- ✅ Handoff document format
- ✅ Custom workflow support

### Example 6: /verify - Pipeline Command with Arguments

```markdown
# Verification Command

Run comprehensive verification on current codebase state.

## Instructions
Execute verification in this exact order:

1. **Build Check** - Run build, report errors, STOP on failure
2. **Type Check** - Run type checker, report errors
3. **Lint Check** - Run linter, report issues
4. **Test Suite** - Run tests, report coverage
5. **Console.log Audit** - Search for console.log in source files
6. **Git Status** - Show uncommitted changes

## Output
Produce a concise verification report:
```
VERIFICATION: [PASS/FAIL]
Build:    [OK/FAIL]
Types:    [OK/X errors]
Lint:     [OK/X issues]
Tests:    [X/Y passed, Z% coverage]
Secrets:  [OK/X found]
Logs:     [OK/X console.logs]
Ready for PR: [YES/NO]
```

## Arguments
$ARGUMENTS can be:
- `quick` - Only build + types
- `full` - All checks (default)
- `pre-commit` - Checks relevant for commits
- `pre-pr` - Full checks plus security scan
```

**Best practices embodied**:
- ✅ Strict ordering defined
- ✅ Machine-readable output template
- ✅ Stop on failure semantics
- ✅ Parameterized behavior via arguments

### Example 7: /learn - Pattern Extraction Command

```markdown
# /learn - Extract Reusable Patterns

Analyze the current session and extract any patterns worth saving as skills.

## Trigger
Run `/learn` at any point during a session when you've solved a non-trivial problem.

## What to Extract
Look for:
1. **Error Resolution Patterns** - What error occurred? Root cause? What fixed it?
2. **Debugging Techniques** - Non-obvious debugging steps, tool combinations
3. **Workarounds** - Library quirks, API limitations, version-specific fixes
4. **Project-Specific Patterns** - Codebase conventions, architecture decisions

## Output Format
Create a skill file at `~/.claude/skills/learned/[pattern-name].md`:
```markdown
# [Descriptive Pattern Name]
**Extracted:** [Date]
**Context:** [Brief description]
## Problem
[What problem this solves]
## Solution
[The pattern/technique/workaround]
## Example
[Code example if applicable]
## When to Use
[Trigger conditions]
```

## Process
1. Review session for extractable patterns
2. Identify most valuable/reusable insight
3. Draft the skill file
4. Ask user to confirm before saving
5. Save to `~/.claude/skills/learned/`
```

**Best practices embodied**:
- ✅ Clear trigger conditions
- ✅ Output format specified
- ✅ Process steps defined
- ✅ User confirmation required

---

## Quick Navigation

| If you are... | MANDATORY READ WHEN... | File |
|---------------|------------------------|------|
| Creating your first command | BEFORE ANYTHING ELSE | `references/executable-examples.md` |
| Using bash injection (! syntax) | BEFORE USING | `references/executable-examples.md` |
| Using file references (@ syntax) | BEFORE USING | `references/executable-examples.md` |
| Configuring frontmatter | WHEN ADDING FRONTMATTER | `references/frontmatter-reference.md` |
| Creating interactive commands | WHEN USING ASKUSERQUESTION | `references/interactive-commands.md` |
| Testing your command | BEFORE TESTING | `references/testing-strategies.md` |
| Documenting complex commands | WHEN ADDING DOCS | `references/documentation-patterns.md` |
| Designing multi-step workflows | WHEN DESIGNING WORKFLOWS | `references/advanced-workflows.md` |
| Preparing for marketplace | WHEN PUBLISHING | `references/marketplace-considerations.md` |
| Using plugin-specific features | WHEN USING PLUGIN FEATURES | `references/plugin-features-reference.md` |

**CRITICAL REMINDER**: executable-examples.md contains bash injection (!) and file reference (@) syntax. Using these without understanding causes silent failures and syntax errors. READ COMPLETELY. DO NOT SKIP.

---

## Command Variety: One Size Does Not Fit All

Commands vary widely in structure and complexity. Choose the right structure based on your needs.

### Structure Spectrum

| Complexity | Example | Frontmatter | Sections | Typical Length |
|------------|---------|-------------|----------|----------------|
| **Minimal** | `/code-review`, `/build-fix` | No | Just numbered steps | 10-30 lines |
| **Medium** | `/verify`, `/learn` | Sometimes | Instructions + Arguments | 30-70 lines |
| **Full** | `/plan`, `/tdd` | Yes | All sections + Examples | 100-300 lines |
| **Advanced** | `/orchestrate`, `/e2e` | Yes | Multiple workflows | 200-500 lines |

### When to Use Each Structure

**Use Minimal structure when**:
- Task is straightforward and clear
- No complex decision-making needed
- One clear job with known steps
- Examples: `/code-review`, `/build-fix`

**Use Medium structure when**:
- Task has multiple modes or arguments
- Output format needs specification
- Some explanation required
- Examples: `/verify`, `/learn`, `/checkpoint`

**Use Full structure when**:
- Complex workflow with multiple phases
- Human-in-the-loop confirmation required
- Agent invocation with handoffs
- Examples: `/plan`, `/tdd`

**Use Advanced structure when**:
- Multi-agent orchestration
- Multiple workflow types
- Complex handoff patterns
- Examples: `/orchestrate`, `/e2e`

### Frontmatter: Optional but Strategic

**Use frontmatter when**:
- Command needs guardrails (`disable-model-invocation: true`)
- Command takes arguments (`argument-hint`)
- Command has complex description
- Command should appear in `/help` with specific text

**Skip frontmatter when**:
- Command is simple and self-explanatory
- Description would be redundant with title
- Command is purely internal/personal
- Examples: `/code-review`, `/build-fix`

**Key insight**: Frontmatter is NOT required. Many effective commands don't use it.

### Section Variety

Not all commands need all sections. Use what fits:

**Common sections**:
- Instructions / How It Works
- Arguments / Usage
- Output format
- Example usage (for complex commands)
- Important notes (for safety-critical commands)

**Optional sections**:
- What This Command Does / When to Use (use when helpful)
- Integration with Other Commands (for workflow commands)
- Related Agents (ONLY for commands that invoke specific agents)
- Best Practices (for methodology-enforcing commands like `/tdd`)

**Anti-pattern**: Don't add sections just to follow a template. Every section must earn its place.

---

## Dynamic Context Features

Commands can include dynamic context using special syntax:

### File References with `@` Syntax

**Purpose**: Include file contents directly in command execution

**Syntax**: `@file-path` or `@$1` (with arguments)

**How it works**: The `@` syntax is a UX shorthand that feeds file/terminal content into the prompt using the Read tool under the hood. It's about reading, not executing.

**Supported patterns**:
- `@file.ts` - Read entire file
- `@file.ts#L10-L20` - Read specific lines
- `@terminal:name` - Read output from terminal with that title
- `@$1`, `@$2` - Reference arguments

**Examples**:

```markdown
---
description: Review specific file
argument-hint: [file-path]
---

Review @$1 for:
- Code quality
- Best practices
- Potential bugs
```

```markdown
---
description: Compare configurations
---

Compare @package.json and @package-lock.json for consistency

Ensure:
- Dependency versions match
- No missing dependencies
- Correct resolution
```

**When to use `@`**:
- Need to analyze specific files
- Static file references in workflows
- Template-based generation
- Configuration comparison

**Best practices**:
- Use project-relative or absolute paths
- Validate file exists before referencing
- Combine with `allowed-tools: Read` if needed
- Useful for code review, documentation generation

### Bash Injection with ! Syntax

**Purpose**: Execute bash commands and include output in command

**Syntax**: !`` followed by the command in backticks (in this case it's blank)

**Key characteristic**: This is **preprocessing** - commands run BEFORE Claude reads the prompt. The shell command output replaces the placeholder, so Claude receives actual data, not the command itself.

**Requires**: `allowed-tools: Bash` in frontmatter

**Working examples**: See examples/executable-examples.md for complete, runnable examples of bash injection patterns.

**When to use bash injection**:
- Dynamic context gathering (git status, environment vars)
- Project/repository state
- Multi-step workflows with bash
- Validation and checks

**Best practices**:
- **Always add** `allowed-tools: Bash` to frontmatter
- Test bash commands in terminal first
- Use proper error handling with stderr redirection and fallback messages
- Consider using `|| echo "FAILED"` for error detection
- Keep commands simple and focused

### Combined Patterns

**Review pattern** (combines bash injection with file references):
- Get changed files via bash injection
- For each file, use @FILE reference to review contents
- Check for security, quality, best practices, test coverage

**Workflow pattern** (multiple bash injections):
- Run build, tests, and lint commands via bash injection
- Check if all pass before approving
- Report failures if any step fails

**Template pattern**:
- Reference template file with @syntax
- Reference data file with @$1 argument
- Generate output following template structure

**Working examples**: See examples/executable-examples.md for complete implementations.

### Important Notes

**For `@` syntax**:
- File/terminal contents are read via Read tool before command processing
- Supported patterns: `@file.ts`, `@file.ts#L10-L20`, `@terminal:name`, `@$1`
- Use absolute or project-relative paths
- Requires Read tool permission (implicit for most cases)

**For bash injection syntax**:
- Commands execute as preprocessing BEFORE Claude sees the prompt
- **Must have** `allowed-tools: Bash` in frontmatter
- Output becomes part of command prompt
- Test commands independently first
- Handle errors explicitly
- NOT interactive - use Bash tool during execution for interactive flows

**Anti-patterns**:
- ❌ Using bash injection syntax without `allowed-tools: Bash`
- ❌ Complex bash logic (keep it simple)
- ❌ Not validating file paths with `@`
- ❌ Not testing bash commands before using

---

## How Commands and Skills Interact

Commands and skills work together in two patterns:

### Pattern 1: Command Invokes Agent

```
Command (/plan) → Agent (planner) → Implementation
Command (/tdd) → Agent (tdd-guide) → TDD workflow
```

The command is the UX entry point. The agent handles deep implementation.

### Pattern 2: Command Uses Skill

```
Command (/verify) → Skill (verification-loop) → Pipeline execution
Command (/code-review) → Skill (security-review) → Security checks
```

The command orchestrates. The skill provides reusable logic.

### Pattern 3: Skill Can Call Command

Rare, but valid for ultra-specific workflows:
```
Skill (release-workflow) → Command (/audit) → Security gate
Skill (release-workflow) → Command (/deploy) → Deployment gate
```

This pattern works when a skill needs to invoke a command under very constrained conditions.

**Key insight**: Don't treat commands vs skills as a hierarchy. Commands are your main verbs. Skills are reusable know-how those verbs rely on.

---

## Command Window Lifecycle

**Critical insight**: Commands (like skills) are stateless invocations. The "command window" is the execution lifecycle of a single command call—nothing more.

### What This Means

**Commands have no persistent state**:
- No hidden JSON tracking active commands
- No memory between invocations
- Each command call is independent
- Permissions frontmatter applies ONLY during that specific execution
- Commands use the Skill tool under the hood, so the same lifecycle applies

**The command window**:
```
┌─────────────────────────────────────────────────────────────────┐
│  Command Invocation (Permissions ACTIVE via frontmatter)         │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Processing → AskUserQuestion? → Processing → Return       ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                            ↓
                    Permissions INACTIVE
```

### Multi-Turn Interaction: AskUserQuestion vs Natural Conversation

**AskUserQuestion maintains the command window**:
- When a command uses `AskUserQuestion`, the command remains ACTIVE
- Permissions (like `allowed-tools`) continue to apply while waiting for user response
- After user responds, the SAME command invocation continues
- This is the ONLY way to maintain permissions and context across user responses

**Natural conversation closes the command window**:
- When a command responds naturally (without `AskUserQuestion`), the command finishes
- The next turn is a fresh decision point
- The model may or may not re-invoke the command
- Permissions from the previous invocation NO LONGER apply

| Interaction Type | Command Window | Next Turn |
|------------------|----------------|-----------|
| `AskUserQuestion` | Remains ACTIVE | Same command invocation continues, permissions persist |
| Natural conversation | Closes after response | New turn, model decides fresh, no permissions |

### Examples

**Example 1: Deployment command using AskUserQuestion (Window stays open)**
- Pre-flight checks completed
- AskUserQuestion: "Deploy to which environment?"
- User responds: "1" (staging)
- Still SAME command, Bash permission still active
- Command executes deployment using bash injection
- Deployment completes and returns result
- Permissions no longer apply

**Example 2: Natural conversation (Window closes)**
- Pre-flight checks completed
- Question asked naturally: "Which environment should I deploy to?"
- Command finishes after response
- User responds: "staging"
- NEW TURN, no active command, Bash permission DON'T apply
- Model decides what to do - may or may not re-invoke the command

**Working examples**: See examples/executable-examples.md for complete code examples showing both patterns.

### When to Use AskUserQuestion in Commands

**Use `AskUserQuestion` when**:
- Command needs to maintain permissions across user responses
- Command needs multi-turn interaction with state (e.g., deployment confirmation)
- User response should trigger tool usage within same invocation
- Critical workflows require user confirmation before proceeding

**Don't use `AskUserQuestion` when**:
- Command provides one-shot output or report
- Command completes its task in a single response
- User naturally provides all context upfront

### Recognition Questions

**Ask yourself**:
- "Does this command need to maintain permissions across user responses?" → Use `AskUserQuestion`
- "Can this command complete its task in one response?" → Natural response is fine
- "Will the command use tools AFTER getting user input?" → Use `AskUserQuestion`

### Anti-Pattern: Natural Conversation Commands

**❌ Commands that try to have natural conversations without AskUserQuestion**

Commands that ask questions naturally will close after their first response. Any subsequent permissions or state are lost.

**Recognition**: "Does this command ask questions and expect answers while needing to use tools afterward?"

**Example**:
❌ Bad:
```yaml
# "Tell me which environment to deploy to, then I'll run kubectl apply."
# ← Command closes here, Bash permission lost
```

✅ Good:
```yaml
AskUserQuestion: "Deploy to which environment?"
# ← Command stays active, can use Bash after user answers
```

**Fix**: Use `AskUserQuestion` for any multi-turn interaction where permissions or state must persist.

### Why This Matters for Commands

Commands often need multi-turn interaction:
- **Deployment commands**: Need confirmation before executing destructive operations
- **Planning commands**: Need user approval before proceeding with implementation
- **Workflow commands**: Need user decisions at multiple steps

**Without `AskUserQuestion`**:
- Command finishes after first response
- User's confirmation/selection happens in a new turn
- Command permissions no longer apply
- Model must re-invoke command or handle differently

**With `AskUserQuestion`**:
- Command stays active through the interaction
- Permissions maintained throughout
- Clean, predictable workflow
- User confirmations happen within the command's execution context

---

## Step-by-Step: Creating a Command

### Step 1: Decide Command vs Skill

Ask these questions:

**Create a command when**:
- You want a human-invoked "button" (`/deploy`, `/plan`)
- The workflow has side effects (deploy, commit, migrate)
- It's multi-step and needs orchestrating
- You want to bundle multiple skills into coherent UX

**Create a skill when**:
- Claude needs contextual knowledge (API conventions, coding standards)
- The logic should be reusable across commands
- It's purely knowledge, not action

**Create both when**:
- You want TDD as a first-class workflow → Command: `/tdd` + Skill: `tdd-workflow`
- You want deployment safety → Command: `/deploy` + Skill: `deployment-checklist`

### Step 2: Choose Location

**Options**:
- `.claude/commands/<name>.md` - Simple, single-file command
- `.claude/skills/<name>/SKILL.md` - Multi-file command with supporting resources
- `~/.claude/commands/<name>.md` - Personal, cross-project command

**Migration path**: Start with `commands/*.md`. If you need supporting files (templates, scripts, examples), migrate to `skills/*/SKILL.md` without changing the `/name` interface.

### Step 3: Write Frontmatter

**Required fields**:
```yaml
---
name: your-command-name
description: What this command does + when to use it + any guardrails
---
```

**Optional but recommended**:
```yaml
---
name: deploy-staging
description: Deploy the current branch to staging environment. Run tests, build, then deploy. Requires explicit user confirmation.
disable-model-invocation: true      # For destructive/human-only operations
argument-hint: [branch-name]         # Shows expected arguments
model: haiku                         # Force specific model for cost
context: fork                        # Run in isolated subagent
---
```

**When to use `disable-model-invocation: true`**:
- Destructive operations (delete, deploy, commit)
- Side-effect-heavy workflows (migrations, API calls)
- Human confirmation gates (planning, reviews)
- Operations you never want Claude to trigger automatically

**When to use `argument-hint`**:
- Command expects parameters: `[branch-name]`, `[issue-number]`
- Command has modes: `[quick|full|pre-commit|pre-pr]`
- Use kebab-case for argument names

### Step 4: Structure the Body

Choose the right structure based on command complexity:

**For minimal commands** (like `/code-review`, `/build-fix`):
```markdown
# Command Name

Clear description.

1. Step one
2. Step two
3. Step three

Optional: Safety constraint or final note.
```

**For medium commands** (like `/verify`, `/learn`):
```markdown
# Command Name

Clear description.

## Instructions
Execute in this order:
1. Step one
2. Step two

## Output
```
[Output format template]
```

## Arguments
$ARGUMENTS can be:
- `option1` - Description
- `option2` - Description
```

**For full commands** (like `/plan`, `/tdd`):
```markdown
# Command Name

## What This Command Does
- Step 1: Brief description
- Step 2: Brief description

## When to Use
Use `/command-name` when:
- Situation 1
- Situation 2

## How It Works
- Explain from Claude's perspective
- Mention agents or skills it uses

## Example Usage
```
User: /command-name [arguments]

Agent:
# Example Session: [Title]
[Ideal behavior demonstration]
```

## Important Notes
- **CRITICAL**: Hard constraints

## Integration with Other Commands
- Workflow connections

## Related Agents
This command invokes the agent-name agent.
```

**Key insight**: Use the simplest structure that works. Don't add sections just to follow a template.

### Step 5: Define Arguments (If Applicable)

Commands can interpret arguments to change behavior:

**Example from /verify**:
```markdown
## Arguments
$ARGUMENTS can be:
- `quick`   - Only build + type-check
- `full`    - All checks (default)
- `pre-commit` - Checks relevant for local commits
- `pre-pr`  - Full checks plus security scan
```

**Simple commands** can skip this section:
"This command does not interpret special arguments. Everything after `/name` is treated as context."

### Step 6: Connect to Agents or Skills (If Applicable)

**Only add this section if your command invokes specific agents or references specific skills.**

Many commands don't need this section at all.

**Option 1: Invoke named agent** (for commands that delegate to specific agents)
```markdown
## Related Agents

This command invokes the planner agent located at:
`~/.claude/agents/planner.md`
```

**Option 2: Reference skills** (for commands that use specific skills)
```markdown
## Related Skills

This command uses the verification-loop skill for running
continuous verification checks.

This command can reference the tdd-workflow skill at:
`~/.claude/skills/tdd-workflow/`
```

**Examples of commands that DON'T need this section**:
- `/code-review` - Doesn't invoke agents
- `/build-fix` - Doesn't invoke agents
- `/verify` - Doesn't invoke agents

**Key insight**: Most commands don't reference agents or skills. Only add this when your command explicitly delegates.

### Step 7: Add Example Usage

Show ideal behavior with a complete example:

```markdown
## Example Usage
User: /plan-migration We need to move from PostgreSQL to Neon with minimal downtime.

Agent (planner):
# Migration Plan: PostgreSQL → Neon

## Requirements Restatement
- Current: Self-hosted PostgreSQL
- Target: Neon (serverless PostgreSQL)
- Constraint: Minimal downtime

## Implementation Phases
1. Set up Neon project and database
2. Create migration scripts
3. Test migration on staging
4. Schedule production migration
5. Verify data integrity

## Dependencies
- Neon account and API keys
- Access to production database
- Migration window (2-4 hours)

## Risks (by severity)
- HIGH: Data loss during migration
- MEDIUM: Extended downtime
- LOW: Performance differences

## Estimated Complexity
- High complexity
- Estimated 8-12 hours

WAITING FOR CONFIRMATION: Proceed with this plan? (yes/no/modify)
```

This mirrors the real examples from /plan and /tdd.

---

## Frontmatter Configuration (CRITICAL)

MANDATORY TO READ WHEN ADDING FRONTMATTER: references/frontmatter-reference.md

Invalid frontmatter causes silent failures—your command simply won't load, with no error messages.

The reference contains:
- Required vs optional fields
- Validation rules for each field
- Common errors that cause silent failures
- Testing strategies to verify frontmatter

You cannot proceed without reading this when adding frontmatter.

---

## Frontmatter Deep Dive

### Field Reference

| Field | Required | Purpose | Example |
|-------|----------|---------|---------|
| `name` | No | Command name (inferred from filename if omitted) | `deploy-staging` |
| `description` | Yes | What command does + when to use | `Deploy to staging with tests` |
| `disable-model-invocation` | No | Prevent auto-loading | `true` for destructive ops |
| `user-invocable` | No | Hide from `/` menu | `false` for knowledge-only |
| `argument-hint` | No | Show in autocomplete | `[branch-name]` |
| `allowed-tools` | No | Restrict available tools | `["Bash", "Read"]` |
| `model` | No | Force specific model | `haiku` for cheap tasks |
| `context` | No | Run in subagent | `fork` for isolation |

### Description Template

Good descriptions answer three questions:
1. **What** does it do? (Deploy, plan, verify)
2. **When** to use it? (New feature, before commit, after changes)
3. **How** does it guard against issues? (Wait for confirmation, run tests, check coverage)

**Formula**: `[Action verb] + [Scope] + [When to use] + [Guardrails]`

Examples:
- ✅ `Deploy current branch to staging with tests. Requires confirmation.`
- ✅ `Create implementation plan and WAIT for user CONFIRM before code.`
- ✅ `Run comprehensive verification: build, types, lint, tests.`

Bad examples:
- ❌ `This command helps with deployment` (vague)
- ❌ `Deploy the code` (no guardrails)
- ❌ `Helper for planning tasks` (not actionable)

---

## Common Patterns

### Pattern 1: Minimal/Review Command

**Use case**: Quick checks and reviews

**Structure**:
```markdown
# Command Name

Clear description.

1. Step one
2. Step two
3. Step three

Optional: Safety constraint.
```

**Example**: `/code-review`, `/build-fix`

### Pattern 2: Pipeline Command

**Use case**: Multi-step quality gates

**Structure**:
```markdown
# Command Name

Clear description.

## Instructions
Execute in this order:
1. Step 1 (build, type, lint)
2. Step 2 (tests, coverage)
3. Step 3 (security, secrets)

## Output
```
[Output format template]
```
```

**Example**: `/verify`, `/quality-check`

### Pattern 3: Planning Command

**Use case**: High-impact changes with human confirmation

**Structure**:
1. Restate requirements
2. Identify risks
3. Break into phases
4. Present plan
5. WAIT for confirmation

**Example**: `/plan`, `/plan-migration`

### Pattern 4: Enforcement Command

**Use case**: Methodology enforcement (TDD, code review)

**Structure**:
1. Define methodology
2. Enforce workflow
3. Verify compliance
4. Report results

**Example**: `/tdd`, `/code-review`, `/security-audit`

### Pattern 5: Dynamic Context Command

**Use case**: Commands that need runtime information

**Uses bash injection and `@` (file references)**:

Common patterns:
- Get changed files from git, then review each with @FILE
- Run specific tests via bash injection based on argument
- Generate documentation for a source file passed as argument

**Working examples**: See examples/executable-examples.md for complete implementations of:
- Review pattern (git status + file references)
- Test pattern (bash injection with arguments)
- Documentation pattern (file references)

**Example use cases**: Commands using git status, test runners, file analysis

### Pattern 6: Deployment Command

**Use case**: Safe deployment with gates

**Structure**:
1. Pre-flight checks
2. Build and package
3. Deploy to environment
4. Verify deployment
5. Report status

**Example**: `/deploy`, `/rollback`, `/promote`

### Pattern 7: Orchestration Command

**Use case**: Multi-agent workflow coordination

**Structure**:
```markdown
# Command Name

## Usage
`/command [workflow-type] [task-description]`

## Workflow Types
### feature
planner -> tdd-guide -> code-reviewer

### bugfix
explorer -> tdd-guide -> code-reviewer

## Execution Pattern
For each agent:
1. Invoke with context
2. Collect output
3. Pass to next agent
4. Aggregate results
```

**Example**: `/orchestrate`

---

## Quality Checklist

Before finalizing a command, verify:

**Structure** (choose what fits):
- [ ] Appropriate complexity level (minimal/medium/full/advanced)
- [ ] Frontmatter only if needed (guardrails, arguments, description)
- [ ] Sections that earn their place (no template-driven bloat)

**Content** (varies by command):
- [ ] Clear instructions (numbered steps or sections)
- [ ] Output format specified (if applicable)
- [ ] Arguments defined (if applicable)
- [ ] Example usage (for complex commands only)
- [ ] Safety constraints (for destructive operations)

**Quality**:
- [ ] Self-contained (NEVER reference external files)
- [ ] Imperative tone (direct instructions)
- [ ] Concise (not verbose, not cryptic)
- [ ] Specific (not vague, not over-prescriptive)
- [ ] Uses `AskUserQuestion` for multi-turn interactions (ALWAYS use, never natural conversation)
- [ ] Understands command window lifecycle and statelessness

**Integration** (only if applicable):
- [ ] "Integration with Other Commands" (for workflow commands)
- [ ] "Related Agents" (ONLY for commands that invoke specific agents)

**Dynamic features** (if applicable):
- [ ] `allowed-tools: Bash` included when using bash injection (MANDATORY - command will fail without it)
- [ ] `@` file paths validated
- [ ] Bash commands tested independently
- [ ] Error handling for bash failures (CRITICAL for robustness)

**Self-check**: Would this command work in a project with ZERO `.claude/rules/` dependencies?

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Missing Guardrails for Destructive Operations

**❌ Commands without safety for destructive operations**

```yaml
---
name: deploy
description: Deploy current code to production
---
```

**Why bad**: No confirmation, no checks, no rollback plan.

**✅ Better**:
```yaml
---
name: deploy
description: Deploy to production with safety gates. Run tests, require confirmation, verify deployment.
disable-model-invocation: true
---
```

### Anti-Pattern 2: Vague Descriptions

**❌ Generic, unclear descriptions**

```yaml
---
description: This command helps with development tasks
---
```

**Why bad**: Users don't know when to use it or what it does.

**✅ Better**:
```yaml
---
description: Run comprehensive verification: build, type-check, lint, test suite, console.log audit, and git status.
---
```

### Anti-Pattern 3: No Examples (For Complex Commands)

**❌ Complex commands without usage examples**

For complex commands (multi-phase workflows, agent orchestration), users need to see expected behavior.

**✅ Better**: Include "Example Usage" section with:
- User input format
- Ideal agent response
- Expected workflow steps

**Exception**: Simple commands like `/code-review` and `/build-fix` don't need examples. The numbered steps are sufficient.

### Anti-Pattern 4: External File References

**❌ Commands that reference other files**

```yaml
See `.claude/skills/verification-loop` for the verification steps.
```

**Why bad**: Breaks portability. Command should be self-contained.

**✅ Better**: Include verification steps directly in the command or reference the skill generically:
```yaml
This command uses the verification-loop skill for running
continuous verification checks.
```

### Anti-Pattern 5: Bash Injection Without Permissions

**❌ Using bash injection syntax without `allowed-tools: Bash`**

Bad example: Command with bash injection but missing allowed-tools frontmatter

**Why bad**: Command will fail because Claude doesn't have permission to run bash.

**✅ Better**: Always include `allowed-tools: Bash` in frontmatter when using bash injection syntax.

**Working examples**: See examples/executable-examples.md for complete code showing both bad and good patterns.

### Anti-Pattern 6: Wrong Freedom Level

**❌ Too prescriptive (low freedom) for flexible tasks**

```yaml
1. Run `npm test`
2. Run `npm run build`
3. Run `npm run lint`
4. Check coverage with `nyc`
```

**Why bad**: Insults intelligence. Wastes tokens. Fails on different project structures.

**✅ Better** (high freedom with principles):
```yaml
Follow this verification order:
1. Build Check
2. Type Check
3. Lint Check
4. Test Suite
5. Console.log audit

Trust Claude to handle project-specific commands and tooling.
```

**Exception**: Use low freedom only for fragile operations where different approaches would break things.

### Anti-Pattern 7: Missing Integration (For Workflow Commands)

**❌ Workflow commands that don't connect to ecosystem**

Commands that are part of larger workflows should show connections.

**✅ Better** (for workflow commands):
```markdown
## Integration with Other Commands
After planning:
- Use `/tdd` for TDD implementation
- Use `/build-fix` if build errors
- Use `/code-review` to review completed implementation
```

**Exception**: Standalone commands like `/code-review`, `/build-fix`, `/learn` don't need integration sections. They're self-contained.

### Anti-Pattern 8: Natural Conversation Without AskUserQuestion

**❌ Commands that try to have natural conversations without AskUserQuestion**

Commands that ask questions naturally will close after their first response. Any subsequent permissions or state are lost.

**Recognition**: "Does this command ask questions and expect answers while needing to use tools afterward?"

**Example**:
❌ Bad: "Tell me which environment to deploy to, then I'll run kubectl apply."
✅ Good: Use `AskUserQuestion` with structured options

**Why bad**: Without `AskUserQuestion`, the command window closes after the first response. The user's answer comes in a new turn where the command is no longer active, so permissions (like `allowed-tools: Bash`) no longer apply. The model must then decide whether to re-invoke the command or handle things differently.

**Fix**: Use `AskUserQuestion` for any multi-turn interaction where permissions or state must persist. See the "Command Window Lifecycle" section for details.

**Why this matters for commands**: Commands often need multi-turn interaction (deployment confirmations, planning approvals, workflow decisions). `AskUserQuestion` ensures the command stays active through these interactions with proper permissions maintained.

---

## Testing Your Command

After creating a command, test it:

### 1. Does it load?

```bash
# Check that Claude recognizes the command
/help
```

The command should appear in the list.

### 2. Does it work as expected?

```bash
/your-command-name test arguments
```

Verify:
- It performs the described actions
- It uses the mentioned agents/skills
- It respects guardrails (confirmation gates, checks)

### 3. Is the output clear?

Users should understand:
- What happened
- What to do next
- Any errors or issues

### 4. Does it integrate properly?

Test workflows:
```bash
/plan my feature
# Should recommend /tdd for implementation

/tdd implement feature
# Should produce working code

/verify
# Should pass all checks
```

### 5. Iterate and refine

Watch for deviations:
- Does it skip confirmation steps?
- Does it over/under-orchestrate?
- Are guardrails working?

Adjust wording to tighten behavior:
- Add "CRITICAL:" for hard constraints
- Add "MUST" for required steps
- Make steps more explicit

---

## Quick Reference

### When to Create a Command

| Situation | Create |
|-----------|--------|
| Human-invoked action | Command |
| Reusable knowledge | Skill |
| Multi-step workflow | Command |
| Orchestration pattern | Command + Skill |
| Safety gate needed | Command with `disable-model-invocation` |

### Command Structure Templates

**Minimal Command** (like `/code-review`, `/build-fix`):
```markdown
# Command Name

Clear one-line description.

1. Step one
2. Step two
3. Step three

Optional: Safety constraint or final note.
```

**Medium Command** (like `/verify`, `/learn`):
```markdown
# Command Name

Clear description.

## Instructions
Execute in this order:
1. Step one
2. Step two

## Output
```
[Output format template]
```

## Arguments
$ARGUMENTS can be:
- `option1` - Description
- `option2` - Description
```

**Dynamic Context Command** (with bash injection and `@` file references):
- Uses bash injection to get changed files from git
- Uses @FILE reference to review each file
- Checks for security, code quality, best practices

**Working example**: See examples/executable-examples.md for complete implementation.

**Full Command** (like `/plan`, `/tdd`):
```yaml
---
description: What + when + guardrails
disable-model-invocation: true  # if destructive
argument-hint: [args]           # if applicable
---

# Command Name

## What This Command Does
- Step 1
- Step 2

## When to Use
Use `/command-name` when:
- Situation 1
- Situation 2

## How It Works
Step-by-step explanation.

## Example Usage
```
User: /command-name [args]

Agent:
# Example Session
[Complete behavior]
```

## Important Notes
- **CRITICAL**: Safety rule

## Integration with Other Commands
- Use `/other-command` for X

## Related Agents
This command invokes the agent-name agent.
```

### Frontmatter Fields

```yaml
# Optional - Only use if needed
name: command-name                 # Optional, inferred from filename
description: What + when + guardrails  # Optional, but recommended for complex commands
disable-model-invocation: true     # Use for destructive/human-only operations
argument-hint: [param-name]        # Use for commands with arguments
model: haiku                       # Use for cost control
context: fork                      # Use for isolation
user-invocable: false              # Use to hide from menu
allowed-tools: ["Bash", "Read"]   # REQUIRED when using `!`` or `@` syntax
```

**Important**: If using bash injection syntax, you MUST include `allowed-tools: Bash`.

**Key insight**: Frontmatter is OPTIONAL. Many great commands don't use it.

---

## Summary

Commands are human-invoked orchestrators that bundle capabilities into coherent workflows. Good commands:

**Structure**:
- Clear frontmatter with description and guardrails
- Progressive disclosure (core in main, details in examples)
- Self-contained (no external file dependencies)

**Behavior**:
- Orchestrate, don't implement
- Delegate to agents and skills
- Provide safety gates for high-impact operations
- Work standalone in any project

**Integration**:
- Connect to broader workflows
- Reference specific agents/skills
- Show command interoperability

**Quality**:
- Imperative but natural tone
- High freedom by default (reduce when justified)
- Complete examples users can copy
- Clear when/why/how structure

The best commands are obvious. When someone reads them, they know exactly what they do and when to use them.