---
description: "Perform an in-depth architectural review and comparison of documentation, rules, and instructions versus skills, commands, agents, and MCP servers."
---

## Objective
Perform an in-depth review and comparison, step by step, of all documentations, rules, and instructions versus skills, commands, agents, MCP, and other components.

## Scope of Analysis
You must treat this as a holistic web of dependencies, acknowledging that **Skills and Components often teach patterns to other Skills and Components**.

## Verification Requirements
1.  **Embodiment**: Verify that skills, components, and the codebase strictly embody what they (or other skills) teach.
2.  **Context Drift**: Verify there is no risk of context drift between the definition of a pattern and its usage.
3.  **Rule Placement**: Verify that all rules are defined in the correct place within the architecture.
4.  **Integrity Scan**:
    *   **Incoherence**: Find contradictory instructions between any two parts of the system.
    *   **Errors**: Identify logical flaws or broken references.
    *   **Duplicates**: Identify redundant rules or instructions that appear in multiple places.

## Success Criteria
The task is complete when you have produced a report detailing:
- [ ] Instances where components fail to embody the rules they are taught.
- [ ] Specific locations of context drift, misplaced rules, or duplicates.
- [ ] A list of incoherences or errors found during the review.