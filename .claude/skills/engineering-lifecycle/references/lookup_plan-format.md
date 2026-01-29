# PLAN.md Format Reference

Task types for plan execution and checkpoint types for human interaction.

## Task Types

| Type                      | Purpose                                | Execution Mode           |
| ------------------------- | -------------------------------------- | ------------------------ |
| `auto`                    | Claude executes autonomously           | Subagent or main context |
| `checkpoint:human-verify` | Human confirms Claude's automated work | Main context             |
| `checkpoint:decision`     | Human makes implementation choice      | Main context             |
| `checkpoint:human-action` | Truly unavoidable manual step          | Main context (rare)      |

## Golden Rule

**If Claude CAN automate it, Claude MUST automate it.**

## Checkpoint Types

### checkpoint:human-verify

When Claude completed automated work, human confirms it works correctly.

Use for:

- Visual UI checks (layout, styling, responsiveness)
- Interactive flows (click through wizard, test user flows)
- Functional verification (feature works as expected)
- Audio/video playback quality
- Accessibility testing

Structure:

```xml
### checkpoint:human-verify

<what-built>[What Claude automated]</what-built>
<how-to-verify>
  1. [Exact step 1]
  2. [Exact step 2]
</how-to-verify>
<resume-signal>Type "approved" or describe issues</resume-signal>
```

### checkpoint:decision

When human must make choice affecting implementation direction.

Use for:

- Technology selection (which auth provider, which database)
- Architecture decisions (monorepo vs separate repos)
- Design choices (color scheme, layout approach)
- Feature prioritization (which variant to build)
- Data model decisions (schema structure)

Structure:

```xml
### checkpoint:decision

<decision>[What's being decided]</decision>

## Context

[Why this decision matters]

## Options

##### option-a

<name>[Option name]</name>

## Pros

[Benefits]

## Cons

[Tradeoffs]

##### option-b

<name>[Option name]</name>

## Pros

[Benefits]

## Cons

[Tradeoffs]

<resume-signal>Select: option-a or option-b</resume-signal>
```

### checkpoint:human-action (Rare)

When action has NO CLI/API and requires human-only interaction.

Use ONLY for:

- Email verification links (no API)
- SMS 2FA codes (no API)
- Manual account approvals (platform requires human review)
- Credit card 3D Secure flows (web-based payment authorization)

Structure:

```xml
### checkpoint:human-action

<action>[What human must do]</action>
<instructions>
  [What Claude already automated]
  [The ONE thing requiring human action]
</instructions>

## Verification

[What Claude can check afterward]
<resume-signal>Type "done" when complete</resume-signal>
```

## Execution Protocol

When encountering `type="checkpoint:*"`:

1. Stop immediately - do not proceed to next task
2. Display checkpoint clearly with formatting
3. Wait for user response
4. Verify if possible
5. Resume execution after confirmation

## Checkpoint Placement

Place checkpoints:

- After automation completes - not before Claude does the work
- After UI buildout - before declaring phase complete
- Before dependent work - decisions before implementation
- At integration points - after configuring external services

## Checkpoint Priority

1. **checkpoint:human-verify** (90%) - Claude automated everything, human confirms
2. **checkpoint:decision** (9%) - Human makes architectural/technology choices
3. **checkpoint:human-action** (1%) - Truly unavoidable manual steps
