# Genetic Code Template

Condensed Seed System principles for automatic injection into new components. Ensures forked subagents retain core philosophy.

## Core Principles (Copy This Section)

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
MANDATORY: All components MUST be self-contained (zero .claude/rules dependency)

MANDATORY: Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)

MANDATORY: Description MUST use What-When-Not format in third person

MANDATORY: No component references another component by name in description

MANDATORY: Progressive disclosure - references/ for detailed content

MANDATORY: Use XML for control (mission_control, critical_constraint), Markdown for data

No exceptions. Portability invariant must be maintained.
</critical_constraint>

## Delta Standard

> **Good Component = Expert Knowledge − What Claude Already Knows**

Keep only:

- Project-specific architecture decisions
- Domain expertise not in general training
- Non-obvious bug workarounds
- Team-specific conventions

Remove:

- Basic programming concepts
- Standard library documentation
- Generic tutorials

## Portability Invariant

**Question**: "Would this component work in a project with zero .claude/rules?"

If NO: Fix self-containment issues before deployment.

## Trust but Verify

<critical_constraint>
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

Before claiming done:

- ✅ Read file → Trace logic → Confirm claim → Mark VERIFIED
- ✅ Portability check → Confirm works with zero rules dependencies
- ✅ Invocation tested → Component can be discovered from description alone
  </critical_constraint>

## Recognition Questions

When in doubt, ask:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Does this reference a file outside the component?" → Fix (external path)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming
