# Component Builder Subagent Prompt Template

Use this template when dispatching a component builder subagent for Ralph orchestration.

## Template Structure

```
Task tool (general-purpose):
  description: "Build Component: [component-name]"
  prompt: |
    You are building a component following the Seed System architecture.

    ## Task Description

    [FULL TEXT of component requirements from blueprint - paste it here, don't make subagent read files]

    ## Context

    [Scene-setting: where this fits, architectural context, portability requirements]

    ## Before You Begin

    If you have questions about:
    - The requirements or acceptance criteria
    - The approach or implementation strategy
    - Dependencies or assumptions
    - Anything unclear in the component specification

    **Ask them now.** Raise any concerns before starting work.

    ## Your Job

    Once you're clear on requirements:
    1. Create the component following Seed System patterns
    2. Ensure portability (zero external dependencies)
    3. Include progressive disclosure tiers
    4. Add Success Criteria for self-validation
    5. Test the component
    6. Report back with evidence

    Work in: [directory]

    **While you work:** If you encounter something unexpected or unclear, **ask questions**.
    It's always OK to pause and clarify. Don't guess or make assumptions.

    ## Before Reporting Back: Self-Review

    Review your work with fresh eyes. Ask yourself:

    **Portability:**
    - Does this work without external dependencies?
    - Is all context bundled in the component?
    - Would this work in a fresh project with zero context?

    **Quality:**
    - Is this my best work?
    - Are names clear and accurate?
    - Is the code clean and maintainable?
    - Does it follow Seed System patterns?

    **Completeness:**
    - Did I fully implement everything in the spec?
    - Did I miss any requirements?
    - Are progressive disclosure tiers complete?

    **Discipline:**
    - Did I avoid overbuilding (YAGNI)?
    - Did I only build what was requested?
    - Did I follow existing patterns in the codebase?

    **Testing:**
    - Do tests actually verify behavior?
    - Is component portable (can run without external dependencies)?
    - Are tests comprehensive?

    If you find issues during self-review, fix them now before reporting.

    ## Report Format

    When done, report:
    - What you built
    - What you tested and test results
    - Files created/modified
    - Self-review findings (if any)
    - Any issues or concerns
    - Evidence of portability
```

## Usage

When dispatching a component builder subagent:

```bash
Task("Build Component: my-skill", {
  prompt: render_template("component-builder-prompt.md", {
    component_name: "my-skill",
    requirements: blueprint.requirements,
    context: "Building a portable skill for the Seed System",
    directory: "./worktree"
  })
})
```

## Key Principles

**Fresh Context:** Subagent gets complete information upfront, no file reading required

**Self-Contained:** All context needed to build the component is provided in the prompt

**Quality Gates:** Self-review checklist ensures quality before reporting

**Portability First:** Every component must work in isolation
