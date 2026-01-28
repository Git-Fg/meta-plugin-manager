# Development Workflow

## When Contributing to the Seed System

1. **Understand dual-layer architecture**: Layer A (behavioral) vs Layer B (construction)
2. **Check philosophy**: Consult project rules for guidance
3. **Apply patterns**: Use project rules for architectural enforcement
4. **Enforce portability**: Every component must work in isolation
5. **Test thoroughly**: Use `claude --dangerously-skip-permissions` for testing

## When Building Components with the Seed System

1. **Load knowledge**: Understand concepts via meta-skills
2. **Apply guidance**: Use meta-skills to generate components
3. **Check portability**: Ensure component works in isolation
4. **Test thoroughly**: Verify component works without external dependencies

## Plan Mode Workflow (CRITICAL)

**MANDATORY: Get user approval before proceeding to implementation.**

For any non-trivial task requiring multiple steps or file modifications:

1. **Phase 1 - Understanding**: Explore the codebase and understand requirements
2. **Phase 2 - Design**: Create detailed implementation plan in `/Users/felix/.claude/plans/[task-name].md`
3. **Phase 3 - Review**: Present plan to user and get explicit approval
4. **Phase 4 - Implementation**: Execute approved plan
5. **Phase 5 - Verification**: Confirm all tasks completed

**Why this matters**:

- Prevents blind implementation without understanding
- Ensures user approval before irreversible changes
- Creates audit trail of decisions and rationale
- Reduces rework and incorrect assumptions

**CRITICAL**: Never skip Phase 3 (Review) or jump directly to implementation without user approval.
