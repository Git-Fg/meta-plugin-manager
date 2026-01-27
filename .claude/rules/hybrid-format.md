# Rule: Hybrid Format Enforcement (Markdown + XML)

When creating or modifying documentation and skills (especially `SKILL.md`), you MUST adhere to the **Hybrid Approach**.

## The Principle

*   **Markdown (`#`, `##`, `1.`, `-`)**: Use for STRUCTURE and FLOW.
*   **XML (`<tag>`)**: Use for ISOLATION and HIGH PRIORITY items.

## Mandatory Structure for SKILL.md

1.  **Context**: Wrap dynamic data or state in `<context>`.
2.  **Constraints**: Wrap inviolable rules in `<absolute_constraints>`.
3.  **Logic**: Wrap complex branching/routing in `<router>` or `<decision_matrix>`.
4.  **Instructions**: Use standard Markdown headers and lists.

## Anti-Patterns (What NOT to do)

*   ❌ **Don't use XML for everything**: Do not wrap standard instructions in `<instructions>` tags. This wastes tokens.
*   ❌ **Don't use Markdown for critical rules**: Critical constraints nested in deep bullet points get lost. Use `<absolute_constraints>`.
*   ❌ **Don't mix data and instruction**: Never put `git diff` output directly in Markdown flow; always isolate it in `<context>`.

## Reference

See `docs/philosophy/hybrid-approach.md` for the full blueprint and rationale.
