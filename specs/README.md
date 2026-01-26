# Specs Directory

**This is the Source of Truth for your component ecosystem.**

## Purpose

Ralph treats this directory as **System-Level Context**. Files here are automatically injected into every hat's context window before execution begins.

## Key Files

| File | Purpose | When Used |
|------|---------|-----------|
| `blueprint.yaml` | Architecture contract | CREATE/AUDIT/BATCH modes |
| `contracts.md` | I/O schemas for MCP/Agents | MCP/Agent components |

## The "Living Spec" Workflow

1. **Coordinator** writes `blueprint.yaml` → Architecture is LOCKED
2. **Ralph** injects blueprint into ALL downstream hats
3. **Test Designer** reads blueprint → Generates `test_spec.json`
4. **Ralph** reloads context
5. **Executor** reads blueprint + test_spec → Implements code
6. **Ralph** reloads context
7. **Validator** reads blueprint + logs → Performs Gap Analysis

## Why This Matters

Without `specs_dir`:
- Each hat must "remember" to read the blueprint
- Forgetting to read → hallucinated architecture
- Drift between spec and implementation

With `specs_dir`:
- Blueprint is **inherent** to every hat's context
- Architecture cannot be forgotten or ignored
- Continuous enforcement of the contract

## Templates

- `.blueprint_template.yaml` — Copy and customize for your system
- `.contracts_template.md` — Copy for MCP/Agent I/O schemas
