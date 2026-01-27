# Meta-Prompting Pattern

**Adapted from TÂCHES Claude Code Resources**

A systematic approach to building complex software by delegating prompt engineering to Claude itself.

---

## The Problem

When building complex features, most developers either:

- Write vague prompts → get mediocre results → iterate 20+ times
- Spend hours crafting detailed prompts manually
- Pollute their main context window with exploration, analysis, and implementation all mixed together

## The Solution

Separate **analysis** from **execution**:

1. **Analysis Phase** (main context): Tell Claude what you want in natural language. It asks clarifying questions, analyzes your codebase, and generates a rigorous, specification-grade prompt.

2. **Execution Phase** (fresh sub-agent): The generated prompt runs in a clean context window, producing high-quality implementation on the first try.

## What Makes This Effective

The system consistently generates prompts with:

- **XML structure** for clear semantic organization
- **Contextual "why"** - explains purpose, audience, and goals
- **Success criteria** - specific, measurable outcomes
- **Verification protocols** - how to test that it worked
- **"What to avoid and WHY"** - prevents common mistakes with reasoning
- **Extended thinking triggers** - for complex tasks requiring deep analysis
- **Trade-off analysis** - considers multiple approaches and their implications

Most developers don't naturally think through all these dimensions. This system does, every time.

## Commands

### `/create-prompt [task description]`

Analyzes your request and generates a rigorous, specification-grade prompt.

**Process:**

1. Clarifies ambiguity with structured questions
2. Analyzes task complexity and codebase
3. Determines single vs multiple prompts
4. Selects execution strategy (parallel/sequential)
5. Generates prompt with XML structure
6. Saves to `./prompts/[number]-[name].md`

**Output format:**

```xml
<objective>
[Clear statement of what needs to be built/fixed/refactored]
Explain the end goal and why this matters.
</objective>

<context>
[Project type, tech stack, relevant constraints]
[Who will use this, what it's for]
@[relevant files to examine]
</context>

<requirements>
[Specific functional requirements]
[Performance or quality requirements]
Be explicit about what Claude should do.
</requirements>

<output>
Create/modify files with relative paths:
- `./path/to/file.ext` - [what this file should contain]
</output>

<verification>
Before declaring complete, verify your work:
- [Specific test or check to perform]
- [How to confirm the solution works]
</verification>

<success_criteria>
[Clear, measurable criteria for success]
</success_criteria>
```

### `/run-prompt <number(s)> [--parallel|--sequential]`

Executes one or more prompts as delegated sub-tasks with fresh context.

**Usage:**

- `/run-prompt` - Run most recent prompt
- `/run-prompt 005` - Run specific prompt
- `/run-prompt 005 006 007 --parallel` - Run multiple in parallel
- `/run-prompt 005 006 007 --sequential` - Run sequentially

**Process:**

1. Resolves prompt files by number or name
2. Delegates to fresh sub-agent(s) with Task tool
3. Waits for completion
4. Archives prompts to `./prompts/completed/`
5. Commits work with git
6. Returns consolidated results

## Why This Works

**Context quality over quantity:**

- Main window: Clean requirements gathering and prompt generation
- Sub-agent: Fresh context with only the pristine specification
- Result: Higher quality implementation, cleaner separation of concerns

**Systematic thinking:**

1. Asking the right questions - Clarifies ambiguity before generating
2. Adding structure automatically - XML tags, success criteria, verification
3. Explaining constraints - Not just "what" but "WHY"
4. Thinking about failure modes - "What to avoid and why"
5. Defining done - Clear, measurable success criteria

## When to Use

**Use meta-prompting for:**

- Complex refactoring across multiple files
- New features requiring architectural decisions
- Database migrations and schema changes
- Performance optimization requiring analysis
- Any task with 3+ distinct steps

**Skip meta-prompting for:**

- Simple edits (change background color)
- Single-file tweaks
- Obvious, straightforward tasks
- Quick experiments

## Integration with TheSeedSystem

This pattern is critical for TheSeedSystem's component factory:

- **Skill development**: Use meta-prompting to build new skills systematically
- **Command creation**: Generate rigorous prompts for complex commands
- **Agent development**: Use for building sophisticated subagents
- **MCP servers**: Use for complex server implementations

## Tips for Best Results

1. **Be conversational in initial request** - Don't try to write a perfect prompt yourself
2. **Answer clarifying questions thoroughly** - Quality of answers impacts the generated prompt
3. **Review generated prompts** - They're saved as markdown; you can edit before execution
4. **Trust the system** - It adds dimensions you might forget
5. **Use parallel execution** - When Claude detects independent tasks, run in parallel

## Usage Workflow

```bash
# 1. Describe what you want
/create-prompt I want to build a dashboard for user analytics with real-time graphs

# 2. Answer clarifying questions (if asked)

# 3. Review and confirm

# 4. Choose execution strategy
# 1. Run prompt now
# 2. Review/edit prompt first
# 3. Save for later
# 4. Other

# 5. Execute (if chose "1")
```
