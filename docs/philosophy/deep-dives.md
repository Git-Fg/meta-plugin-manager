# Philosophy Deep Dives

The Seed System philosophy is distributed across the project rules directory:

| File | Layer | Content |
|------|-------|---------|
| principles.md | **Both** | Dual-layer architecture, Portability Invariant, Success Criteria |
| patterns.md | **Both** | Implementation patterns, Degrees of Freedom |
| anti-patterns.md | Behavioral | Recognition-based anti-patterns, quality validation |
| voice-and-freedom.md | **Both** | Voice guidance, Freedom matrix, Teaching patterns |
| askuserquestion-best-practices.md | Behavioral | Recognition over Generation, question strategies |

**Philosophy is universal**—Layer A guides the agent, Layer B is embedded in components.

## Core Seed System Principles

### The Portability Invariant

**Every component MUST be self-contained and work in a project with ZERO .claude/rules.**

This is the **defining characteristic** of the Seed System. Unlike traditional toolkits that create project-dependent components, the Seed System creates portable "organisms" that survive being moved to any environment.

### The Delta Standard

> **Good Component = Expert-only Knowledge − What Claude Already Knows**

Only include information with a knowledge delta—the gap between what Claude knows and what the component needs.

### Portability Principle

Components should work without depending on external documentation or files.

## The Seed System Philosophy

### Teaching > Prescribing
Philosophy enables intelligent adaptation. Process prescriptions create brittle systems.

### Trust > Control
Claude is smart. Provide principles, not recipes.

### Less > More
Context is expensive. Every token must earn its place.

### Intentional Redundancy
Philosophy must be duplicated where needed for portability. Components carry their own genetic code.

### Recognition over Generation
Users recognize faster than they generate. Structure interactions for validation, not brainstorming.
