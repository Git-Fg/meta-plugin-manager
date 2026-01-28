# Skills vs Commands: Project Core Practice

_Note: This distinction is a **project-specific architectural best practice** intended to provide structure, not a hard technical constraint._

## The Technical Reality

Under the hood, **Skills** and **Custom Slash Commands** are virtually identical (merged into the same `Skill` tool mechanism), while **Built-in Commands** (like `/init`) remain separate. By default, both are **Human and AI activated** (configurable via frontmatter), meaning the boundaries between them are flexible and depend on how you configure `disable-model-invocation`.

## Heuristics: Intent & Role

While the mechanism is shared, distinguishing them by **default behavior** helps keep your project organized:

- **Commands** → **User-Invoked Orchestrators (`/command`)**
  - **Preferred Intent**: Explicit human control over "high-stakes" or time-sensitive operations (e.g., `/deploy`, `/commit`).
  - **Role**: Typically serve as top-level entry points. While they often orchestrate underlying capabilities, they are best used when you want the "Human in the Loop" to be the trigger.
  - **Examples**: `/deploy`, `/commit`, `/code-review`, `/plan`.

- **Skills** → **Model-First Capabilities**
  - **Preferred Intent**: Contextual "know-how" that Claude can leverage automatically or recursively.
  - **Role**: Serve as reusable logic blocks. While often "atomic" (e.g., specific coding standards), **Skills can also act as complex orchestrators** that chain Commands or other Skills for ultra-specific, multi-stage workflows (e.g., a "Legacy Migration" Skill that might invoke `/audit` and `/plan` as steps).
  - **Examples**: `engineering-lifecycle`, `security-checklist`, `api-schema-reference`.

## Decision Matrix & Standards

Adopted from _Everything Claude Code_ standards:

| Feature             | **Commands** (`/command`)                        | **Skills** (`Context`)                 |
| :------------------ | :----------------------------------------------- | :------------------------------------- |
| **Typical Trigger** | **Human** (Explicit Intent)                      | **Model** (Contextual Need)            |
| **Best For**        | "Quick Actions" & Process Gates                  | "Deep Knowledge" & Recurring Workflows |
| **Scope**           | Project-specific tasks                           | Domain-specific capabilities           |
| **Activation**      | User runs `/command` (Auto-available if allowed) | Auto-activated or `/skill-name`        |
| **UX Pattern**      | **Imperative**: "Do this now"                    | **Declarative**: "Here is how to do X" |

### When to use what?

**Prefer a Command when:**

- You need a reliable "Button" to trigger a process that usually requires human confirmation (e.g., `deploy`, `audit`).
- The workflow acts as a strict gate or checkpoint in your development cycle.
- You want to alias a complex, frequently used prompt into a convenient shortcut.

**Prefer a Skill when:**

- You are encoding "How we do things" (e.g., "Our TDD process," "Security constraints").
- The logic is reusable across different contexts or should be available to the model without you explicitly asking for it every time.
- You want to define a sophisticated workflow that the model can manage autonomously (potentially calling other Commands as sub-steps).
